/*
* This file is a part of "SimpleAlert" project.
* Khaled Mohsen <pres.kbayomy@gmail.com>
* Copyrights (BSD-3-Clause), LICENSE.
*/

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'constants.dart';
import 'mixins/OpacityAnimationMixin.dart';
import 'mixins/WidthAnimationMixin.dart';
import 'simple_alert_preferences.dart';
import 'simple_alert_route.dart';
import 'alert.dart';
import 'progress_bar.dart';
import 'misc/simple_alert_icons.dart';
import 'enums/simple_alert_shape.dart';
import 'enums/simple_alert_duration.dart';
import 'enums/simple_alert_type.dart';

final ValueNotifier<Map<String, Map<String, dynamic>>> _simpleAlertsThatAreCurrentlyDisplayed =
    ValueNotifier<Map<String, Map<String, dynamic>>>({}); // {'route-name': {'size': Size, 'fromBottom': bool}}

/// Regular alert with preset colors for some common situations.
///
/// The parameters [context], and [label] are mandatory.
class SimpleAlert with OpacityAnimationMixin, WidthAnimationMixin {
  final BuildContext context;
  final String? routeName;
  final String title;
  final String? description;

  /// Currently: When more than one alert is displayed in the center of the screen at the same time,
  /// they will appear on top of each other.
  final AlignmentDirectional? alignmentDirectional;
  final double? width;
  final SimpleAlertShape? shape;
  final BorderRadius? borderRadius;
  final Brightness? brightness;
  final SimpleAlertType? type;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final SimpleAlertDuration? duration;
  final Duration? customDuration;
  final Duration animatedOpacityDuration;
  final bool loading;
  final bool centerContent;
  final bool closeOnPress;
  final bool withClose;
  final bool withProgressBar;
  final List<IconButton>? actions;
  final ValueNotifier<bool>? removalSignal;

  late final ShapeBorder selectedShape;
  late final SimpleAlertType simpleAlertType = (type ?? SimpleAlertPreferences().type);
  late final Brightness simpleAlertBrightness = (brightness ?? Theme.of(context).brightness);
  bool _closing = false;
  bool _stopDecreasingRemainingDuration = false;
  //////////////////////////
  final GlobalKey _alertKey = GlobalKey();
  BuildContext? _simpleAlertRouteContext;
  late String _simpleAlertRouteName;
  late Route _simpleAlertRoute;
  late final Duration _duration;
  final ValueNotifier<int?> _remainingDurationInMilliseconds = ValueNotifier<int?>(null);
  VoidCallback? _removalSignalListener;
  VoidCallback? _remainingDurationListener;
  late final bool _fromBottom = ([
    AlignmentDirectional.bottomStart,
    AlignmentDirectional.bottomCenter,
    AlignmentDirectional.bottomEnd,
  ].contains(alignmentDirectional));
  late final bool _fromCenter = ([
    AlignmentDirectional.centerStart,
    AlignmentDirectional.center,
    AlignmentDirectional.centerEnd,
  ].contains(alignmentDirectional));

  SimpleAlert({
    required this.context,
    this.routeName,
    required this.title,
    this.description,
    this.alignmentDirectional,
    this.width,
    this.shape,

    /// Has the priority over [shape].
    this.borderRadius,
    this.brightness,
    this.type,

    /// Has the priority over [type].
    this.backgroundColor,

    /// Has the priority over [SimpleAlertPreferences().titleStyle] and [SimpleAlertPreferences().descriptionStyle].
    this.foregroundColor,
    this.duration,
    this.customDuration,
    this.animatedOpacityDuration = const Duration(milliseconds: 250),

    /// Has the priority over the icon.
    this.loading = false,
    this.centerContent = false,
    this.closeOnPress = true,
    this.withClose = false,

    /// Has the priority over [closeOnPress].
    this.withProgressBar = false,
    this.actions,
    this.removalSignal,
  }) {
    _duration = _getDuration();
    _remainingDurationInMilliseconds.value = _duration.inMilliseconds;
    _simpleAlertRouteName = (routeName ?? 'SimpleAlert#${Random().nextInt(999999999)}');
    _simpleAlertRoute = SimpleAlertRoute(
      settings: RouteSettings(
        name: _simpleAlertRouteName,
      ),
      builder: (BuildContext context) {
        _simpleAlertRouteContext = context;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _simpleAlertsThatAreCurrentlyDisplayed.value = _simpleAlertsThatAreCurrentlyDisplayed.value
            ..addAll({
              _simpleAlertRouteName: {
                'size': (_alertKey.currentContext!.findRenderObject() as RenderBox).size,
                'fromBottom': _fromBottom,
                'fromCenter': _fromCenter,
              },
            });
          // _simpleAlertsThatAreCurrentlyDisplayed.notifyListeners(); // The alert doesn't have to tell itself that it's ready.

          _remainingDurationListener = () {
            if (_remainingDurationInMilliseconds.value! <= 0 && !_closing) _close();
          };

          Future.doWhile(
            () async {
              if (_remainingDurationInMilliseconds.value! <= 0 || _closing) return false;

              await Future.delayed(
                const Duration(milliseconds: 100),
              );

              if (!_stopDecreasingRemainingDuration && !_closing) {
                _remainingDurationInMilliseconds.value = (_remainingDurationInMilliseconds.value! - 100);
              }

              return true; // Continue
            },
          );

          _remainingDurationInMilliseconds.addListener(_remainingDurationListener!);
        });

        return PopScope(
          canPop: false,
          onPopInvoked: (bool status) {
            if (status) return;

            _close();
          },
          child: Alert(
            child: _build(context),
            animationController: opacityAnimationController,
            animatedOpacityDuration: animatedOpacityDuration,
          ),
        );
      },
    );

    Navigator.of(context).push(
      _simpleAlertRoute,
    );

    if (removalSignal != null) {
      _removalSignalListener = () {
        if (context.mounted && removalSignal!.value && !_closing) {
          _close();
        }
      };

      removalSignal!.addListener(_removalSignalListener!);
    }
  }

  SimpleAlert.loading({
    required BuildContext context,
    required String title,
    SimpleAlertType? type,
    SimpleAlertShape? shape,
    BorderRadius? borderRadius,
    ValueNotifier<bool>? removalSignal,
  }) : this(
          context: context,
          type: type,
          shape: shape,
          borderRadius: borderRadius,
          title: title,
          loading: true,
          closeOnPress: false,
          removalSignal: removalSignal,
        );

  Widget _build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    // final double screenHeight = MediaQuery.of(context).size.height;
    // final bool rtl = (Directionality.maybeOf(context) == TextDirection.rtl);
    final double? widthFromPreferences = ((SimpleAlertPreferences().getWidth != null) ? SimpleAlertPreferences().getWidth!() : null);
    final double alertWidth = (width ?? widthFromPreferences ?? MediaQuery.of(context).size.width);
    final Color foregroundColor = _getForegroundColor();

    return SafeArea(
      child: Stack(
        alignment: (alignmentDirectional ?? SimpleAlertPreferences().alignmentDirectional),
        fit: StackFit.expand,
        children: [
          // Alert
          ValueListenableBuilder(
            valueListenable: _simpleAlertsThatAreCurrentlyDisplayed,
            builder: (BuildContext context, Map<String, Map<String, dynamic>> simpleAlertsThatAreCurrentlyDisplayed, Widget? child) {
              final int indexOf = simpleAlertsThatAreCurrentlyDisplayed.keys.toList().indexOf(_simpleAlertRouteName); // All [Size]s before the current [SimpleAlert].
              final Iterable<Map<String, dynamic>> alertsDataOfSameDirection = simpleAlertsThatAreCurrentlyDisplayed.values
                  .take(
                    ((indexOf != -1) ? indexOf : simpleAlertsThatAreCurrentlyDisplayed.length),
                  )
                  .where((Map<String, dynamic> currentValue) => (currentValue['fromBottom']! == _fromBottom && currentValue['fromCenter']! == _fromCenter));
              // final int numberOfAlertsOfSameDirection = alertsDataOfSameDirection.length;
              final double topOrBottom = // Calculate the heights of the same direction.
                  alertsDataOfSameDirection.fold(
                0.0,
                (allValues, Map<String, dynamic> currentValue) => (allValues + currentValue['size']!.height),
              );

              /*print(simpleAlertsThatAreCurrentlyDisplayed);
              print('_fromBottom: $_fromBottom');
              print('_fromCenter: $_fromCenter');
              print('topOrBottom: $topOrBottom');*/

              // TODO: Check the "top" property when the device is rotated with alerts on the screen.
              return Positioned(
                key: _alertKey,
                width: alertWidth,
                top: ((!_fromBottom && !_fromCenter) ? topOrBottom : null), // TODO: [_fromCenter] = Center all alerts.
                bottom: (_fromBottom ? topOrBottom : null),
                child: Builder(
                  builder: (BuildContext context) => GestureDetector(
                    onTap: () {
                      if (closeOnPress && !withProgressBar) {
                        _close();
                      }
                    },
                    onTapDown: (withProgressBar
                        ? (TapDownDetails tapDownDetails) {
                            if (widthAnimationController.value != null) {
                              widthAnimationController.value!.stop(canceled: false);

                              _stopDecreasingRemainingDuration = true;
                            }
                          }
                        : null),
                    onTapUp: (withProgressBar
                        ? (TapUpDetails tapUpDetails) {
                            _stopDecreasingRemainingDuration = false;

                            if (widthAnimationController.value != null) {
                              widthAnimationController.value!.forward();
                            }
                          }
                        : null),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5.0),
                      padding: const EdgeInsets.symmetric(horizontal: 13.0),
                      child: ClipRRect(
                        borderRadius: _getBorderRadius(),
                        child: Material(
                          color: _getBackgroundColor(),
                          /*textStyle: const TextStyle(
                            color: Colors.white,
                          ),*/
                          child: Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: Theme(
                              data: themeData.copyWith(
                                iconTheme: themeData.iconTheme.copyWith(
                                  color: (SimpleAlertPreferences().iconsColor ?? foregroundColor),
                                ),
                                iconButtonTheme: IconButtonThemeData(
                                  style: (themeData.iconButtonTheme.style?.copyWith(
                                        foregroundColor: MaterialStatePropertyAll<Color>(
                                          (SimpleAlertPreferences().iconsColor ?? foregroundColor),
                                        ),
                                      ) ??
                                      ButtonStyle(
                                        foregroundColor: MaterialStatePropertyAll<Color>(
                                          (SimpleAlertPreferences().iconsColor ?? foregroundColor),
                                        ),
                                      )),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Row(
                                      children: [
                                        // Loading
                                        if (loading)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 9.0),
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white70,
                                              child: SizedBox.square(
                                                dimension: 18.0,
                                                child: CircularProgressIndicator(
                                                  color: _getBackgroundColor(),
                                                  strokeWidth: 2.0,
                                                ),
                                              ),
                                              radius: 15.0,
                                            ),
                                          ),

                                        // Icon
                                        if (!loading)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 9.0),
                                            child: _getIcon(),
                                          ),

                                        // Texts
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Title and description.
                                              Expanded(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: (centerContent ? CrossAxisAlignment.center : CrossAxisAlignment.start),
                                                  children: [
                                                    Text(
                                                      title,
                                                      style: (SimpleAlertPreferences().titleStyle).copyWith(
                                                        color: foregroundColor,
                                                      ),
                                                    ),
                                                    if (description != null) const SizedBox(height: 5.0),
                                                    if (description != null)
                                                      Text(
                                                        description!,
                                                        style: SimpleAlertPreferences().descriptionStyle.copyWith(
                                                              color: foregroundColor,
                                                            ),
                                                      ),
                                                  ],
                                                ),
                                              ),

                                              // Actions
                                              ConstrainedBox(
                                                constraints: const BoxConstraints(maxWidth: 92.0),
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      if (actions != null) ...actions!,

                                                      // Close
                                                      if (withClose)
                                                        IconButton(
                                                          onPressed: () => _close(),
                                                          icon: Icon(SimpleAlertPreferences().icons.close),
                                                          splashRadius: ICON_BUTTON_SPLASH_RADIUS,
                                                          tooltip: SimpleAlertPreferences().closeTooltip,
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (withProgressBar)
                                    Flexible(
                                      child: ProgressBar(
                                        animationController: widthAnimationController,
                                        alertWidth: alertWidth,
                                        alertDuration: _getDuration(),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Get the specified duration.
  ///
  /// Note: [customDuration] has the priority over the [duration].
  Duration _getDuration() {
    if (customDuration != null) return customDuration!;

    final SimpleAlertDuration simpleAlertDuration = (duration ?? SimpleAlertPreferences().duration);

    switch (simpleAlertDuration) {
      case SimpleAlertDuration.quick:
        return const Duration(seconds: 3);

      case SimpleAlertDuration.long:
        return const Duration(seconds: 8);

      case SimpleAlertDuration.day:
        return const Duration(days: 1);

      case SimpleAlertDuration.medium:
      default:
        return const Duration(seconds: 5);
    }
  }

  /// Get the appropriate shadow values based on the current [Brightness].
  /*Map<String, dynamic> _getShadowValues() {
    final Brightness currentContextBrightness = Theme.of(context).brightness;
    const double elevation = 7.0;
    const Color shadowLightColor = Colors.black45;
    const Color shadowDarkColor = Colors.black26;

    switch (brightness) {
      case SimpleAlertBrightness.dark:
        return {
          'shadowColor': shadowDarkColor,
          'elevation': elevation,
        };

      case SimpleAlertBrightness.light:
        return {
          'shadowColor': shadowLightColor,
          'elevation': elevation,
        };

      case SimpleAlertBrightness.system:
      default:
        return {
          'shadowColor': (currentContextBrightness == Brightness.light) ? shadowLightColor : shadowDarkColor,
          'elevation': elevation,
        };
    }
  }*/

  /// Get the alert background color.
  Color _getBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;

    final bool light = (simpleAlertBrightness == Brightness.light);

    switch (simpleAlertType) {
      case SimpleAlertType.normal:
        return (light ? const Color.fromRGBO(105, 105, 105, 1.0) : const Color.fromRGBO(229, 228, 226, 1.0));

      case SimpleAlertType.success:
        return (light ? const Color.fromRGBO(46, 139, 87, 1.0) : const Color.fromRGBO(80, 200, 120, 1.0));

      case SimpleAlertType.warning:
        return (light ? const Color.fromRGBO(239, 155, 15, 1.0) : const Color.fromRGBO(255, 191, 0, 1.0));

      case SimpleAlertType.danger:
        return (light ? const Color.fromRGBO(197, 30, 58, 1.0) : const Color.fromRGBO(251, 96, 127, 1.0));

      case SimpleAlertType.info:
      default:
        return (light ? const Color.fromRGBO(34, 76, 152, 1.0) : const Color.fromRGBO(135, 206, 250, 1.0));
    }
  }

  /// Get the alert foreground color.
  Color _getForegroundColor() {
    if (foregroundColor != null) return foregroundColor!;

    switch (simpleAlertBrightness) {
      case Brightness.dark:
        return Colors.black;

      case Brightness.light:
      default:
        return Colors.white;
    }
  }

  /// Get the alert border radius.
  ///
  /// Note: [borderRadius] has the priority over the [shape].
  BorderRadius _getBorderRadius() {
    final BorderRadius? simpleAlertBorderRadius = (borderRadius ?? SimpleAlertPreferences().borderRadius);

    if (simpleAlertBorderRadius != null) return simpleAlertBorderRadius;

    final SimpleAlertShape simpleAlertShape = (shape ?? SimpleAlertPreferences().shape);

    switch (simpleAlertShape) {
      case SimpleAlertShape.defaultRadius:
        return BorderRadius.circular(BORDER_RADIUS);

      case SimpleAlertShape.sharp:
        return BorderRadius.zero;

      case SimpleAlertShape.rounded:
      default:
        return BorderRadius.circular(255.0);
    }
  }

  /// Get the appropriate alert icon according to its type.
  Icon _getIcon() {
    final SimpleAlertIcons icons = SimpleAlertPreferences().icons;
    final double size = SimpleAlertPreferences().iconsSize;

    switch (simpleAlertType) {
      case SimpleAlertType.normal:
        return Icon(
          icons.normal,
          size: size,
        );

      case SimpleAlertType.success:
        return Icon(
          icons.success,
          size: size,
        );

      case SimpleAlertType.warning:
        return Icon(
          icons.warning,
          size: size,
        );

      case SimpleAlertType.danger:
        return Icon(
          icons.danger,
          size: size,
        );

      case SimpleAlertType.info:
      default:
        return Icon(
          icons.info,
          size: size,
        );
    }
  }

  /// Close the alert.
  void _close() {
    // The close button or the alarm can be pressed more than once because the degree of opacity (animation) is constantly changing,
    // which will cause the function to run more than once and cause errors.
    if (_closing) return;

    _closing = true;

    removalSignal?.removeListener(_removalSignalListener!);

    if (_remainingDurationInMilliseconds.value != null) {
      _remainingDurationInMilliseconds.removeListener(_remainingDurationListener!);
    }

    if (_simpleAlertRouteContext!.mounted) {
      opacityAnimationController.value!.reverse().whenComplete(() {
        Navigator.of(_simpleAlertRouteContext!).removeRoute(
          _simpleAlertRoute,
        );

        _simpleAlertsThatAreCurrentlyDisplayed.value = _simpleAlertsThatAreCurrentlyDisplayed.value..remove(_simpleAlertRouteName);
        _simpleAlertsThatAreCurrentlyDisplayed.notifyListeners();
      });
    }
  }
}

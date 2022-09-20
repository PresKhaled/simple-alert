/*
* This file is a part of "SimpleAlert" project.
* Khaled Mohsen <pres.kbayomy@gmail.com>
* Copyrights (BSD-3-Clause), LICENSE.
*/
import 'package:flutter/material.dart';

import '../simple_alert.dart';
import 'Alert.dart';
import 'mixins/AnimationMixin.dart';

/// Regular alert with preset colors for some common situations.
///
/// The parameters [context], and [label] are mandatory.
class SimpleAlert with AnimationMixin {
  final BuildContext context;
  final SimpleAlertType type;
  final Alignment alignment;
  final SimpleAlertDuration duration;
  final Duration? customDuration;
  final BorderRadius? borderRadius;
  late final Map<String, dynamic> shadowValues;
  Color? backgroundColor;
  final SimpleAlertBrightness brightness;
  final SimpleAlertShape shape;
  late final ShapeBorder selectedShape;
  final TextDirection? textDirection;
  final Widget? leading;
  final bool loading; // Has the priority over [leading].
  final String title;
  final TextStyle labelStyle;
  final String? subTitle;
  final TextStyle subTitleStyle;
  late final OverlayEntry _overlayEntry;
  late final Future _delayedFuture;
  final ValueNotifier<bool>? remove;
  final Duration animatedOpacityDuration;

  SimpleAlert({
    required this.context,
    required this.title,
    this.type = SimpleAlertType.normal,
    this.duration = SimpleAlertDuration.quick,
    this.customDuration,
    this.textDirection,
    this.alignment = Alignment.topCenter,
    this.backgroundColor,
    this.brightness = SimpleAlertBrightness.light,
    this.leading,
    this.loading = false,
    this.borderRadius,
    this.shape = SimpleAlertShape.defaultRadius,
    this.labelStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    this.subTitle,
    this.subTitleStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    this.animatedOpacityDuration = const Duration(milliseconds: 300),
    this.remove,
  }) {
    shadowValues = _getShadowValues();

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Alert(
        child: _build(context),
        animationController: animationController,
        animatedOpacityDuration: animatedOpacityDuration,
      ),
    );

    Overlay.of(context)?.insert(_overlayEntry);

    // Wait for initializing.
    animationController.addListener(() {
      final AnimationController? controller = animationController.value;

      if (controller != null) controller.forward();
    });

    _delayedFuture = Future.delayed(_getDuration()).whenComplete(() {
      animationController.value!.reverse().whenComplete(() => _overlayEntry.remove());
    });

    if (remove != null) {
      remove!.addListener(() {
        if (_overlayEntry.mounted && remove!.value) {
          _delayedFuture.ignore();
          _overlayEntry.remove();
        }
      });
    }
  }

  Widget _build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: alignment,
        child: Directionality(
          textDirection: (textDirection ?? Directionality.maybeOf(context) ?? TextDirection.ltr),
          child: Container(
            width: (MediaQuery.of(context).size.width / 1.5),
            margin: const EdgeInsets.symmetric(vertical: 41.0),
            child: ClipRRect(
              borderRadius: _getBorderRadius(),
              child: Material(
                color: _getBackgroundColor(),
                textStyle: const TextStyle(
                  color: Colors.white,
                ),
                elevation: shadowValues['elevation'],
                shadowColor: shadowValues['color'],
                child: InkWell(
                  onTap: () {
                    animationController.value!.reverse().whenComplete(() {
                      _delayedFuture.ignore();
                      _overlayEntry.remove();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 11.0),
                    child: Row(
                      children: [
                        if (loading)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 9.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.white70,
                              child: SizedBox(
                                width: 17.0,
                                height: 17.0,
                                child: CircularProgressIndicator(
                                  color: _getBackgroundColor(),
                                  strokeWidth: 2.0,
                                ),
                              ),
                              radius: 15.0,
                            ),
                          ),
                        if (!loading && leading != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 9.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: leading,
                              radius: 15.0,
                            ),
                          ),
                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: labelStyle,
                              ),
                              if (subTitle != null)
                                Text(
                                  subTitle!,
                                  style: subTitleStyle,
                                ),
                            ],
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
  }

  // Get the specified duration.
  ///
  /// Note: [customDuration] has the priority over the [duration].
  Duration _getDuration() {
    if (customDuration != null) return customDuration!;

    switch (duration) {
      case SimpleAlertDuration.medium:
        return const Duration(seconds: 5);

      case SimpleAlertDuration.long:
        return const Duration(seconds: 7);

      case SimpleAlertDuration.day:
        return const Duration(days: 1);

      case SimpleAlertDuration.quick:
      default:
        return const Duration(seconds: 3);
    }
  }

  /// Get the appropriate shadow values based on the current [Brightness].
  _getShadowValues() {
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
  }

  /// Get the alert background color.
  ///
  /// Note: [color] takes precedence over color [type].
  Color _getBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;

    switch (type) {
      case SimpleAlertType.success:
        return Colors.green;

      case SimpleAlertType.failed:
        return Colors.red;

      case SimpleAlertType.info:
        return Colors.lightBlue;

      case SimpleAlertType.normal:
        return Colors.grey;

      default:
        return Colors.white;
    }
  }

  /// Get the alert border radius.
  ///
  /// Note: [borderRadius] has the priority over the [shape].
  _getBorderRadius() {
    if (borderRadius != null) return borderRadius!;

    switch (shape) {
      case SimpleAlertShape.defaultRadius:
        return BorderRadius.circular(5.0);

      case SimpleAlertShape.sharp:
        return BorderRadius.circular(0.0);

      case SimpleAlertShape.rounded:
      default:
        return BorderRadius.circular(255.0);
    }
  }
}

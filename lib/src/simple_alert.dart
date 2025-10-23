/*
* This file is a part of "SimpleAlert" project.
* Khaled Mohsen <pres.kbayomy@gmail.com>
* Copyrights (BSD-3-Clause), LICENSE.
*/

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_alert/src/progress_bar.dart';
import 'package:simple_alert/src/simple_alert_route.dart';

import '../simple_alert.dart';
import 'alert.dart';
import 'constants.dart';
import 'mixins/OpacityAnimationMixin.dart';
import 'mixins/WidthAnimationMixin.dart';

// ============================================================================
// Core Alert Manager (Backend Layer)
// ============================================================================

/// Manages the state and lifecycle of all displayed alerts.
/// This class separates business logic from UI concerns.
class _AlertManager {
  static final _AlertManager _instance = _AlertManager._internal();
  factory _AlertManager() => _instance;
  _AlertManager._internal();

  final ValueNotifier<Map<String, _AlertData>> _displayedAlerts = ValueNotifier<Map<String, _AlertData>>({});

  ValueNotifier<Map<String, _AlertData>> get displayedAlerts => _displayedAlerts;

  void registerAlert(String routeName, _AlertData data) {
    _displayedAlerts.value = {
      ..._displayedAlerts.value,
      routeName: data,
    };
  }

  void unregisterAlert(String routeName) {
    if (_displayedAlerts.value.containsKey(routeName)) {
      final newMap = Map<String, _AlertData>.from(_displayedAlerts.value);
      newMap.remove(routeName);
      _displayedAlerts.value = newMap;
    }
  }

  void updateAlertSize(String routeName, Size size) {
    if (_displayedAlerts.value.containsKey(routeName)) {
      final data = _displayedAlerts.value[routeName]!;
      data.size = size;
      _displayedAlerts.notifyListeners();
    }
  }

  List<_AlertData> getAlertsInSameDirection(
    String currentRouteName,
    AlignmentDirectional alignment,
  ) {
    final alerts = _displayedAlerts.value;
    final keys = alerts.keys.toList();
    final currentIndex = keys.indexOf(currentRouteName);

    if (currentIndex == -1) return [];

    final bool fromTop = _isTopAligned(alignment);
    final bool fromCenter = _isCenterAligned(alignment);
    final bool fromBottom = _isBottomAligned(alignment);

    return keys.take(currentIndex).map((key) => alerts[key]!).where((data) => data.fromTop == fromTop && data.fromCenter == fromCenter && data.fromBottom == fromBottom).toList();
  }

  static bool _isTopAligned(AlignmentDirectional alignment) {
    return [
      AlignmentDirectional.topStart,
      AlignmentDirectional.topCenter,
      AlignmentDirectional.topEnd,
    ].contains(alignment);
  }

  static bool _isCenterAligned(AlignmentDirectional alignment) {
    return [
      AlignmentDirectional.centerStart,
      AlignmentDirectional.center,
      AlignmentDirectional.centerEnd,
    ].contains(alignment);
  }

  static bool _isBottomAligned(AlignmentDirectional alignment) {
    return [
      AlignmentDirectional.bottomStart,
      AlignmentDirectional.bottomCenter,
      AlignmentDirectional.bottomEnd,
    ].contains(alignment);
  }

  void dispose() {
    _displayedAlerts.dispose();
  }
}

/// Data model for alert information.
class _AlertData {
  Size size;
  final bool fromTop;
  final bool fromCenter;
  final bool fromBottom;

  _AlertData({
    required this.size,
    required this.fromTop,
    required this.fromCenter,
    required this.fromBottom,
  });
}

// ============================================================================
// Timer Controller (Backend Layer)
// ============================================================================

/// Manages the countdown timer for alert auto-dismissal.
class _AlertTimerController {
  final Duration duration;
  final ValueNotifier<int> remainingMilliseconds;
  final VoidCallback onComplete;

  Timer? _timer;
  bool _isPaused = false;
  bool _isDisposed = false;

  _AlertTimerController({
    required this.duration,
    required this.onComplete,
  }) : remainingMilliseconds = ValueNotifier<int>(duration.inMilliseconds);

  void start() {
    if (_isDisposed) return;

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      if (!_isPaused && remainingMilliseconds.value > 0) {
        remainingMilliseconds.value -= 100;

        if (remainingMilliseconds.value <= 0) {
          onComplete();
        }
      }
    });
  }

  void pause() {
    _isPaused = true;
  }

  void resume() {
    _isPaused = false;
  }

  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _timer = null;
    remainingMilliseconds.dispose();
  }
}

// ============================================================================
// SimpleAlert Main Class (Presentation Layer)
// ============================================================================

/// A comprehensive alert system that displays customizable alerts using `Overlay` and `Route`.
///
/// `SimpleAlert` supports displaying multiple alerts simultaneously, automatic positioning
/// based on alignment, and responsive handling of device orientation changes.
/// Alerts can be configured with different types (e.g., success, warning), durations,
/// custom backgrounds, foreground colors, and interactive elements like progress bars
/// or action buttons.
///
/// Example of a basic alert:
/// ```dart
/// SimpleAlert(
///   context: context,
///   title: 'Success!',
///   description: 'Your operation was completed successfully.',
///   type: SimpleAlertType.success,
///   duration: SimpleAlertDuration.quick,
/// ).show();
/// ```
///
/// Example of a loading alert:
/// ```dart
/// final stopSignal = ValueNotifier<bool>(false);
/// SimpleAlert.loading(
///   context: context,
///   title: 'Processing...',
///   removalSignal: stopSignal,
/// ).show();
/// // To dismiss: stopSignal.value = true;
/// ```
class SimpleAlert with OpacityAnimationMixin, WidthAnimationMixin {
  // Configuration Properties
  final BuildContext context;
  final String? routeName;
  final String title;
  final String? description;
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

  // Computed Properties
  late final SimpleAlertType _resolvedType;
  late final Brightness _resolvedBrightness;
  late final AlignmentDirectional _resolvedAlignment;
  late final Duration _resolvedDuration;

  // Internal State
  final _AlertManager _alertManager = _AlertManager();
  late final String _routeName;
  late final Route<void> _route;
  late final _AlertTimerController _timerController;

  final GlobalKey _alertKey = GlobalKey();
  BuildContext? _routeContext;
  Orientation? _currentOrientation;

  bool _isClosing = false;
  VoidCallback? _removalSignalListener;

  /// Creates a [SimpleAlert] instance with specified properties.
  SimpleAlert({
    required this.context,
    this.routeName,
    required this.title,
    this.description,
    this.alignmentDirectional,
    this.width,
    this.shape,
    this.borderRadius,
    this.brightness,
    this.type,
    this.backgroundColor,
    this.foregroundColor,
    this.duration,
    this.customDuration,
    this.animatedOpacityDuration = const Duration(milliseconds: 250),
    this.loading = false,
    this.centerContent = false,
    this.closeOnPress = true,
    this.withClose = false,
    this.withProgressBar = false,
    this.actions,
    this.removalSignal,
  }) {
    _validateInputs();
    _initializeProperties();
    _setupTimerController();
    _setupRemovalSignal();
    _buildRoute();
  }

  /// Creates a loading [SimpleAlert] instance.
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

  // ============================================================================
  // Initialization Methods
  // ============================================================================

  void _validateInputs() {
    assert(title.isNotEmpty, 'Title cannot be empty');

    if (customDuration != null && customDuration!.inMilliseconds <= 0) {
      throw ArgumentError('Custom duration must be positive');
    }

    if (width != null && width! <= 0) {
      throw ArgumentError('Width must be positive');
    }
  }

  void _initializeProperties() {
    _resolvedType = type ?? SimpleAlertPreferences().type;
    _resolvedBrightness = brightness ?? Theme.of(context).brightness;
    _resolvedAlignment = alignmentDirectional ?? SimpleAlertPreferences().alignmentDirectional;
    _resolvedDuration = _calculateDuration();
    _routeName = routeName ?? 'SimpleAlert#${Random().nextInt(999999999)}';
  }

  void _setupTimerController() {
    _timerController = _AlertTimerController(
      duration: _resolvedDuration,
      onComplete: _close,
    );
  }

  void _setupRemovalSignal() {
    if (removalSignal != null) {
      _removalSignalListener = () {
        if (context.mounted && removalSignal!.value && !_isClosing) {
          _close();
        }
      };
      removalSignal!.addListener(_removalSignalListener!);
    }
  }

  void _buildRoute() {
    _route = SimpleAlertRoute(
      settings: RouteSettings(name: _routeName),
      builder: _buildRouteContent,
    );
  }

  // ============================================================================
  // Route Building
  // ============================================================================

  Widget _buildRouteContent(BuildContext context) {
    _routeContext = context;
    _currentOrientation ??= MediaQuery.orientationOf(context);

    WidgetsBinding.instance.addPostFrameCallback((_) => _onFirstFrameBuilt());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) _close();
      },
      child: Alert(
        animationController: opacityAnimationController,
        animatedOpacityDuration: animatedOpacityDuration,
        child: _buildAlertContent(context),
      ),
    );
  }

  void _onFirstFrameBuilt() {
    if (_alertKey.currentContext == null) return;

    final renderBox = _alertKey.currentContext!.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final alertData = _AlertData(
      size: renderBox.size,
      fromTop: _AlertManager._isTopAligned(_resolvedAlignment),
      fromCenter: _AlertManager._isCenterAligned(_resolvedAlignment),
      fromBottom: _AlertManager._isBottomAligned(_resolvedAlignment),
    );

    _alertManager.registerAlert(_routeName, alertData);
    _timerController.start();
  }

  // ============================================================================
  // UI Building
  // ============================================================================

  Widget _buildAlertContent(BuildContext context) {
    return SafeArea(
      child: OrientationBuilder(
        builder: (context, orientation) {
          _handleOrientationChange(orientation);
          return _buildPositionedAlert(context, orientation);
        },
      ),
    );
  }

  void _handleOrientationChange(Orientation orientation) {
    if (_currentOrientation != orientation) {
      _currentOrientation = orientation;

      // Update sizes for all alerts after orientation change
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (final routeName in _alertManager.displayedAlerts.value.keys) {
          final key = _alertKey;
          if (key.currentContext != null) {
            final renderBox = key.currentContext!.findRenderObject() as RenderBox?;
            if (renderBox != null && renderBox.hasSize) {
              _alertManager.updateAlertSize(routeName, renderBox.size);
            }
          }
        }
      });
    }
  }

  Widget _buildPositionedAlert(BuildContext context, Orientation orientation) {
    final mediaSize = MediaQuery.sizeOf(context);
    final alertWidth = _calculateAlertWidth(mediaSize.width);

    return Stack(
      alignment: _resolvedAlignment,
      fit: StackFit.expand,
      children: [
        ValueListenableBuilder<Map<String, _AlertData>>(
          valueListenable: _alertManager.displayedAlerts,
          builder: (context, displayedAlerts, child) {
            final offsetY = _calculateVerticalOffset(
              displayedAlerts,
              orientation,
              mediaSize.height,
            );

            return Positioned(
              key: _alertKey,
              width: alertWidth,
              top: (_AlertManager._isTopAligned(_resolvedAlignment) || _AlertManager._isCenterAligned(_resolvedAlignment)) ? offsetY : null,
              bottom: _AlertManager._isBottomAligned(_resolvedAlignment) ? offsetY : null,
              child: _buildAlertContainer(context, alertWidth),
            );
          },
        ),
      ],
    );
  }

  double _calculateAlertWidth(double screenWidth) {
    if (width != null) return width!;

    final widthFromPreferences = SimpleAlertPreferences().getWidth?.call();
    return widthFromPreferences ?? screenWidth;
  }

  double _calculateVerticalOffset(
    Map<String, _AlertData> displayedAlerts,
    Orientation orientation,
    double screenHeight,
  ) {
    final previousAlerts = _alertManager.getAlertsInSameDirection(
      _routeName,
      _resolvedAlignment,
    );

    final averageHeight = orientation == Orientation.portrait ? 70.0 : 50.0;
    final baseOffset = _AlertManager._isCenterAligned(_resolvedAlignment) ? (screenHeight / 2) - averageHeight : 0.0;

    return previousAlerts.fold<double>(
      baseOffset,
      (offset, data) => offset + data.size.height,
    );
  }

  Widget _buildAlertContainer(BuildContext context, double alertWidth) {
    return Semantics(
      container: true,
      liveRegion: true,
      label: 'تنبيه: $title',
      hint: description ?? '',
      child: GestureDetector(
        onTap: _handleTap,
        onTapDown: withProgressBar ? _handleTapDown : null,
        onTapUp: withProgressBar ? _handleTapUp : null,
        onTapCancel: withProgressBar ? _handleTapCancel : null,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          padding: const EdgeInsets.symmetric(horizontal: 13.0),
          child: ClipRRect(
            borderRadius: _getBorderRadius(),
            child: Material(
              color: _getBackgroundColor(),
              child: Padding(
                padding: const EdgeInsets.all(11.0),
                child: _buildAlertContent2(context, alertWidth),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertContent2(BuildContext context, double alertWidth) {
    final themeData = Theme.of(context);
    final foregroundColor = _getForegroundColor();

    return Theme(
      data: themeData.copyWith(
        iconTheme: themeData.iconTheme.copyWith(
          color: SimpleAlertPreferences().iconsColor ?? foregroundColor,
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll<Color>(
              SimpleAlertPreferences().iconsColor ?? foregroundColor,
            ),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Row(
              children: [
                _buildLeadingIcon(foregroundColor),
                Expanded(child: _buildContentSection(foregroundColor)),
              ],
            ),
          ),
          if (withProgressBar)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ProgressBar(
                  animationController: widthAnimationController,
                  alertWidth: alertWidth,
                  alertDuration: _resolvedDuration,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLeadingIcon(Color foregroundColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9.0),
      child: loading
          ? Semantics(
              label: 'مؤشر التحميل',
              child: CircleAvatar(
                backgroundColor: Colors.white70,
                radius: 15.0,
                child: SizedBox.square(
                  dimension: 18.0,
                  child: CircularProgressIndicator(
                    color: _getBackgroundColor(),
                    strokeWidth: 2.0,
                  ),
                ),
              ),
            )
          : _getIcon(),
    );
  }

  Widget _buildContentSection(Color foregroundColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _buildTextContent(foregroundColor)),
        _buildActionsSection(),
      ],
    );
  }

  Widget _buildTextContent(Color foregroundColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: centerContent ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: SimpleAlertPreferences().titleStyle.copyWith(
                color: foregroundColor,
              ),
        ),
        if (description != null) ...[
          const SizedBox(height: 5.0),
          Text(
            description!,
            style: SimpleAlertPreferences().descriptionStyle.copyWith(
                  color: foregroundColor,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionsSection() {
    if (actions == null && !withClose) {
      return const SizedBox.shrink();
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 92.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (actions != null) ...actions!,
            if (withClose)
              IconButton(
                onPressed: _close,
                icon: Icon(SimpleAlertPreferences().icons.close),
                splashRadius: ICON_BUTTON_SPLASH_RADIUS,
                tooltip: SimpleAlertPreferences().closeTooltip,
              ),
          ],
        ),
      ),
    );
  }

  // ============================================================================
  // Gesture Handlers
  // ============================================================================

  void _handleTap() {
    if (closeOnPress && !withProgressBar) {
      _close();
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (widthAnimationController.value != null) {
      widthAnimationController.value!.stop(canceled: false);
      _timerController.pause();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _resumeTimer();
  }

  void _handleTapCancel() {
    _resumeTimer();
  }

  void _resumeTimer() {
    _timerController.resume();
    if (widthAnimationController.value != null) {
      widthAnimationController.value!.forward();
    }
  }

  // ============================================================================
  // Helper Methods
  // ============================================================================

  Duration _calculateDuration() {
    if (customDuration != null) return customDuration!;

    final alertDuration = duration ?? SimpleAlertPreferences().duration;

    return switch (alertDuration) {
      SimpleAlertDuration.quick => const Duration(seconds: 3),
      SimpleAlertDuration.long => const Duration(seconds: 8),
      SimpleAlertDuration.day => const Duration(days: 1),
      SimpleAlertDuration.medium => const Duration(seconds: 5),
    };
  }

  Color _getBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;

    final isLight = _resolvedBrightness == Brightness.light;

    return switch (_resolvedType) {
      SimpleAlertType.normal => isLight ? const Color.fromRGBO(105, 105, 105, 1.0) : const Color.fromRGBO(229, 228, 226, 1.0),
      SimpleAlertType.success => isLight ? const Color.fromRGBO(46, 139, 87, 1.0) : const Color.fromRGBO(80, 200, 120, 1.0),
      SimpleAlertType.warning => isLight ? const Color.fromRGBO(239, 155, 15, 1.0) : const Color.fromRGBO(255, 191, 0, 1.0),
      SimpleAlertType.danger => isLight ? const Color.fromRGBO(197, 30, 58, 1.0) : const Color.fromRGBO(251, 96, 127, 1.0),
      SimpleAlertType.info => isLight ? const Color.fromRGBO(34, 76, 152, 1.0) : const Color.fromRGBO(135, 206, 250, 1.0),
    };
  }

  Color _getForegroundColor() {
    if (foregroundColor != null) return foregroundColor!;

    return _resolvedBrightness == Brightness.dark ? Colors.black : Colors.white;
  }

  BorderRadius _getBorderRadius() {
    if (borderRadius != null) return borderRadius!;

    final preferenceBorderRadius = SimpleAlertPreferences().borderRadius;
    if (preferenceBorderRadius != null) return preferenceBorderRadius;

    final alertShape = shape ?? SimpleAlertPreferences().shape;

    return switch (alertShape) {
      SimpleAlertShape.defaultRadius => BorderRadius.circular(BORDER_RADIUS),
      SimpleAlertShape.sharp => BorderRadius.zero,
      SimpleAlertShape.rounded => BorderRadius.circular(255.0),
    };
  }

  Icon _getIcon() {
    final icons = SimpleAlertPreferences().icons;
    final size = SimpleAlertPreferences().iconsSize;

    final (iconData, semanticLabel) = switch (_resolvedType) {
      SimpleAlertType.normal => (icons.normal, 'أيقونة تنبيه عادي'),
      SimpleAlertType.success => (icons.success, 'أيقونة نجاح'),
      SimpleAlertType.warning => (icons.warning, 'أيقونة تحذير'),
      SimpleAlertType.danger => (icons.danger, 'أيقونة خطر'),
      SimpleAlertType.info => (icons.info, 'أيقونة معلومات'),
    };

    return Icon(
      iconData,
      size: size,
      semanticLabel: semanticLabel,
    );
  }

  // ============================================================================
  // Lifecycle Methods
  // ============================================================================

  Future<void> _close() async {
    if (_isClosing) return;
    _isClosing = true;

    _cleanup();

    if (_routeContext != null && _routeContext!.mounted) {
      await opacityAnimationController.value?.reverse();

      if (Navigator.canPop(_routeContext!) && _route.isActive) {
        Navigator.maybeOf(_routeContext!)?.removeRoute(_route);
      }
    }

    _alertManager.unregisterAlert(_routeName);
  }

  void _cleanup() {
    if (_removalSignalListener != null) {
      removalSignal?.removeListener(_removalSignalListener!);
      _removalSignalListener = null;
    }

    _timerController.dispose();
  }

  /// Displays the [SimpleAlert] by pushing it onto the Navigator.
  void show() {
    if (!context.mounted) {
      throw StateError('Cannot show alert: context is not mounted');
    }

    Navigator.of(context).push(_route).whenComplete(_close);
  }
}

/*
* This file is a part of "SimpleAlert" project.
* Khaled Mohsen <pres.kbayomy@gmail.com>
* Copyrights (BSD-3-Clause), LICENSE.
*/

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../i18n/translations.g.dart';
import '../simple_alert.dart';
import 'backend/alert_manager.dart';
import 'backend/alert_timer_controller.dart';
import 'misc/constants.dart';
import 'mixins/simple_alert_opacity_animation_mixin.dart';
import 'mixins/simple_alert_width_animation_mixin.dart';
import 'widgets/simple_alert_route_content.dart';

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
  /// The build context from which the alert is shown.
  final BuildContext context;

  /// An optional unique name for the alert's route. If null, a random one is generated.
  final String? routeName;

  /// The main title text displayed in the alert.
  final String title;

  /// An optional detailed description text for the alert.
  final String? description;

  /// The alignment of the alert on the screen. Defaults to [SimpleAlertPreferences().alignmentDirectional].
  final AlignmentDirectional? alignmentDirectional;

  /// The specified width of the alert. If null, it will default to the screen width or a preference.
  final double? width;

  /// An optional explicit text direction override for the alert.
  final TextDirection? textDirection;

  /// Whether tactile haptic feedback is triggered when the alert is shown.
  final bool? enableHapticFeedback;

  /// The shape of the alert container. Defaults to [SimpleAlertPreferences().shape].
  final SimpleAlertShape? shape;

  /// The border radius for the alert's corners. Overrides [shape] if specified.
  final BorderRadius? borderRadius;

  /// The brightness theme for the alert. Defaults to the current `Theme.of(context).brightness`.
  final Brightness? brightness;

  /// The predefined type of the alert (e.g., success, warning). Defaults to [SimpleAlertPreferences().type].
  final SimpleAlertType? type;

  /// The background color of the alert. Overrides the default color based on [type] and [brightness].
  final Color? backgroundColor;

  /// The foreground color of the alert (text, icons). Overrides the default color based on [brightness].
  final Color? foregroundColor;

  /// The predefined duration for auto-dismissal. Defaults to [SimpleAlertPreferences().duration].
  final SimpleAlertDuration? duration;

  /// A custom duration for auto-dismissal. Overrides [duration] if specified.
  final Duration? customDuration;

  /// The duration of the opacity animation when the alert appears or disappears.
  final Duration animatedOpacityDuration;

  /// If true, the alert will display a loading indicator instead of a type icon.
  final bool loading;

  /// If true, the alert's content (title and description) will be horizontally centered.
  final bool centerContent;

  /// If true, the alert will close when pressed, unless [withProgressBar] is true.
  final bool closeOnPress;

  /// If true, a close button will be displayed in the alert.
  final bool withClose;

  /// If true, a progress bar indicating the remaining duration will be displayed.
  final bool withProgressBar;

  /// An optional list of [IconButton] widgets to display as actions in the alert.
  final List<IconButton>? actions;

  /// An optional [ValueNotifier<bool>] that, when its value becomes true, triggers the alert's dismissal.
  final ValueNotifier<bool>? removalSignal;

  // Computed Properties
  /// The resolved alert type, either specified or from preferences.
  late final SimpleAlertType _resolvedType;

  /// The resolved brightness theme, either specified or from the context.
  late final Brightness _resolvedBrightness;

  /// The resolved alignment for the alert, either specified or from preferences.
  late final AlignmentDirectional _resolvedAlignment;

  /// The resolved duration for the alert's display time.
  late final Duration _resolvedDuration;

  // Internal State
  /// The alert manager responsible for tracking active alerts.
  final AlertManager _alertManager = AlertManager();

  /// The unique route name for this specific alert instance.
  late final String _routeName;

  /// The Flutter route object for this alert.
  late final Route<void> _route;

  /// The controller for managing the alert's auto-dismissal timer.
  late final AlertTimerController _timerController;

  /// A global key used to obtain the render box of the alert for size calculations.
  final GlobalKey _alertKey = GlobalKey();

  /// The build context of the alert's route, available once the route is built.
  BuildContext? _routeContext;

  /// A flag indicating if the alert is currently in the process of closing.
  bool _isClosing = false;

  /// The listener for the [removalSignal] [ValueNotifier].
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
    this.animatedOpacityDuration = DEFAULT_OPACITY_DURATION,
    this.textDirection,
    this.enableHapticFeedback,
    this.loading = false,
    this.centerContent = false,
    this.closeOnPress = true,
    this.withClose = false,
    this.withProgressBar = false,
    this.actions,
    this.removalSignal,
  }) {
    // Validate input properties to ensure they are valid.
    _validateInputs();
    // Initialize properties that depend on other configurations or preferences.
    _initializeProperties();
    // Set up the timer controller for auto-dismissal.
    _setupTimerController();
    // Configure the listener for the external removal signal.
    _setupRemovalSignal();
    // Build the Flutter route for displaying the alert.
    _buildRoute();
    // Display the alert automatically upon creation.
    show();
  }

  /// Creates a loading [SimpleAlert] instance with predefined properties for a loading state.
  SimpleAlert.loading({
    required BuildContext context,
    required String title,
    SimpleAlertType? type,
    SimpleAlertShape? shape,
    BorderRadius? borderRadius,
    TextDirection? textDirection,
    bool? enableHapticFeedback,
    ValueNotifier<bool>? removalSignal,
  }) : this(
          context: context,
          type: type,
          shape: shape,
          borderRadius: borderRadius,
          title: title,
          textDirection: textDirection,
          enableHapticFeedback: enableHapticFeedback,
          loading: true,
          closeOnPress: false, // Loading alerts typically don't close on press.
          removalSignal: removalSignal,
        );

  // ============================================================================
  // Initialization Methods
  // ============================================================================

  /// Validates the constructor inputs to ensure properties like title,
  /// customDuration, and width have valid values.
  void _validateInputs() {
    assert(title.isNotEmpty, 'Title cannot be empty');

    if (customDuration != null && customDuration!.inMilliseconds <= 0) {
      throw ArgumentError('Custom duration must be positive');
    }

    if (width != null && width! <= 0) {
      throw ArgumentError('Width must be positive');
    }
  }

  /// Initializes various properties based on specified values or global preferences.
  ///
  /// This includes resolving the alert type, brightness, alignment, duration,
  /// and generating a route name if not specified.
  void _initializeProperties() {
    _resolvedType = (type ?? SimpleAlertPreferences().type);
    _resolvedBrightness = brightness ?? Theme.of(context).brightness;
    _resolvedAlignment = alignmentDirectional ?? SimpleAlertPreferences().alignmentDirectional;
    _resolvedDuration = _calculateDuration();
    _routeName = routeName ?? 'SimpleAlert#${Random().nextInt(999999999)}';
  }

  /// Sets up the [AlertTimerController] with the resolved duration
  /// and the [_close] method as the completion callback.
  void _setupTimerController() {
    _timerController = AlertTimerController(
      duration: _resolvedDuration,
      onComplete: _close,
    );
  }

  /// Sets up a listener for the [removalSignal] [ValueNotifier].
  ///
  /// When the [removalSignal]'s value becomes `true`, the alert is closed.
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

  /// Builds the [SimpleAlertRoute] instance using the resolved route name
  /// and specifies [_buildRouteContent] as its builder.
  void _buildRoute() {
    _route = SimpleAlertRoute(
      settings: RouteSettings(name: _routeName),
      builder: (BuildContext routeContext) {
        _routeContext = routeContext; // Assign the routeContext to the field.

        return SimpleAlertRouteContent(
          routeContext: routeContext,
          onFirstFrameBuilt: _onFirstFrameBuilt,
          closeAlert: _close,
          onOpacityAnimationControllerCreated: (controller) => opacityAnimationController = controller,
          animatedOpacityDuration: animatedOpacityDuration,
          // Properties for SimpleAlertSafeAreaWrapper
          alertKey: _alertKey,
          resolvedAlignment: _resolvedAlignment,
          alertWidth: _calculateAlertWidth(MediaQuery.sizeOf(routeContext).width), // Initial width calculation.
          calculateVerticalOffset: _calculateVerticalOffset,
          alertManager: _alertManager,
          routeName: _routeName,
          updateAlertSize: _alertManager.updateAlertSize,
          // Pass-through properties for [SimpleAlertInteractiveContainer].
          title: title,
          description: description,
          textDirection: textDirection,
          withProgressBar: withProgressBar,
          closeOnPress: closeOnPress,
          onTap: _handleTap,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          getBorderRadius: _getBorderRadius,
          getBackgroundColor: _getBackgroundColor,
          loading: loading,
          centerContent: centerContent,
          actions: actions,
          withClose: withClose,
          onWidthAnimationControllerCreated: (controller) => widthAnimationController = controller,
          resolvedDuration: _resolvedDuration,
          getForegroundColor: _getForegroundColor,
          getIcon: _getIcon,
          onClosePressed: _close,
        );
      },
    );
  }

  // ============================================================================
  // Route Building
  // ============================================================================

  /// Called after the first frame of the alert is built to register its size and start the timer.
  ///
  /// This method:
  /// - Safely checks if the alert widget is rendered and has a size.
  /// - Creates an `AlertData` object with the alert's size and alignment properties.
  /// - Registers this `AlertData` with the `AlertManager`.
  /// - Starts the auto-dismissal timer.
  void _onFirstFrameBuilt() {
    // Ensure the alert widget is rendered before attempting to get its size.
    if (_alertKey.currentContext == null) return;

    final renderBox = _alertKey.currentContext!.findRenderObject() as RenderBox?;
    // Ensure the render box exists and has a size.
    if (renderBox == null || !renderBox.hasSize) return;

    // Create alert data with its size and alignment properties.
    final alertData = AlertData(
      size: renderBox.size,
      alignment: _resolvedAlignment,
      fromTop: AlertManager.isTopAligned(_resolvedAlignment),
      fromCenter: AlertManager.isCenterAligned(_resolvedAlignment),
      fromBottom: AlertManager.isBottomAligned(_resolvedAlignment),
    );

    _alertManager.registerAlert(_routeName, alertData); // Register the alert with its data.
    _timerController.start(); // Start the auto-dismissal timer.
  }

  // ============================================================================
  // UI Building
  // ============================================================================

  /// Calculates the effective width of the alert.
  ///
  /// It prioritizes the specified `width`, then a width from `SimpleAlertPreferences`,
  /// and finally defaults to the `screenWidth`.
  ///
  /// [screenWidth] The current width of the screen.
  /// Returns the calculated width for the alert.
  double _calculateAlertWidth(double screenWidth) {
    if (width != null) return width!;

    final widthFromPreferences = SimpleAlertPreferences().getWidth?.call();
    return widthFromPreferences ?? screenWidth;
  }

  /// Calculates the vertical offset required to position the current alert,
  /// considering other alerts already displayed in the same direction.
  ///
  /// This ensures that alerts stack vertically without overlapping.
  ///
  /// [displayedAlerts] A map of currently displayed alerts.
  /// [orientation] The current device orientation.
  /// [screenHeight] The total height of the screen.
  /// Returns the vertical offset for the alert.
  double _calculateVerticalOffset(
    Map<String, AlertData> displayedAlerts,
    Orientation orientation,
    double screenHeight,
  ) {
    // Get alerts that are in the same direction and are displayed before the current one.
    final previousAlerts = _alertManager.getAlertsInSameDirection(
      _routeName,
      _resolvedAlignment,
    );

    // Define an average height for calculating initial base offset, considering orientation.
    final averageHeight = orientation == Orientation.portrait ? 70.0 : 50.0;
    // Calculate a base offset, particularly for center-aligned alerts.
    final baseOffset = AlertManager.isCenterAligned(_resolvedAlignment) ? (screenHeight / 2) - averageHeight : 0.0;

    // Fold over previous alerts to accumulate their heights and determine the final offset.
    return previousAlerts.fold<double>(
      baseOffset,
      (offset, data) => offset + data.size.height,
    );
  }

  // ============================================================================
  // Gesture Handlers
  // ============================================================================

  /// Handles the tap gesture on the alert.
  ///
  /// If `closeOnPress` is true and `withProgressBar` is false, the alert will close.
  void _handleTap() {
    if (closeOnPress && !withProgressBar) {
      _close();
    }
  }

  /// Handles the tap down gesture on the alert, specifically for progress bar interaction.
  ///
  /// If a progress bar is present, it stops the width animation and pauses the timer.
  /// This allows the user to "hold" the alert to keep it open.
  ///
  /// [details] Details about the tap down event.
  void _handleTapDown(TapDownDetails details) {
    if (widthAnimationController != null) {
      widthAnimationController!.stop(canceled: false); // Stop progress bar animation.
      _timerController.pause(); // Pause auto-dismissal timer.
    }
  }

  /// Handles the tap up gesture on the alert, specifically for progress bar interaction.
  ///
  /// Resumes the timer and progress bar animation after a tap up.
  ///
  /// [details] Details about the tap up event.
  void _handleTapUp(TapUpDetails details) {
    _resumeTimer();
  }

  /// Handles the tap cancel gesture on the alert, specifically for progress bar interaction.
  ///
  /// Resumes the timer and progress bar animation if a tap was cancelled.
  void _handleTapCancel() {
    _resumeTimer();
  }

  /// Resumes the auto-dismissal timer and the progress bar animation if present.
  void _resumeTimer() {
    _timerController.resume(); // Resume the timer.
    if (widthAnimationController != null) {
      widthAnimationController!.forward(); // Continue progress bar animation.
    }
  }

  // ============================================================================
  // Utility Methods
  // ============================================================================

  /// Calculates the effective duration for the alert's display.
  ///
  /// It prioritizes `customDuration`, then `duration` (from preferences if null),
  /// and finally maps `SimpleAlertDuration` enums to specific `Duration` values.
  ///
  /// Returns the calculated [Duration].
  Duration _calculateDuration() {
    if (customDuration != null) return customDuration!;

    final alertDuration = (duration ?? SimpleAlertPreferences().duration);

    return switch (alertDuration) {
      SimpleAlertDuration.quick => const Duration(seconds: 3),
      SimpleAlertDuration.medium => const Duration(seconds: 5),
      SimpleAlertDuration.long => const Duration(seconds: 8),
      SimpleAlertDuration.day => const Duration(days: 1),
    };
  }

  /// Determines the background color of the alert based on its resolved type and brightness.
  ///
  /// If `backgroundColor` is specified, it is used. Otherwise, default colors are
  /// provided for different alert types and brightness modes.
  ///
  /// Returns the resolved [Color] for the background.
  Color _getBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;

    final isLight = (_resolvedBrightness == Brightness.light);

    return switch (_resolvedType) {
      SimpleAlertType.normal => isLight ? const Color.fromRGBO(82, 82, 91, 1.0) : const Color.fromRGBO(228, 228, 231, 1.0),
      SimpleAlertType.success => isLight ? const Color.fromRGBO(22, 135, 80, 1.0) : const Color.fromRGBO(74, 210, 130, 1.0),
      SimpleAlertType.warning => isLight ? const Color.fromRGBO(217, 142, 11, 1.0) : const Color.fromRGBO(252, 196, 25, 1.0),
      SimpleAlertType.danger => isLight ? const Color.fromRGBO(190, 24, 58, 1.0) : const Color.fromRGBO(248, 105, 125, 1.0),
      SimpleAlertType.info => isLight ? const Color.fromRGBO(30, 72, 156, 1.0) : const Color.fromRGBO(120, 195, 252, 1.0),
    };
  }

  /// Determines the foreground color (text and icons) of the alert based on its resolved brightness.
  ///
  /// If `foregroundColor` is specified, it is used. Otherwise, it defaults to black for dark mode
  /// and white for light mode.
  ///
  /// Returns the resolved [Color] for the foreground.
  Color _getForegroundColor() {
    if (foregroundColor != null) return foregroundColor!;

    return _resolvedBrightness == Brightness.dark ? Colors.black : Colors.white;
  }

  /// Determines the [BorderRadius] for the alert's container.
  ///
  /// It prioritizes `borderRadius`, then a preference from `SimpleAlertPreferences`,
  /// and finally defaults based on the `shape` property.
  ///
  /// Returns the resolved [BorderRadius].
  BorderRadius _getBorderRadius() {
    if (borderRadius != null) return borderRadius!;

    final preferenceBorderRadius = SimpleAlertPreferences().borderRadius;
    if (preferenceBorderRadius != null) return preferenceBorderRadius;

    final alertShape = (shape ?? SimpleAlertPreferences().shape);

    return switch (alertShape) {
      SimpleAlertShape.defaultRadius => BorderRadius.circular(BORDER_RADIUS),
      SimpleAlertShape.sharp => BorderRadius.zero,
      SimpleAlertShape.rounded => BorderRadius.circular(255.0),
    };
  }

  /// Retrieves the appropriate icon for the alert based on its resolved type.
  ///
  /// It also assigns a semantic label for accessibility purposes.
  ///
  /// Returns an [Icon] widget.
  Icon _getIcon() {
    final icons = SimpleAlertPreferences().icons;
    final size = SimpleAlertPreferences().iconsSize;

    final (iconData, semanticLabel) = switch (_resolvedType) {
      SimpleAlertType.normal => (icons.normal, t.normalAlertIconDescription),
      SimpleAlertType.success => (icons.success, t.successAlertIconDescription),
      SimpleAlertType.warning => (icons.warning, t.warningAlertIconDescription),
      SimpleAlertType.danger => (icons.danger, t.dangerAlertIconDescription),
      SimpleAlertType.info => (icons.info, t.informationAlertIconDescription),
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

  /// Initiates the closing sequence for the alert.
  ///
  /// This asynchronous method:
  /// - Prevents multiple closing attempts.
  /// - Calls `_cleanup` to dispose of listeners and timers.
  /// - Reverses the opacity animation.
  /// - Deletes the alert's route from the Navigator if it's active.
  /// - Unregisters the alert from the `AlertManager`.
  Future<void> _close() async {
    if (_isClosing) return;
    _isClosing = true;

    // Cancel the timer immediately to prevent any further completion callbacks
    // while the async closing sequence is in progress.
    _timerController.cancel();

    // Attempt to reverse the opacity animation for a smooth dismissal.
    if (_routeContext != null && _routeContext!.mounted) {
      try {
        await opacityAnimationController?.reverse().timeout(animatedOpacityDuration + const Duration(milliseconds: 100));
      } catch (e) {
        // Ignore animation errors to ensure the alert still closes.
        debugPrint('SimpleAlert closing animation failed: $e');
      }
    }

    // Remove the route if it is still active. Use `_routeContext` as the
    // primary navigator source, falling back to the original `context` to
    // guarantee removal even when the route widget tree has been unmounted.
    if (_route.isActive) {
      final NavigatorState? navigator = (_routeContext != null && _routeContext!.mounted) ? Navigator.maybeOf(_routeContext!) : (context.mounted ? Navigator.maybeOf(context) : null);
      navigator?.removeRoute(_route);
    }

    _alertManager.unregisterAlert(_routeName); // Delete alert from the manager.
    _freeingUpResources(); // Dispose of timers and listeners.
  }

  /// Freeing up resources associated with the alert, such as listeners and timers.
  ///
  /// This method is called during the closing process to prevent memory leaks.
  void _freeingUpResources() {
    if (_removalSignalListener != null) {
      removalSignal?.removeListener(_removalSignalListener!);
      _removalSignalListener = null;
    }

    _timerController.dispose();
    opacityAnimationController = null;
    widthAnimationController = null;
    _routeContext = null; // Clear the context when resources are freed.
  }

  /// Displays the [SimpleAlert] by pushing its route onto the Navigator.
  ///
  /// Throws a [StateError] if the context is not mounted.
  /// When the route completes (e.g., alert is dismissed), the `_close` method is called.
  void show() {
    if (!context.mounted) {
      throw StateError('Cannot show alert: context is not mounted');
    }

    final haptic =
        enableHapticFeedback ?? SimpleAlertPreferences().enableHapticFeedback;
    if (haptic) {
      switch (_resolvedType) {
        case SimpleAlertType.danger:
          HapticFeedback.heavyImpact();
        case SimpleAlertType.warning:
          HapticFeedback.mediumImpact();
        default:
          HapticFeedback.lightImpact();
      }
    }

    // Push the alert's route onto the navigator and call _close when it completes.
    Navigator.of(context).push(_route).whenComplete(_close);
  }
}

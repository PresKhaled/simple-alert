/*
* This file is a part of "SimpleAlert" project.
* Khaled Mohsen <pres.kbayomy@gmail.com>
* Copyrights (BSD-3-Clause), LICENSE.
*/

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'backend/alert_manager.dart';
import 'enums/simple_alert_duration.dart';
import 'enums/simple_alert_shape.dart';
import 'enums/simple_alert_type.dart';
import 'misc/constants.dart';
import 'simple_alert_preferences.dart';
import 'widgets/simple_alert_card.dart';

/// A comprehensive alert system that displays customizable, responsive in-app alerts.
///
/// `SimpleAlert` supports displaying multiple alerts simultaneously, automatic vertical
/// stacking based on alignment, orientation adaptation, progress countdown bars,
/// action buttons, and swipe-to-dismiss gestures.
///
/// Example of a basic alert:
/// ```dart
/// SimpleAlert(
///   context: context,
///   title: 'Success!',
///   description: 'Your operation was completed successfully.',
///   type: SimpleAlertType.success,
///   duration: SimpleAlertDuration.quick,
/// );
/// ```
///
/// Example of a loading alert:
/// ```dart
/// final stopSignal = ValueNotifier<bool>(false);
/// SimpleAlert.loading(
///   context: context,
///   title: 'Processing...',
///   removalSignal: stopSignal,
/// );
/// // To dismiss: stopSignal.value = true;
/// ```
class SimpleAlert {
  /// The build context from which the alert is shown.
  final BuildContext context;

  /// An optional unique name for the alert's route/entry. If null, one is generated.
  final String? routeName;

  /// The main title text displayed in the alert.
  final String title;

  /// An optional detailed description text for the alert.
  final String? description;

  /// The alignment of the alert on the screen.
  final AlignmentDirectional? alignmentDirectional;

  /// The specified width of the alert.
  final double? width;

  /// An optional explicit text direction override.
  final TextDirection? textDirection;

  /// Whether tactile haptic feedback is triggered when the alert is shown.
  final bool? enableHapticFeedback;

  /// The shape of the alert container.
  final SimpleAlertShape? shape;

  /// The border radius for the alert's corners. Overrides [shape] if specified.
  final BorderRadius? borderRadius;

  /// The brightness theme for the alert.
  final Brightness? brightness;

  /// The predefined semantic type of the alert.
  final SimpleAlertType? type;

  /// The background color of the alert.
  final Color? backgroundColor;

  /// The foreground color of the alert.
  final Color? foregroundColor;

  /// The predefined duration for auto-dismissal.
  final SimpleAlertDuration? duration;

  /// A custom duration for auto-dismissal. Overrides [duration] if specified.
  final Duration? customDuration;

  /// The duration of the entrance/exit animation.
  final Duration animatedOpacityDuration;

  /// If true, the alert will display a loading indicator instead of a type icon.
  final bool loading;

  /// If true, the alert's content will be horizontally centered.
  final bool centerContent;

  /// If true, the alert will close when pressed, unless [withProgressBar] is true.
  final bool closeOnPress;

  /// If true, a close button will be displayed in the alert.
  final bool withClose;

  /// If true, a countdown progress bar will be displayed.
  final bool withProgressBar;

  /// An optional list of [IconButton] widgets to display as actions in the alert.
  final List<IconButton>? actions;

  /// An optional [ValueNotifier<bool>] that triggers dismissal when set to `true`.
  final ValueNotifier<bool>? removalSignal;

  // Computed and internal state
  late final SimpleAlertType _resolvedType;
  late final AlignmentDirectional _resolvedAlignment;
  late final Duration _resolvedDuration;
  late final String _routeName;
  final AlertManager _alertManager = AlertManager();
  final GlobalKey<SimpleAlertCardState> _cardKey =
      GlobalKey<SimpleAlertCardState>();

  bool _isShown = false;
  bool _isClosing = false;
  VoidCallback? _removalSignalListener;

  /// Creates a [SimpleAlert] instance and displays it.
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
    _validateInputs();
    _initializeProperties();
    _setupRemovalSignal();
    show();
  }

  /// Creates a loading [SimpleAlert] instance with predefined properties.
  SimpleAlert.loading({
    required BuildContext context,
    required String title,
    Brightness? brightness,
    SimpleAlertType? type,
    SimpleAlertShape? shape,
    BorderRadius? borderRadius,
    TextDirection? textDirection,
    bool? enableHapticFeedback,
    ValueNotifier<bool>? removalSignal,
  }) : this(
          context: context,
          brightness: brightness,
          type: type,
          shape: shape,
          borderRadius: borderRadius,
          title: title,
          textDirection: textDirection,
          enableHapticFeedback: enableHapticFeedback,
          loading: true,
          closeOnPress: false,
          removalSignal: removalSignal,
        );

  void _validateInputs() {
    if (customDuration != null && customDuration!.inMilliseconds <= 0) {
      debugPrint(
          'SimpleAlert: customDuration must be positive. Default duration will be used.');
    }
    if (width != null && width! <= 0) {
      debugPrint(
          'SimpleAlert: width must be positive. Default width will be used.');
    }
  }

  void _initializeProperties() {
    try {
      _resolvedType = (type ?? SimpleAlertPreferences().type);
      _resolvedAlignment =
          alignmentDirectional ?? SimpleAlertPreferences().alignmentDirectional;
      _resolvedDuration = _calculateDuration();
      _routeName = routeName ?? 'SimpleAlert#${Random().nextInt(999999999)}';
    } catch (e) {
      debugPrint('SimpleAlert _initializeProperties safe error: $e');
      _resolvedType = SimpleAlertType.normal;
      _resolvedAlignment = AlignmentDirectional.topCenter;
      _resolvedDuration = const Duration(seconds: 4);
      _routeName = 'SimpleAlert#${Random().nextInt(999999999)}';
    }
  }

  Duration _calculateDuration() {
    if (customDuration != null && customDuration!.inMilliseconds > 0) {
      return customDuration!;
    }
    try {
      final alertDuration = (duration ?? SimpleAlertPreferences().duration);
      return switch (alertDuration) {
        SimpleAlertDuration.quick => const Duration(seconds: 3),
        SimpleAlertDuration.medium => const Duration(seconds: 5),
        SimpleAlertDuration.long => const Duration(seconds: 8),
        SimpleAlertDuration.day => const Duration(days: 1),
      };
    } catch (_) {
      return const Duration(seconds: 4);
    }
  }

  void _setupRemovalSignal() {
    if (removalSignal != null) {
      _removalSignalListener = () {
        if (removalSignal!.value && !_isClosing) {
          dismiss();
        }
      };
      removalSignal!.addListener(_removalSignalListener!);
    }
  }

  void _cleanup() {
    if (_removalSignalListener != null) {
      removalSignal?.removeListener(_removalSignalListener!);
      _removalSignalListener = null;
    }
  }

  /// Displays the [SimpleAlert] by registering it with [SimpleAlertHost].
  ///
  /// Idempotent: safe to call multiple times without duplicating alerts.
  void show() {
    if (_isShown) return;
    _isShown = true;

    try {
      final haptic =
          enableHapticFeedback ?? SimpleAlertPreferences().enableHapticFeedback;
      if (haptic) {
        try {
          switch (_resolvedType) {
            case SimpleAlertType.danger:
              HapticFeedback.heavyImpact();
            case SimpleAlertType.warning:
              HapticFeedback.mediumImpact();
            default:
              HapticFeedback.lightImpact();
          }
        } catch (_) {}
      }

      if (!_alertManager.hasHost) {
        debugPrint(
          '[SimpleAlert] Warning: SimpleAlertHost is not registered in MaterialApp.builder. '
          'Wrap your MaterialApp.builder with SimpleAlertHost(child: child!) to display alerts.',
        );
      }

      ThemeData? callerTheme;
      try {
        if (context.mounted) {
          callerTheme = Theme.of(context);
        }
      } catch (_) {}

      final cardWidget = SimpleAlertCard(
        key: _cardKey,
        routeName: _routeName,
        title: title,
        description: description,
        alignment: _resolvedAlignment,
        width: width,
        shape: shape,
        borderRadius: borderRadius,
        brightness: brightness,
        type: _resolvedType,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        duration: _resolvedDuration,
        animatedOpacityDuration: animatedOpacityDuration,
        textDirection: textDirection,
        loading: loading,
        centerContent: centerContent,
        closeOnPress: closeOnPress,
        withClose: withClose,
        withProgressBar: withProgressBar,
        actions: actions,
        themeData: callerTheme,
        onDismissed: () {
          _cleanup();
          _alertManager.unregisterHostAlert(_routeName);
        },
      );

      final entry = AlertEntry(
        id: _routeName,
        widget: cardWidget,
        dismiss: dismiss,
      );

      _alertManager.registerHostAlert(entry);
    } catch (e) {
      debugPrint('SimpleAlert show safe error: $e');
      _cleanup();
    }
  }

  /// Dismisses this alert instance with an optional immediate flag.
  Future<void> dismiss({bool immediate = false}) async {
    if (_isClosing) return;
    _isClosing = true;
    _cleanup();

    try {
      if (_cardKey.currentState != null) {
        await _cardKey.currentState!.dismiss(immediate: immediate);
      } else {
        _alertManager.unregisterAlert(_routeName);
        _alertManager.unregisterHostAlert(_routeName);
      }
    } catch (e) {
      debugPrint('SimpleAlert dismiss safe error: $e');
      _alertManager.unregisterAlert(_routeName);
      _alertManager.unregisterHostAlert(_routeName);
    }
  }

  /// Dismisses all currently active alerts across the application.
  static Future<void> dismissAll({bool immediate = false}) {
    return AlertManager().dismissAll(immediate: immediate);
  }
}

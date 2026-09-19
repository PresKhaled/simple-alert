/*
* This file is a part of "SimpleAlert" project.
* Khaled Mohsen <pres.kbayomy@gmail.com>
* Copyrights (BSD-3-Clause), LICENSE.
*/

import 'package:flutter/material.dart';

import 'enums/simple_alert_duration.dart';
import 'enums/simple_alert_shape.dart';
import 'enums/simple_alert_type.dart';
import 'misc/simple_alert_icons.dart';
import 'misc/simple_alert_localizations.dart';

/// A singleton class for managing and providing global default preferences for [SimpleAlert].
///
/// This class allows for global configuration of various alert properties such as
/// alignment, shape, colors, text styles, and durations. Preferences can be configured
/// once and will persist across all alerts unless overridden locally.
class SimpleAlertPreferences {
  AlignmentDirectional? _alignmentDirectional;
  double Function()? _getWidth;
  SimpleAlertShape? _shape;
  BorderRadius? _borderRadius;
  Brightness? _brightness;
  SimpleAlertType? _type;
  SimpleAlertIcons? _icons;
  double? _iconsSize;
  Color? _iconsColor;
  TextStyle? _titleStyle;
  TextStyle? _descriptionStyle;
  TooltipThemeData? _tooltipThemeData;
  String? _closeTooltip;
  SimpleAlertDuration? _duration;
  TextDirection? _textDirection;
  bool? _enableHapticFeedback;

  /// The default alignment direction for alerts.
  AlignmentDirectional get alignmentDirectional =>
      _alignmentDirectional ?? AlignmentDirectional.topCenter;

  /// A function that returns the default width for alerts.
  double Function()? get getWidth => _getWidth;

  /// The default shape for alert corners.
  SimpleAlertShape get shape => _shape ?? SimpleAlertShape.defaultRadius;

  /// The default border radius for alerts. Takes precedence over [shape].
  BorderRadius? get borderRadius => _borderRadius;

  /// The default brightness for alerts. If null, resolves from context theme.
  Brightness? get brightness => _brightness;

  /// The default semantic type for alerts (e.g., info, success, warning).
  SimpleAlertType get type => _type ?? SimpleAlertType.info;

  /// The default set of icons to use for different alert types.
  SimpleAlertIcons get icons => _icons ?? const SimpleAlertIcons();

  /// The default size for alert icons.
  double get iconsSize => _iconsSize ?? 28.0;

  /// The default color for alert icons.
  Color? get iconsColor => _iconsColor;

  /// The default text style for the alert title.
  TextStyle get titleStyle =>
      _titleStyle ??
      const TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      );

  /// The default text style for the alert description.
  TextStyle get descriptionStyle =>
      _descriptionStyle ??
      const TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
        height: 1.35,
      );

  /// The default tooltip theme data for interactive elements within alerts.
  TooltipThemeData? get tooltipThemeData => _tooltipThemeData;

  /// The default tooltip message for the close button.
  String get closeTooltip => _closeTooltip ?? t.closeButtonTooltip;

  /// The default display duration for alerts.
  SimpleAlertDuration get duration => _duration ?? SimpleAlertDuration.medium;

  /// The default text direction for alerts. If null, automatically resolved.
  TextDirection? get textDirection => _textDirection;

  /// Whether tactile haptic feedback is triggered when alerts are shown.
  bool get enableHapticFeedback => _enableHapticFeedback ?? true;

  static final SimpleAlertPreferences _instance =
      SimpleAlertPreferences._internal();

  /// Creates or retrieves the singleton instance of [SimpleAlertPreferences].
  ///
  /// Safe against parameter erasure: providing no parameters retains existing
  /// configurations without resetting them to null or defaults.
  factory SimpleAlertPreferences({
    BuildContext? context,
    AlignmentDirectional? alignmentDirectional,
    double Function()? getWidth,
    SimpleAlertShape? shape,
    BorderRadius? borderRadius,
    Brightness? brightness,
    SimpleAlertType? type,
    SimpleAlertIcons? icons,
    double? iconsSize,
    Color? iconsColor,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    TooltipThemeData? tooltipThemeData,
    String? closeTooltip,
    SimpleAlertDuration? duration,
    TextDirection? textDirection,
    bool? enableHapticFeedback,
  }) {
    final ThemeData? themeData =
        ((context != null && context.mounted) ? Theme.of(context) : null);

    if (alignmentDirectional != null) {
      _instance._alignmentDirectional = alignmentDirectional;
    }
    if (getWidth != null) {
      _instance._getWidth = getWidth;
    }
    if (shape != null) {
      _instance._shape = shape;
    }
    if (borderRadius != null) {
      _instance._borderRadius = borderRadius;
    }
    if (brightness != null) {
      _instance._brightness = brightness;
    }
    if (type != null) {
      _instance._type = type;
    }
    if (icons != null) {
      _instance._icons = icons;
    }
    if (iconsSize != null) {
      _instance._iconsSize = iconsSize;
    }
    if (iconsColor != null) {
      _instance._iconsColor = iconsColor;
    }

    if (titleStyle != null) {
      _instance._titleStyle = titleStyle;
    } else if (themeData != null && _instance._titleStyle == null) {
      final base = themeData.textTheme.titleMedium;
      if (base != null) {
        _instance._titleStyle = TextStyle(
          inherit: base.inherit,
          fontFamily: base.fontFamily,
          fontFamilyFallback: base.fontFamilyFallback,
          fontSize: base.fontSize ?? 17.0,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          fontStyle: base.fontStyle,
          textBaseline: base.textBaseline,
          height: base.height,
          leadingDistribution: base.leadingDistribution,
          locale: base.locale,
          shadows: base.shadows,
          fontFeatures: base.fontFeatures,
          fontVariations: base.fontVariations,
          decoration: base.decoration,
          decorationColor: base.decorationColor,
          decorationStyle: base.decorationStyle,
          decorationThickness: base.decorationThickness,
          debugLabel: base.debugLabel,
          overflow: base.overflow,
        );
      }
    }

    if (descriptionStyle != null) {
      _instance._descriptionStyle = descriptionStyle;
    } else if (themeData != null && _instance._descriptionStyle == null) {
      final base = themeData.textTheme.bodyMedium;
      if (base != null) {
        _instance._descriptionStyle = TextStyle(
          inherit: base.inherit,
          fontFamily: base.fontFamily,
          fontFamilyFallback: base.fontFamilyFallback,
          fontSize: base.fontSize ?? 15.0,
          fontWeight: FontWeight.w400,
          letterSpacing: base.letterSpacing,
          fontStyle: base.fontStyle,
          textBaseline: base.textBaseline,
          height: 1.35,
          leadingDistribution: base.leadingDistribution,
          locale: base.locale,
          shadows: base.shadows,
          fontFeatures: base.fontFeatures,
          fontVariations: base.fontVariations,
          decoration: base.decoration,
          decorationColor: base.decorationColor,
          decorationStyle: base.decorationStyle,
          decorationThickness: base.decorationThickness,
          debugLabel: base.debugLabel,
          overflow: base.overflow,
        );
      }
    }

    if (tooltipThemeData != null) {
      _instance._tooltipThemeData = tooltipThemeData;
    }
    if (closeTooltip != null) {
      _instance._closeTooltip = closeTooltip;
    }
    if (duration != null) {
      _instance._duration = duration;
    }
    if (textDirection != null) {
      _instance._textDirection = textDirection;
    }
    if (enableHapticFeedback != null) {
      _instance._enableHapticFeedback = enableHapticFeedback;
    }

    return _instance;
  }

  SimpleAlertPreferences._internal();

  /// Sets the active locale code for translations (e.g., 'en', 'ar', 'ur', 'tr', 'id', 'pt').
  void setLocale(String locale) {
    SimpleAlertLocalizations.setLocale(locale);
  }

  /// Resets all global preferences to defaults (primarily used in testing).
  @visibleForTesting
  void reset() {
    _alignmentDirectional = null;
    _getWidth = null;
    _shape = null;
    _borderRadius = null;
    _brightness = null;
    _type = null;
    _icons = null;
    _iconsSize = null;
    _iconsColor = null;
    _titleStyle = null;
    _descriptionStyle = null;
    _tooltipThemeData = null;
    _closeTooltip = null;
    _duration = null;
    _textDirection = null;
    _enableHapticFeedback = null;
  }
}

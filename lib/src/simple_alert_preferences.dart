import 'package:flutter/material.dart' show AlignmentDirectional, BorderRadius, BuildContext, Color, FontWeight, TextStyle, Theme, ThemeData, TooltipThemeData, Colors;

import 'enums/simple_alert_duration.dart';
import 'enums/simple_alert_shape.dart';
import 'enums/simple_alert_type.dart';
import 'misc/simple_alert_icons.dart';

/// A singleton class for managing and providing default preferences for [SimpleAlert] widgets.
///
/// This class allows for global configuration of various alert properties such as
/// alignment, shape, colors, text styles, and durations. Preferences can be set
/// once and will be applied to all subsequent [SimpleAlert] instances unless
/// overridden locally.
///
/// Example of initializing preferences globally:
/// ```dart
/// // In your main.dart or a similar setup file:
/// SimpleAlertPreferences(
///   context: context,
///   alignmentDirectional: AlignmentDirectional.topEnd,
///   duration: SimpleAlertDuration.long,
///   iconsColor: Colors.amber,
/// );
///
/// // Later, when showing an alert:
/// SimpleAlert(
///   context: context,
///   title: 'Customized Alert',
/// ); // Will use the globally set preferences.
/// ```
class SimpleAlertPreferences {
  late AlignmentDirectional? _alignmentDirectional;
  late double Function()? _getWidth;
  late SimpleAlertShape? _shape;
  late BorderRadius? _borderRadius;
  late SimpleAlertType? _type;
  late SimpleAlertIcons? _icons;
  late double? _iconsSize;
  late Color? _iconsColor;
  late TextStyle? _titleStyle;
  late TextStyle? _descriptionStyle;
  late TooltipThemeData? _tooltipThemeData;
  late String? _closeTooltip;
  late SimpleAlertDuration? _duration;

  /// The default alignment direction for alerts.
  AlignmentDirectional get alignmentDirectional => _alignmentDirectional!;

  /// A function that returns the default width for alerts.
  /// If `null`, alerts will use their intrinsic width or screen width.
  double Function()? get getWidth => _getWidth;

  /// The default shape for alert corners.
  SimpleAlertShape get shape => _shape!;

  /// The default border radius for alerts. Takes precedence over [shape].
  BorderRadius? get borderRadius => _borderRadius;

  /// The default semantic type for alerts (e.g., info, success, warning).
  SimpleAlertType get type => _type!;

  /// The default set of icons to use for different alert types.
  SimpleAlertIcons get icons => _icons!;

  /// The default size for alert icons.
  double get iconsSize => _iconsSize!;

  /// The default color for alert icons.
  Color? get iconsColor => _iconsColor;

  /// The default text style for the alert title.
  TextStyle get titleStyle => _titleStyle!;

  /// The default text style for the alert description.
  TextStyle get descriptionStyle => _descriptionStyle!;

  /// The default tooltip theme data for interactive elements within alerts.
  TooltipThemeData? get tooltipThemeData => _tooltipThemeData;

  /// The default tooltip message for the close button.
  String get closeTooltip => _closeTooltip!;

  /// The default display duration for alerts.
  SimpleAlertDuration get duration => _duration!;

  static final SimpleAlertPreferences _instance = SimpleAlertPreferences._internal();

  /// Creates or retrieves the singleton instance of [SimpleAlertPreferences].
  ///
  /// All parameters are optional and serve to initialize or update the global
  /// preferences. If a parameter is not specified, its existing value (or a
  /// hardcoded default) is retained.
  factory SimpleAlertPreferences({
    /// The [BuildContext] to resolve theme-dependent styles.
    /// It's crucial to provide a [context] if theme-based text styles are desired.
    BuildContext? context,
    AlignmentDirectional alignmentDirectional = AlignmentDirectional.topCenter,
    double Function()? getWidth,
    SimpleAlertShape shape = SimpleAlertShape.defaultRadius,
    BorderRadius? borderRadius,
    SimpleAlertType type = SimpleAlertType.info,
    SimpleAlertIcons icons = const SimpleAlertIcons(),
    double iconsSize = 28.0,
    Color? iconsColor,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    TooltipThemeData? tooltipThemeData,
    String closeTooltip = 'Close',
    SimpleAlertDuration duration = SimpleAlertDuration.medium,
  }) {
    final ThemeData? themeData = ((context != null && context.mounted) ? Theme.of(context) : null);

    _instance._alignmentDirectional ??= alignmentDirectional;
    _instance._getWidth ??= getWidth;
    _instance._shape ??= shape;
    _instance._borderRadius ??= borderRadius;
    _instance._type ??= type;
    _instance._icons ??= icons;
    _instance._iconsSize ??= iconsSize;
    _instance._iconsColor ??= iconsColor;
    _instance._titleStyle ??= (titleStyle ??
        themeData?.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ) ??
        const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Default color if no theme is available.
        ));
    _instance._descriptionStyle ??= (descriptionStyle ??
        themeData?.textTheme.bodyLarge ??
        const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.white70, // Default color if no theme is available.
        ));
    _instance._tooltipThemeData ??= tooltipThemeData;
    _instance._closeTooltip ??= closeTooltip;
    _instance._duration ??= duration;

    return _instance;
  }

  SimpleAlertPreferences._internal() {
    _alignmentDirectional = null;
    _getWidth = null;
    _shape = null;
    _borderRadius = null;
    _type = null;
    _icons = null;
    _iconsSize = null;
    _iconsColor = null;
    _titleStyle = null;
    _descriptionStyle = null;
    _tooltipThemeData = null;
    _closeTooltip = null;
    _duration = null;
  }
}

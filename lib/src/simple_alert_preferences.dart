import 'package:flutter/material.dart'
    show Alignment, AlignmentDirectional, BorderRadius, BuildContext, Color, Colors, FontWeight, Offset, TextStyle, Theme, ThemeData, TooltipThemeData;

import '../simple_alert.dart';

class SimpleAlertPreferences {
  AlignmentDirectional? _alignmentDirectional;
  double? _width;
  SimpleAlertShape? _shape;
  BorderRadius? _borderRadius;
  SimpleAlertType? _type;
  SimpleAlertIcons? _icons;
  double? _iconsSize;
  Color? _iconsColor;
  TextStyle? _titleStyle;
  TextStyle? _descriptionStyle;
  TooltipThemeData? _tooltipThemeData;
  String? _closeTooltip;
  SimpleAlertDuration? _duration;

  /// Currently: When more than one alert is displayed in the center of the screen at the same time,
  /// they will appear on top of each other.
  AlignmentDirectional get alignmentDirectional => _alignmentDirectional!;
  double? get width => _width;
  SimpleAlertShape get shape => _shape!;
  BorderRadius? get borderRadius => _borderRadius;
  SimpleAlertType get type => _type!;
  SimpleAlertIcons get icons => _icons!;
  double get iconsSize => _iconsSize!;
  Color? get iconsColor => _iconsColor;
  TextStyle get titleStyle => _titleStyle!;
  TextStyle get descriptionStyle => _descriptionStyle!;
  TooltipThemeData? get tooltipThemeData => _tooltipThemeData;
  String get closeTooltip => _closeTooltip!;
  SimpleAlertDuration get duration => _duration!;

  static final SimpleAlertPreferences _instance = SimpleAlertPreferences._internal();

  factory SimpleAlertPreferences({
    /// Add with first initialization.
    BuildContext? context,

    /// Currently: When more than one alert is displayed in the center of the screen at the same time,
    /// they will appear on top of each other.
    AlignmentDirectional alignmentDirectional = AlignmentDirectional.topStart,
    double? width,
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
    _instance._width ??= width;
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
        ));
    _instance._descriptionStyle ??= (descriptionStyle ?? themeData?.textTheme.titleMedium ?? const TextStyle(fontSize: 18.0));
    _instance._tooltipThemeData ??= tooltipThemeData;
    _instance._closeTooltip ??= closeTooltip;
    _instance._duration ??= duration;

    return _instance;
  }

  SimpleAlertPreferences._internal();
}

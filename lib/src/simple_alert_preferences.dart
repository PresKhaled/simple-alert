import 'package:flutter/material.dart' show Alignment, BorderRadius, FontWeight, TextStyle, TooltipThemeData;

import '../simple_alert.dart';

class SimpleAlertPreferences {
  Alignment? _alignment;
  SimpleAlertShape? _shape;
  BorderRadius? _borderRadius;
  SimpleAlertType? _type;
  SimpleAlertIcons? _icons;
  double? _iconsSize;
  TextStyle? _titleStyle;
  TextStyle? _descriptionStyle;
  TooltipThemeData? _tooltipThemeData;
  String? _closeTooltip;
  SimpleAlertDuration? _duration;

  Alignment get alignment => _alignment!;
  SimpleAlertShape get shape => _shape!;
  BorderRadius? get borderRadius => _borderRadius;
  SimpleAlertType get type => _type!;
  SimpleAlertIcons get icons => _icons!;
  double get iconsSize => _iconsSize!;
  TextStyle get titleStyle => _titleStyle!;
  TextStyle get descriptionStyle => _descriptionStyle!;
  TooltipThemeData? get tooltipThemeData => _tooltipThemeData;
  String get closeTooltip => _closeTooltip!;
  SimpleAlertDuration get duration => _duration!;

  static final SimpleAlertPreferences _instance = SimpleAlertPreferences._internal();

  factory SimpleAlertPreferences({
    Alignment alignment = Alignment.topCenter,
    SimpleAlertShape shape = SimpleAlertShape.defaultRadius,
    BorderRadius? borderRadius,
    SimpleAlertType type = SimpleAlertType.info,
    SimpleAlertIcons icons = const SimpleAlertIcons(),
    double iconsSize = 28.0,
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    TooltipThemeData? tooltipThemeData,
    String closeTooltip = 'Close',
    SimpleAlertDuration duration = SimpleAlertDuration.medium,
  }) {
    _instance._alignment ??= alignment;
    _instance._shape ??= shape;
    _instance._borderRadius ??= borderRadius;
    _instance._type ??= type;
    _instance._icons ??= icons;
    _instance._iconsSize ??= iconsSize;
    _instance._titleStyle ??= (titleStyle ?? TextStyle(fontSize: 18.0));
    _instance._descriptionStyle ??= (descriptionStyle ??
        TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ));
    _instance._tooltipThemeData ??= tooltipThemeData;
    _instance._closeTooltip ??= closeTooltip;
    _instance._duration ??= duration;

    return _instance;
  }

  SimpleAlertPreferences._internal();
}

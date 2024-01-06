import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_alert/simple_alert.dart';

void main() {
  test('Ensure that the class properties are present after setting them.', () {
    // final BuildContext context = ; // -
    double getWidth() => 250.0;
    const AlignmentDirectional alignmentDirectional = AlignmentDirectional.bottomCenter;
    const SimpleAlertShape shape = SimpleAlertShape.rounded;
    final BorderRadius borderRadius = BorderRadius.circular(99.0);
    const SimpleAlertType type = SimpleAlertType.success;
    const SimpleAlertIcons simpleAlertIcons = SimpleAlertIcons();
    const double iconsSize = 32.0;
    const Color iconsColor = Colors.black;
    const TextStyle titleStyle = TextStyle(
      fontSize: 21.0,
      fontWeight: FontWeight.bold,
    );
    const TextStyle descriptionStyle = TextStyle(
      fontSize: 19.0,
    );
    const TooltipThemeData tooltipThemeData = TooltipThemeData(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.teal,
      ),
    );
    const String closeTooltip = 'Close the alert';
    const SimpleAlertDuration duration = SimpleAlertDuration.long;

    final SimpleAlertPreferences singleton = SimpleAlertPreferences(
      // context: context,
      getWidth: getWidth,
      alignmentDirectional: alignmentDirectional,
      shape: shape,
      borderRadius: borderRadius,
      type: type,
      icons: simpleAlertIcons,
      iconsSize: iconsSize,
      iconsColor: iconsColor,
      titleStyle: titleStyle,
      descriptionStyle: descriptionStyle,
      tooltipThemeData: tooltipThemeData,
      closeTooltip: closeTooltip,
      duration: duration,
    );

    // assert(singleton.context == );
    assert(singleton.getWidth == getWidth);
    assert(singleton.alignmentDirectional == alignmentDirectional);
    assert(singleton.shape == shape);
    assert(singleton.borderRadius == borderRadius);
    assert(singleton.type == type);
    assert(singleton.icons == simpleAlertIcons);
    assert(singleton.iconsSize == iconsSize);
    assert(singleton.iconsColor == iconsColor);
    assert(singleton.titleStyle == titleStyle);
    assert(singleton.descriptionStyle == descriptionStyle);
    assert(singleton.tooltipThemeData == tooltipThemeData);
    assert(singleton.closeTooltip == closeTooltip);
    assert(singleton.duration == duration);
  });
}

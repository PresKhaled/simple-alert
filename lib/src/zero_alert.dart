/*
* This file is a part of "Zero alert" project.
* Khaled Mohsen <pres.kbayomy@gmail.com>
* Copyrights (BSD-3-Clause), LICENSE.
*/
import 'dart:ui';

import 'package:flutter/material.dart';

import '../zero_alert.dart';

/// Regular alert with predefined styles for some common cases.
///
/// The parameters [context], [icon], [title], [subTitle] is required.
class ZeroAlert {
  final BuildContext context;
  final ZAlertType type;
  final Alignment alignment;
  ZAlertDuration duration;
  double borderRadius;
  Map<String, dynamic> boxShadow;
  Color color;
  final ZAlertBrightness brightness;
  final ZAlertShape shape;
  ShapeBorder selectedShape;
  final TextDirection textDirection;
  final Icon icon;
  final String label;
  TextStyle labelStyle;
  final String subTitle;
  TextStyle subTitleStyle;
  OverlayEntry _overlayEntry;
  //List<BoxShadow> boxShadow;

  ZeroAlert({
    @required this.context,
    this.type = ZAlertType.normal,
    this.duration = ZAlertDuration.quick,
    this.textDirection = TextDirection.rtl,
    this.alignment = Alignment.topCenter,
    this.color,
    this.brightness = ZAlertBrightness.light,
    this.icon,
    this.shape = ZAlertShape.defaultRadius,
    this.borderRadius,
    @required this.label,
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
  })  : assert(context != null),
        /*assert(icon != null),*/
        assert(label != null)
  /*assert(subTitle != null)*/ {
    Duration selectedDuration;

    switch (duration) {
      case ZAlertDuration.quick:
        selectedDuration = Duration(seconds: 3);
        break;

      case ZAlertDuration.medium:
        selectedDuration = Duration(seconds: 5);
        break;

      case ZAlertDuration.long:
        selectedDuration = Duration(seconds: 7);
        break;
    }

    switch (brightness) {
      case ZAlertBrightness.dark:
        boxShadow = {
          'color': Colors.black26,
          'elevation': 7.0,
        };
        break;

      case ZAlertBrightness.system: // TODO: Handle.
        boxShadow = {
          'color': Colors.black26,
          'elevation': 7.0,
        };
        break;

      case ZAlertBrightness.light:
      default:
        /*boxShadow = [
          BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 5,
              spreadRadius: -2)
        ];*/
        boxShadow = {
          'color': Colors.black45,
          'elevation': 7.0,
        };
        break;
    }

    // If the [color] specified with the type, color will applied.
    if (color == null) {
      switch (type) {
        case ZAlertType.success:
          color = Colors.green;
          break;
        case ZAlertType.failed:
          color = Colors.red;
          break;
        case ZAlertType.info:
          color = Colors.lightBlue;
          break;
        case ZAlertType.normal:
          color = Colors.grey;
          break;
      }
    }

    switch (shape) {
      case ZAlertShape.defaultRadius:
        selectedShape = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        );
        break;

      case ZAlertShape.sharp:
        selectedShape = RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        );
        break;

      case ZAlertShape.rounded:
        selectedShape = StadiumBorder();
        break;
    }

    _overlayEntry =
        OverlayEntry(builder: (BuildContext context) => _build(context));

    Overlay.of(context).insert(_overlayEntry);

    Future.delayed(selectedDuration).whenComplete(() => _overlayEntry.remove());
  }

  Widget _build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: alignment,
        child: Directionality(
          textDirection: textDirection,
          child: Container(
            width: MediaQuery.of(context).size.width / 1.5,
            margin: EdgeInsets.symmetric(vertical: 41.0),
            child: Material(
              color: color,
              textStyle: TextStyle(
                color: Colors.white,
              ),
              shape: (borderRadius != null)
                  ? RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                    )
                  : selectedShape,
              elevation: boxShadow['elevation'],
              shadowColor: boxShadow['color'],
              child: GestureDetector(
                onTap: () => _overlayEntry.remove(),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 7.0, horizontal: 11.0),
                  child: Row(
                    //mainAxisSize: MainAxisSize.min,

                    children: [
                      if (icon != null)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 9.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: icon,
                            radius: 15.0,
                          ),
                        ),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label,
                              style: labelStyle,
                            ),
                            if (subTitle != null)
                              Text(
                                subTitle,
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
    );
  }
}

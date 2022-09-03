/*
* This file is a part of "SimpleAlert" project.
* Khaled Mohsen <pres.kbayomy@gmail.com>
* Copyrights (BSD-3-Clause), LICENSE.
*/
import 'package:flutter/material.dart';

import '../simple_alert.dart';

/// Regular alert with predefined styles for some common cases.
///
/// The parameters [context], [icon], [title], [subTitle] are required.
class SimpleAlert {
  final BuildContext context;
  final SimpleAlertType type;
  final Alignment alignment;
  final SimpleAlertDuration duration;
  final double? borderRadius;
  late final Map<String, dynamic> boxShadow;
  late final Color? color;
  final SimpleAlertBrightness brightness;
  final SimpleAlertShape shape;
  late final ShapeBorder selectedShape;
  final TextDirection textDirection;
  final Icon? icon;
  final String label;
  final TextStyle labelStyle;
  final String? subTitle;
  final TextStyle subTitleStyle;
  late final OverlayEntry _overlayEntry;
  late final Future _delayedFuture; // [Future.delayed]
  //List<BoxShadow> boxShadow;

  SimpleAlert({
    required this.context,
    required this.label,
    this.type = SimpleAlertType.normal,
    this.duration = SimpleAlertDuration.quick,
    this.textDirection = TextDirection.rtl,
    this.alignment = Alignment.topCenter,
    this.color,
    this.brightness = SimpleAlertBrightness.light,
    this.icon,
    this.shape = SimpleAlertShape.defaultRadius,
    this.borderRadius,
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
        assert(label != null) /*assert(subTitle != null)*/ {
    Duration selectedDuration;

    // TODO: Accept a custom duration.
    switch (duration) {
      case SimpleAlertDuration.quick:
        selectedDuration = Duration(seconds: 3);
        break;

      case SimpleAlertDuration.medium:
        selectedDuration = Duration(seconds: 5);
        break;

      case SimpleAlertDuration.long:
        selectedDuration = Duration(seconds: 7);
        break;
    }

    switch (brightness) {
      case SimpleAlertBrightness.dark:
        boxShadow = {
          'color': Colors.black26,
          'elevation': 7.0,
        };
        break;

      case SimpleAlertBrightness.system: // TODO: Handle.
        boxShadow = {
          'color': Colors.black26,
          'elevation': 7.0,
        };
        break;

      case SimpleAlertBrightness.light:
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
        case SimpleAlertType.success:
          color = Colors.green;
          break;
        case SimpleAlertType.failed:
          color = Colors.red;
          break;
        case SimpleAlertType.info:
          color = Colors.lightBlue;
          break;
        case SimpleAlertType.normal:
          color = Colors.grey;
          break;
      }
    }

    // TODO: Make the border radius [int] only, and modify the [Material] and [InkWell].
    switch (shape) {
      case SimpleAlertShape.defaultRadius:
        selectedShape = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        );
        break;

      case SimpleAlertShape.sharp:
        selectedShape = RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        );
        break;

      case SimpleAlertShape.rounded:
        selectedShape = StadiumBorder();
        break;
    }

    _overlayEntry = OverlayEntry(builder: (BuildContext context) => _build(context));

    Overlay.of(context)?.insert(_overlayEntry);

    _delayedFuture = Future.delayed(selectedDuration).whenComplete(() => _overlayEntry.remove());
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
                      borderRadius: BorderRadius.circular(borderRadius!),
                    )
                  : selectedShape,
              elevation: boxShadow['elevation'],
              shadowColor: boxShadow['color'],
              // TODO: Fix the splash area [InkWell > onTap].
              child: InkWell(
                onTap: () {
                  _delayedFuture.ignore();
                  _overlayEntry.remove();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 11.0),
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
    );
  }
}

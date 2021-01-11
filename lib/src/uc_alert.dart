// Copyright ...

import 'dart:ui' show TextDirection;

import 'package:flutter/material.dart' show Align, Alignment, BorderRadius, BoxConstraints, BoxDecoration, BoxShadow, BuildContext, Color, Colors, Column, Container, Directionality, EdgeInsets, Expanded, Icon, ListTile, Material, MediaQuery, Offset, Overlay, OverlayEntry, Padding, RoundedRectangleBorder, SafeArea, Text, Widget, required;

import 'package:uc_alert/src/uc_alert_type.dart';

/// A pre-defined alerts that suits most of known user-need messages.
///
/// The parameters [originContext], [icon], [title], [subTitle] is required.
class UCAlert {
  final BuildContext originContext;
  final Duration duration;
  final UCAlertType type;
  final Alignment alignment;
  final TextDirection textDirection;
  final double width;
  final double height;
  final EdgeInsets margin;
  final List<BoxShadow> boxShadow;
  Color color;
  final double borderRadius;
  final Icon icon;
  final Text title;
  final Text subTitle;

  UCAlert({
    @required this.originContext,
    this.duration = const Duration(seconds: 3),
    this.type = UCAlertType.unknown,
    this.textDirection = TextDirection.rtl,
    this.alignment = Alignment.topCenter,
    this.width,
    this.height = 80.0,
    this.margin = const EdgeInsets.only(top: 20),
    this.color,
    this.boxShadow = const [
      BoxShadow(
        color: Colors.black38,
        offset: Offset(0, 2),
        blurRadius: 5,
        spreadRadius: -2
      )
    ],
    this.borderRadius = 5,
    @required this.icon,
    @required this.title,
    @required this.subTitle
  }) : assert(originContext != null),
       assert(icon != null),
       assert(title != null),
       assert(subTitle != null) {

    if (color == null) {
      switch (type) {
        case UCAlertType.success:
          this.color = Colors.green;
          break;

        case UCAlertType.information:
          this.color = Colors.lightBlueAccent;
          break;

        case UCAlertType.error:
          this.color = Colors.red;
          break;

        case UCAlertType.unknown:
        default:
          this.color = Colors.grey;
          break;
      }
    }

    OverlayEntry _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => _build(context)
    );

    Overlay.of(originContext).insert(_overlayEntry);

    Future.delayed(duration).whenComplete(() => _overlayEntry.remove());
  }

  Widget _build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: textDirection,
        child: Align(
          alignment: alignment,
          child: Container(
            width: width ?? MediaQuery.of(context).size.width - 50,
            // TODO: Make height flexible with the content (example: ListTile height via global key)
            constraints: BoxConstraints(
              minHeight: height,
              maxHeight: height
            ),
            margin: margin,
            decoration: BoxDecoration(
              boxShadow: boxShadow
            ),
            child: Material(
              color: color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius)
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(borderRadius)
                      ),
                      leading: Padding(
                        padding: EdgeInsets.only(top: 7.5, right: 5),
                        child: icon
                      ),
                      title: title,
                      subtitle: subTitle
                    )
                  )
                ]
              )
            )
          )
        )
      )
    );
  }
}

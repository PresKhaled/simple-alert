import 'package:flutter/material.dart';

class UCAlert extends StatelessWidget {
  final TextDirection textDirection;
  final double height;
  final Color color;
  final double borderRadius;
  final Icon icon;
  final Text title;
  final Text subTitle;

  UCAlert({
    this.textDirection = TextDirection.rtl,
    this.height = 100.0,
    this.color = Colors.black54,
    this.borderRadius = 7,
    this.icon,
    this.title,
    this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: textDirection,
        child: new Scaffold(
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: height,
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(borderRadius)
                ),
                child: OverflowBox(
                    child: Container(
                        child: Column(
                            children: [
                              ListTile(
                                  leading: icon,
                                  title: title,
                                  subtitle: subTitle ?? '',
                                  isThreeLine: true
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

import 'package:flutter/material.dart';

class SimpleAlertRoute<T> extends PopupRoute<T> {
  final Widget Function(BuildContext context) builder;

  SimpleAlertRoute({
    super.settings,
    super.traversalEdgeBehavior,
    required this.builder,
  });

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildModalBarrier() {
    return Offstage();
  }

  @override
  Duration get transitionDuration => Duration(seconds: 0);

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => '';
}

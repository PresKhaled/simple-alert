import 'package:flutter/material.dart';

import 'ControllerState.dart';

class Alert extends StatefulWidget {
  final Widget child;
  final Duration animatedOpacityDuration;

  const Alert({
    Key? key,
    required this.child,
    required this.animatedOpacityDuration,
  }) : super(key: key);

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    animationController.value = AnimationController(
      vsync: this,
      duration: widget.animatedOpacityDuration,
    );

    animationController.value!.addListener(() {
      setState(() => _opacity = _animation.value);
    });

    _animation = animationController.value!.drive(
      Tween(begin: 0.0, end: 1.0),
    );
  }

  @override
  void dispose() {
    super.dispose();

    animationController.value!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_opacity);
    return Opacity(
      opacity: _opacity,
      child: widget.child,
    );
  }
}

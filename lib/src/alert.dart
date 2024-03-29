import 'package:flutter/material.dart';

class Alert extends StatefulWidget {
  final Widget child;
  final ValueNotifier<AnimationController?> animationController;
  final Duration animatedOpacityDuration;

  const Alert({
    super.key,
    required this.child,
    required this.animationController,
    required this.animatedOpacityDuration,
  });

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> with SingleTickerProviderStateMixin {
  late Animation<double> _opacityAnimation;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    widget.animationController.value = AnimationController(
      vsync: this,
      duration: widget.animatedOpacityDuration,
    )..forward();

    _opacityAnimation = widget.animationController.value!.drive(
      Tween(begin: 0.0, end: 1.0),
    );

    widget.animationController.value!.addListener(() {
      setState(() => _opacity = _opacityAnimation.value);
    });
  }

  @override
  void dispose() {
    widget.animationController.value!.stop();
    widget.animationController.value!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _opacity,
      child: widget.child,
    );
  }
}

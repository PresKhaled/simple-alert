import 'package:flutter/material.dart';

import 'constants.dart';

class ProgressBar extends StatefulWidget {
  final ValueNotifier<AnimationController?> animationController;
  final double alertWidth;
  final Duration alertDuration;

  const ProgressBar({
    Key? key,
    required this.animationController,
    required this.alertWidth,
    required this.alertDuration,
  }) : super(key: key);

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> with SingleTickerProviderStateMixin {
  late Animation<double> _widthAnimation;
  late double _width = widget.alertWidth;

  @override
  void initState() {
    super.initState();

    widget.animationController.value = AnimationController(
      vsync: this,
      duration: widget.alertDuration,
    );

    _widthAnimation = widget.animationController.value!.drive(
      Tween(begin: widget.alertWidth, end: 0.0),
    );

    widget.animationController.value!.addListener(() {
      setState(() => _width = _widthAnimation.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: 5.0,
      margin: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(BORDER_RADIUS),
      ),
    );
  }
}

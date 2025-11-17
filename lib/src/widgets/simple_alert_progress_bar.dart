import 'package:flutter/material.dart';

import '../misc/constants.dart';

/// A widget that displays a progress bar which animates its width from full to zero.
///
/// This progress bar is typically used to visually indicate a countdown or duration
/// for an alert. It utilizes an [AnimationController] to drive the animation
/// and reflects the remaining time visually.
class SimpleAlertProgressBar extends StatefulWidget {
  /// A [ValueNotifier] that holds the [AnimationController] for the width animation.
  ///
  /// This controller is created and managed by the [SimpleAlertProgressBar] widget internally.
  /// It is exposed through this [ValueNotifier] to allow external observation
  /// and control of the animation's lifecycle. The notifier is initially `null`
  /// and is set within the [initState] of the [_SimpleAlertProgressBarState].
  final ValueNotifier<AnimationController?> animationController;

  /// The initial width of the progress bar, typically matching the width of the alert.
  final double alertWidth;

  /// The total duration of the progress bar animation.
  ///
  /// This determines how long it takes for the progress bar to animate from
  /// its full width to zero.
  final Duration alertDuration;

  /// Creates a [SimpleAlertProgressBar] widget.
  ///
  /// The [animationController], [alertWidth], and [alertDuration] parameters
  /// must not be null.
  const SimpleAlertProgressBar({
    super.key,
    required this.animationController,
    required this.alertWidth,
    required this.alertDuration,
  });

  @override
  State<SimpleAlertProgressBar> createState() => _SimpleAlertProgressBarState();
}

class _SimpleAlertProgressBarState extends State<SimpleAlertProgressBar> with SingleTickerProviderStateMixin {
  late Animation<double> _widthAnimation;
  late double _width = widget.alertWidth;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController and assign it to the ValueNotifier.
    // This controller drives the progress bar's width animation.
    widget.animationController.value = AnimationController(
      vsync: this,
      duration: widget.alertDuration,
    )..forward(); // Start the animation immediately to begin the countdown.

    // Create a Tween animation for the width, from the initial alertWidth to 0.0.
    _widthAnimation = widget.animationController.value!.drive(
      Tween(begin: widget.alertWidth, end: 0.0),
    );

    // Add a listener to the animation to update the width and trigger a rebuild.
    widget.animationController.value!.addListener(() {
      setState(() => _width = _widthAnimation.value);
    });
  }

  @override
  void dispose() {
    // Stop and dispose of the AnimationController to free up resources.
    widget.animationController.value!.stop();
    widget.animationController.value!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Render the progress bar as a Container with animated width.
    // A Semantics widget is used to provide accessibility information for screen readers.
    return Semantics(
      label: 'Alert timer', // TODO
      value: '${((_width / widget.alertWidth) * 100).round()}% remaining',
      child: Container(
        width: _width,
        height: 5.0, // Hardcoded height for the progress bar.
        margin: const EdgeInsets.only(top: 8.0), // Hardcoded top margin.
        decoration: BoxDecoration(
          color: Colors.white, // Hardcoded color for the progress bar.
          borderRadius: BorderRadius.circular(BORDER_RADIUS),
        ),
      ),
    );
  }
}

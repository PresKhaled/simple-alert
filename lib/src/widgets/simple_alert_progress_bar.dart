import 'package:flutter/material.dart';

import '../../i18n/translations.g.dart';
import '../misc/constants.dart';

/// A widget that displays a progress bar which animates its width from full to zero.
///
/// This progress bar is typically used to visually indicate a countdown or duration
/// for an alert. It utilizes an [AnimationController] to drive the animation
/// and reflects the remaining time visually.
class SimpleAlertProgressBar extends StatefulWidget {
  /// A callback executed when the internal [AnimationController] is created.
  final ValueChanged<AnimationController> onAnimationControllerCreated;

  /// The initial width of the progress bar, typically matching the width of the alert.
  final double alertWidth;

  /// The total duration of the progress bar animation.
  ///
  /// This determines how long it takes for the progress bar to animate from
  /// its full width to zero.
  final Duration alertDuration;

  /// Creates a [SimpleAlertProgressBar] widget.
  ///
  /// The [onAnimationControllerCreated], [alertWidth], and [alertDuration] parameters
  /// must not be null.
  const SimpleAlertProgressBar({
    super.key,
    required this.onAnimationControllerCreated,
    required this.alertWidth,
    required this.alertDuration,
  });

  @override
  State<SimpleAlertProgressBar> createState() => _SimpleAlertProgressBarState();
}

class _SimpleAlertProgressBarState extends State<SimpleAlertProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _widthAnimation;
  late double _width = widget.alertWidth;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController.
    // This controller drives the progress bar's width animation.
    _controller = AnimationController(
      vsync: this,
      duration: widget.alertDuration,
    )..forward(); // Start the animation immediately to begin the countdown.

    widget.onAnimationControllerCreated(_controller);

    // Create a Tween animation for the width, from the initial alertWidth to 0.0.
    _widthAnimation = _controller.drive(
      Tween(begin: widget.alertWidth, end: 0.0),
    );

    // Add a listener to the animation to update the width and trigger a rebuild.
    _controller.addListener(() {
      setState(() => _width = _widthAnimation.value);
    });
  }

  @override
  void dispose() {
    // Stop and dispose of the AnimationController to free up resources.
    _controller.stop();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Render the progress bar as a Container with animated width.
    // A Semantics widget is used to provide accessibility information for screen readers.
    return Semantics(
      label: t.alertTimerSemanticLabel,
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

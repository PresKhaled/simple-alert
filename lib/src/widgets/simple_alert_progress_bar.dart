import 'package:flutter/material.dart';

import '../../i18n/translations.g.dart';

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

  /// The foreground color of the alert, used to derive the progress bar's color.
  final Color foregroundColor;

  /// Creates a [SimpleAlertProgressBar] widget.
  ///
  /// The [onAnimationControllerCreated], [alertWidth], [alertDuration],
  /// and [foregroundColor] parameters must not be null.
  const SimpleAlertProgressBar({
    super.key,
    required this.onAnimationControllerCreated,
    required this.alertWidth,
    required this.alertDuration,
    required this.foregroundColor,
  });

  @override
  State<SimpleAlertProgressBar> createState() => _SimpleAlertProgressBarState();
}

class _SimpleAlertProgressBarState extends State<SimpleAlertProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController.
    _controller = AnimationController(
      vsync: this,
      duration: widget.alertDuration,
    )..forward();

    widget.onAnimationControllerCreated(_controller);

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barColor = widget.foregroundColor.withValues(alpha: 0.90);
    final trackColor = widget.foregroundColor.withValues(alpha: 0.18);
    final progressFraction = (1.0 - _controller.value).clamp(0.0, 1.0);

    return Semantics(
      label: t.alertTimerSemanticLabel,
      value: '${(progressFraction * 100).round()}% remaining',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          return ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Container(
              width: totalWidth,
              height: 3.5,
              color: trackColor,
              alignment: AlignmentDirectional.centerStart,
              child: Container(
                width: totalWidth * progressFraction,
                height: 3.5,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(4.0),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

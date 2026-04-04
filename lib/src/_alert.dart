import 'package:flutter/material.dart';

/// A widget that displays an animated alert with fade-in opacity transition.
///
/// The [Alert] widget wraps a child widget and applies an opacity animation
/// when it's displayed. It uses an [AnimationController] to manage the
/// animation lifecycle.
///
/// Example usage:
/// ```dart
/// Alert(
///   onAnimationControllerCreated: (controller) => _myController = controller,
///   animatedOpacityDuration: Duration(milliseconds: 300),
///   child: Text('This is an alert'),
/// )
/// ```
class Alert extends StatefulWidget {
  /// The widget below this widget in the tree.
  ///
  /// This child widget will be displayed with the opacity animation.
  final Widget child;

  /// A callback executed when the internal [AnimationController] is created.
  final ValueChanged<AnimationController> onAnimationControllerCreated;

  /// The duration of the opacity animation.
  ///
  /// This determines how long the fade-in effect will take to complete.
  final Duration animatedOpacityDuration;

  /// Creates an [Alert] widget.
  ///
  /// The [child], [onAnimationControllerCreated], and [animatedOpacityDuration] parameters
  /// must not be null.
  const Alert({
    super.key,
    required this.child,
    required this.onAnimationControllerCreated,
    required this.animatedOpacityDuration,
  });

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _opacityAnimation;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Initialize the [AnimationController].
    // This controller manages the fade-in animation for the alert.
    _controller = AnimationController(
      vsync: this,
      duration: widget.animatedOpacityDuration,
    )..forward(); // Start the animation immediately.

    widget.onAnimationControllerCreated(_controller);

    // Create a [Tween] animation for opacity from 0.0 to 1.0, driven by the controller.
    _opacityAnimation = _controller.drive(
      Tween(begin: 0.0, end: 1.0),
    );

    // Add a listener to the animation to update the opacity and trigger a rebuild.
    _controller.addListener(() {
      setState(() => (_opacity = _opacityAnimation.value));
    });
  }

  @override
  void dispose() {
    // Stop and dispose of the [AnimationController] to free up resources.
    _controller.stop();
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Render the child widget with the current opacity value.
    return Opacity(
      opacity: _opacity,
      child: widget.child,
    );
  }
}

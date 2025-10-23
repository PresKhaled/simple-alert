import 'package:flutter/material.dart';

/// A widget that displays an animated alert with fade-in opacity transition.
///
/// The [Alert] widget wraps a child widget and applies an opacity animation
/// when it's displayed. It uses an [AnimationController] to manage the
/// animation lifecycle.
///
/// Example usage:
/// ```dart
/// ValueNotifier<AnimationController?> controller = ValueNotifier(null);
/// Alert(
///   animationController: controller,
///   animatedOpacityDuration: Duration(milliseconds: 300),
///   child: Text('This is an alert'),
/// )
/// ```
class Alert extends StatefulWidget {
  /// The widget below this widget in the tree.
  ///
  /// This child widget will be displayed with the opacity animation.
  final Widget child;

  /// A [ValueNotifier] that holds the [AnimationController] for the opacity animation.
  ///
  /// This controller is created and managed by the [Alert] widget internally.
  /// It is exposed through this [ValueNotifier] to allow external observation
  /// and control of the animation's lifecycle. The notifier is initially `null`
  /// and is set within the [initState] of the [AlertState].
  final ValueNotifier<AnimationController?> animationController;

  /// The duration of the opacity animation.
  ///
  /// This determines how long the fade-in effect will take to complete.
  final Duration animatedOpacityDuration;

  /// Creates an [Alert] widget.
  ///
  /// The [child], [animationController], and [animatedOpacityDuration] parameters
  /// must not be null.
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

    // Initialize the AnimationController and assign it to the ValueNotifier.
    // This controller manages the fade-in animation for the alert.
    widget.animationController.value = AnimationController(
      vsync: this,
      duration: widget.animatedOpacityDuration,
    )..forward(); // Start the animation immediately.

    // Create a Tween animation for opacity from 0.0 to 1.0, driven by the controller.
    _opacityAnimation = widget.animationController.value!.drive(
      Tween(begin: 0.0, end: 1.0),
    );

    // Add a listener to the animation to update the opacity and trigger a rebuild.
    widget.animationController.value!.addListener(() {
      setState(() => _opacity = _opacityAnimation.value);
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
    // Render the child widget with the current opacity value.
    return Opacity(
      opacity: _opacity,
      child: widget.child,
    );
  }
}

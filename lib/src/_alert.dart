import 'package:flutter/material.dart';

import 'misc/constants.dart';

/// A widget that displays an animated alert with directional slide, scale, and fade transitions.
///
/// The [Alert] widget wraps a child widget and applies physics-based entrance
/// and exit animations driven by an [AnimationController].
class Alert extends StatefulWidget {
  /// The widget below this widget in the tree.
  final Widget child;

  /// The alignment of the alert, used to determine the slide direction.
  final AlignmentDirectional alignment;

  /// A callback executed when the internal [AnimationController] is created.
  final ValueChanged<AnimationController> onAnimationControllerCreated;

  /// The duration of the transition animation.
  final Duration animatedOpacityDuration;

  /// Creates an [Alert] widget.
  const Alert({
    super.key,
    required this.child,
    this.alignment = AlignmentDirectional.topCenter,
    required this.onAnimationControllerCreated,
    required this.animatedOpacityDuration,
  });

  @override
  State<Alert> createState() => _AlertState();
}

class _AlertState extends State<Alert> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curvedAnimation;
  late final Animation<double> _opacityAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.animatedOpacityDuration,
      reverseDuration: widget.animatedOpacityDuration,
    )..forward();

    widget.onAnimationControllerCreated(_controller);

    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: DEFAULT_ALERT_CURVE,
      reverseCurve: Curves.easeInCubic,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_curvedAnimation);

    // Compute initial slide offset based on vertical alignment
    final Offset beginSlide;
    if (widget.alignment.y < 0) {
      // Top-aligned: slide smoothly down from top
      beginSlide = const Offset(0.0, -0.35);
    } else if (widget.alignment.y > 0) {
      // Bottom-aligned: slide smoothly up from bottom
      beginSlide = const Offset(0.0, 0.35);
    } else {
      // Center: subtle drop
      beginSlide = const Offset(0.0, -0.12);
    }

    _slideAnimation = Tween<Offset>(
      begin: beginSlide,
      end: Offset.zero,
    ).animate(_curvedAnimation);

    _scaleAnimation = Tween<double>(
      begin: 0.94,
      end: 1.0,
    ).animate(_curvedAnimation);
  }

  @override
  void dispose() {
    try {
      _curvedAnimation.dispose();
      _controller.stop();
      _controller.dispose();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return FadeTransition(
        opacity: _opacityAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: widget.child,
          ),
        ),
      );
    } catch (e) {
      debugPrint('SimpleAlert Alert safe error: $e');
      return const SizedBox.shrink();
    }
  }
}

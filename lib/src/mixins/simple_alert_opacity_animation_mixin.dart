import 'package:flutter/material.dart' show AnimationController;

/// A mixin that provides an [AnimationController]
/// for opacity animations.
///
/// This mixin is designed for use by classes that must control
/// the fade and fade-out effects of a widget. The [AnimationController]
/// should be initialized by the consuming widget.
mixin OpacityAnimationMixin {
  /// The [AnimationController] for opacity animations.
  AnimationController? opacityAnimationController;
}

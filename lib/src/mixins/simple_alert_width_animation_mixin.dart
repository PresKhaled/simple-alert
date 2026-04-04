import 'package:flutter/material.dart' show AnimationController;

/// A mixin that provides an [AnimationController]
/// for width animations.
///
/// This mixin is designed for use by classes that must control
/// the animation of a widget's width. The [AnimationController]
/// should be initialized by the consuming widget.
mixin WidthAnimationMixin {
  /// The [AnimationController] for width animations.
  AnimationController? widthAnimationController;
}

import 'package:flutter/material.dart' show AnimationController, ValueNotifier;

/// A mixin that provides a [ValueNotifier] to manage an [AnimationController]
/// for width animations.
///
/// This mixin is designed for use by classes that need to control
/// the animation of a widget's width, often for effects like a progress bar
/// or a shrinking/expanding element. The [AnimationController] held by the
/// [ValueNotifier] should be initialized by the consuming widget
/// (e.g., a [StatefulWidget]'s [initState]) which provides a [TickerProvider].
///
/// Example usage:
/// ```dart
/// class MyWidgetState extends State<MyWidget> with SingleTickerProviderStateMixin, WidthAnimationMixin {
///   @override
///   void initState() {
///     super.initState();
///     widthAnimationController.value = AnimationController(
///       vsync: this,
///       duration: const Duration(milliseconds: 1000),
///     );
///     // ... use widthAnimationController.value
///   }
///
///   @override
///   void dispose() {
///     widthAnimationController.value?.dispose();
///     super.dispose();
///   }
/// }
/// ```
mixin WidthAnimationMixin {
  /// A [ValueNotifier] holding the [AnimationController] for width animations.
  ///
  /// It is initially `null` and must be initialized by the consuming widget
  /// typically in its `initState` method.
  ValueNotifier<AnimationController?> widthAnimationController = ValueNotifier<AnimationController?>(null);
}

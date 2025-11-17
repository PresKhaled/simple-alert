import 'package:flutter/material.dart' show AnimationController, ValueNotifier;

/// A mixin that provides a [ValueNotifier] to manage an [AnimationController]
/// for opacity animations.
///
/// This mixin is designed for use by classes that need to control
/// the fade and fade-out effects of a widget. The [AnimationController]
/// held by the [ValueNotifier] should be initialized by the consuming widget
/// (e.g., a [StatefulWidget]'s [initState]) which provides a [TickerProvider].
///
/// Example usage:
/// ```dart
/// class MyWidgetState extends State<MyWidget> with SingleTickerProviderStateMixin, OpacityAnimationMixin {
///   @override
///   void initState() {
///     super.initState();
///     opacityAnimationController.value = AnimationController(
///       vsync: this,
///       duration: const Duration(milliseconds: 500),
///     );
///     // ... use opacityAnimationController.value
///   }
///
///   @override
///   void dispose() {
///     opacityAnimationController.value?.dispose();
///     super.dispose();
///   }
/// }
/// ```
mixin OpacityAnimationMixin {
  /// A [ValueNotifier] holding the [AnimationController] for opacity animations.
  ///
  /// It is initially `null` and must be initialized by the consuming widget
  /// typically in its `initState` method.
  ValueNotifier<AnimationController?> opacityAnimationController = ValueNotifier<AnimationController?>(null);
}

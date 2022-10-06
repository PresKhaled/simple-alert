import 'package:flutter/material.dart' show AnimationController, ValueNotifier;

mixin OpacityAnimationMixin {
  ValueNotifier<AnimationController?> opacityAnimationController = ValueNotifier<AnimationController?>(null);
}

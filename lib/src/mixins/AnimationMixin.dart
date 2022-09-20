import 'package:flutter/material.dart' show AnimationController, ValueNotifier;

mixin AnimationMixin {
  ValueNotifier<AnimationController?> animationController = ValueNotifier<AnimationController?>(null);
}

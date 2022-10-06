import 'package:flutter/material.dart' show AnimationController, ValueNotifier;

mixin WidthAnimationMixin {
  ValueNotifier<AnimationController?> widthAnimationController = ValueNotifier<AnimationController?>(null);
}

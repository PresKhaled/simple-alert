import 'dart:async';

import 'package:flutter/foundation.dart'; // For ValueNotifier, VoidCallback

/// Manages the countdown timer for alert auto-dismissal.
class AlertTimerController {
  /// The total duration for which the timer should run.
  final Duration duration;

  /// A [ValueNotifier] that holds the remaining milliseconds until the timer completes.
  final ValueNotifier<int> remainingMilliseconds;

  /// A callback function that is invoked when the timer completes.
  final VoidCallback onComplete;

  /// The internal timer instance.
  Timer? _timer;

  /// A flag indicating whether the timer is currently paused.
  bool _isPaused = false;

  /// A flag indicating whether the timer has been disposed.
  bool _isDisposed = false;

  /// Creates an instance of [AlertTimerController] to manage alert timers.
  AlertTimerController({
    required this.duration,
    required this.onComplete,
  }) : remainingMilliseconds = ValueNotifier<int>(duration.inMilliseconds);

  /// Starts the countdown timer.
  ///
  /// The timer ticks every 100 milliseconds, updating [remainingMilliseconds]
  /// and calling [onComplete] when the duration expires. The periodic timer
  /// is automatically cancelled after [onComplete] fires to prevent zombie ticks.
  void start() {
    if (_isDisposed) return;

    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isDisposed) {
        timer.cancel();
        return;
      }

      if (!_isPaused && remainingMilliseconds.value > 0) {
        remainingMilliseconds.value -= 100;

        if (remainingMilliseconds.value <= 0) {
          timer.cancel(); // Prevent further periodic ticks after completion.
          onComplete();
        }
      }
    });
  }

  /// Cancels the periodic timer without disposing of managed resources.
  ///
  /// Unlike [dispose], this method only halts the timer and can be called
  /// safely before the full disposal sequence. This is primarily used by
  /// the closing sequence to immediately stop the timer before async work begins.
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Pauses the countdown timer.
  void pause() {
    _isPaused = true;
  }

  /// Resumes the countdown timer from its current state.
  void resume() {
    _isPaused = false;
  }

  /// Disposes of the timer and [remainingMilliseconds] [ValueNotifier]
  /// to release resources.
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _timer = null;
    remainingMilliseconds.dispose();
  }
}

import 'package:flutter/material.dart';

/// A custom [PopupRoute] implementation for displaying [SimpleAlert] widgets.
///
/// This route is designed to present alerts without a visible modal barrier
/// and with no transition duration, allowing alerts to appear instantly
/// and without obstructing background content interactively.
///
/// Example usage:
/// ```dart
/// Navigator.of(context).push(SimpleAlertRoute(
///   builder: (BuildContext context) {
///     return Text('My Alert Content');
///   },
/// ));
/// ```
class SimpleAlertRoute<T> extends PopupRoute<T> {
  /// A builder function that returns the content of the route.
  ///
  /// This widget will be displayed as the main content of the alert.
  final Widget Function(BuildContext context) builder;

  /// Creates a [SimpleAlertRoute].
  ///
  /// The [builder] parameter is required and provides the content for the route.
  SimpleAlertRoute({
    super.settings,
    super.traversalEdgeBehavior,
    required this.builder,
  });

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    // The main content of the route is built directly from the specified builder.
    return builder(context);
  }

  @override
  Widget buildModalBarrier() {
    // Returns an Offstage widget to ensure no visible modal barrier is rendered,
    // allowing interaction with widgets behind the alert if desired (though barrierDismissible is false here).
    return const Offstage();
  }

  @override
  Duration get transitionDuration => const Duration(seconds: 0);

  @override
  Color? get barrierColor => null; // No barrier color, making the barrier invisible.

  @override
  bool get barrierDismissible => false; // The barrier is not dismissible by tapping outside.

  @override
  String? get barrierLabel => null; // No semantic label for the barrier as it's not interactive.
}

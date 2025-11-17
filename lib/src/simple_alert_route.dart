import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// A custom [PopupRoute] implementation for displaying [SimpleAlert] widgets.
///
/// This route is designed to present alerts without a visible modal barrier
/// and with no transition duration, allowing alerts to appear instantly
/// and without obstructing background content interactively.
///
/// Example usage:
/// ```dart
/// Navigator.of(context).push(SimpleAlertRoute<void>(
///   builder: (BuildContext context) {
///     return const Text('My Alert Content');
///   },
/// ));
/// ```
class SimpleAlertRoute<T> extends PopupRoute<T> {
  /// A builder function that returns the content of the route.
  ///
  /// This widget will be displayed as the main content of the alert.
  final WidgetBuilder builder;

  /// Creates a [SimpleAlertRoute].
  ///
  /// The [builder] parameter is mandatory and provides the content for the route.
  SimpleAlertRoute({
    required this.builder,
    super.filter,
    super.settings,
    super.traversalEdgeBehavior,
  });

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // Wrap the builder content to ensure proper semantic boundaries.
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: Builder(
        builder: (BuildContext context) {
          return builder(context);
        },
      ),
    );
  }

  @override
  Widget buildModalBarrier() {
    return const SizedBox.shrink();
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // No transitions, return content directly.
    return child;
  }

  @override
  Duration get transitionDuration => Duration.zero;
  @override
  Duration get reverseTransitionDuration => Duration.zero;

  @override
  Color? get barrierColor => null; // No barrier color, making the barrier invisible.
  @override
  bool get barrierDismissible => false; // The barrier is not dismissible by tapping outside.
  @override
  String? get barrierLabel => null; // No semantic label for the barrier as it's not interactive.
  @override
  bool get opaque => false;
  @override
  bool get maintainState => false;
  @override
  bool get semanticsDismissible => false;

  @override
  TickerFuture didPush() {
    // Announce to screen readers when alert is shown.
    final BuildContext? context = navigator?.context;
    if (context != null && context.mounted) {
      // Use a small delay to ensure the widget tree is built.
      Future.microtask(() {
        if (context.mounted) {
          SemanticsService.announce(
            'تم عرض تنبيه جديد', // TODO
            TextDirection.rtl,
          );
        }
      });
    }

    return super.didPush();
  }

  @override
  bool didPop(T? result) {
    // Announce to screen readers when alert is dismissed.
    final BuildContext? context = navigator?.context;
    if (context != null && context.mounted) {
      Future.microtask(() {
        if (context.mounted) {
          SemanticsService.announce(
            'تم إغلاق التنبيه', // TODO
            TextDirection.rtl,
          );
        }
      });
    }

    return super.didPop(result);
  }
}

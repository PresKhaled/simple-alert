import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../i18n/translations.g.dart';

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
    try {
      // Wrap the builder content to ensure proper semantic boundaries.
      return Semantics(
        scopesRoute: true,
        explicitChildNodes: true,
        child: Builder(
          builder: (BuildContext context) {
            try {
              return builder(context);
            } catch (e) {
              debugPrint('SimpleAlertRoute builder safe error: $e');
              return const SizedBox.shrink();
            }
          },
        ),
      );
    } catch (e) {
      debugPrint('SimpleAlertRoute buildPage safe error: $e');
      return const SizedBox.shrink();
    }
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
  Color? get barrierColor =>
      null; // No barrier color, making the barrier invisible.
  @override
  bool get barrierDismissible =>
      false; // The barrier is not dismissible by tapping outside.
  @override
  String? get barrierLabel =>
      null; // No semantic label for the barrier as it's not interactive.
  @override
  bool get opaque => false;
  @override
  bool get maintainState => false;
  @override
  bool get semanticsDismissible => false;

  @override
  TickerFuture didPush() {
    try {
      // Announce to screen readers when alert is shown.
      final BuildContext? context = navigator?.context;
      if (context != null && context.mounted) {
        // Use a small delay to ensure the widget tree is built.
        Future.microtask(() {
          try {
            if (context.mounted) {
              // ignore: deprecated_member_use
              SemanticsService.announce(
                t.newAlertDisplayedAnnouncement,
                TextDirection.rtl,
              );
            }
          } catch (_) {}
        });
      }
    } catch (_) {}

    return super.didPush();
  }

  @override
  bool didPop(T? result) {
    try {
      // Announce to screen readers when alert is dismissed.
      final BuildContext? context = navigator?.context;
      if (context != null && context.mounted) {
        Future.microtask(() {
          try {
            if (context.mounted) {
              // ignore: deprecated_member_use
              SemanticsService.announce(
                t.alertClosedAnnouncement,
                TextDirection.rtl,
              );
            }
          } catch (_) {}
        });
      }
    } catch (_) {}

    return super.didPop(result);
  }
}

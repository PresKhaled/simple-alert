import 'package:flutter/material.dart';
import '../backend/alert_manager.dart';
import '../misc/constants.dart';
import 'simple_alert_interactive_container.dart';

/// A widget that builds the [AnimatedPositioned] widget for the alert within a [Stack].
class SimpleAlertPositionedContainer extends StatelessWidget {
  /// Creates a [SimpleAlertPositionedContainer] instance.
  const SimpleAlertPositionedContainer({
    super.key,
    required this.alertKey,
    required this.resolvedAlignment,
    required this.alertWidth,
    required this.calculateVerticalOffset,
    required this.alertManager,
    required this.routeName,
    required this.currentOrientation,
    required this.screenHeight,
    // Properties for SimpleAlertInteractiveContainer
    required this.title,
    this.description,
    this.textDirection,
    required this.withProgressBar,
    required this.closeOnPress,
    required this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    required this.getBorderRadius,
    required this.getBackgroundColor,
    required this.loading,
    required this.centerContent,
    this.actions,
    required this.withClose,
    required this.onWidthAnimationControllerCreated,
    required this.resolvedDuration,
    required this.getForegroundColor,
    required this.getIcon,
    required this.onClosePressed,
    this.onDismissedImmediate,
  });

  /// A global key used to obtain the render box of the alert for size calculations.
  final GlobalKey alertKey;

  /// The resolved alignment for the alert.
  final AlignmentDirectional resolvedAlignment;

  /// The calculated width of the alert.
  final double alertWidth;

  /// Callback function to calculate the vertical offset for the alert.
  final double Function(Map<String, AlertData>, Orientation, double)
      calculateVerticalOffset;

  /// The alert manager responsible for tracking active alerts.
  final AlertManager alertManager;

  /// The unique route name for this specific alert instance.
  final String routeName;

  /// The current orientation of the device.
  final Orientation currentOrientation;

  /// The total height of the screen.
  final double screenHeight;

  // Properties to pass down to SimpleAlertInteractiveContainer
  final String title;
  final String? description;
  final TextDirection? textDirection;
  final bool withProgressBar;
  final bool closeOnPress;
  final VoidCallback onTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final BorderRadius Function() getBorderRadius;
  final Color Function() getBackgroundColor;
  final bool loading;
  final bool centerContent;
  final List<IconButton>? actions;
  final bool withClose;
  final ValueChanged<AnimationController> onWidthAnimationControllerCreated;
  final Duration resolvedDuration;
  final Color Function() getForegroundColor;
  final Icon Function() getIcon;
  final VoidCallback onClosePressed;

  /// Optional callback invoked when the alert is swiped off-screen for immediate dismissal.
  final VoidCallback? onDismissedImmediate;

  @override
  Widget build(BuildContext context) {
    try {
      return Stack(
        alignment: resolvedAlignment, // Align children of the stack.
        fit: StackFit.expand, // Make stack fill available space.
        children: [
          ValueListenableBuilder<Map<String, AlertData>>(
            valueListenable: alertManager
                .displayedAlerts, // Listens to changes in displayed alerts.
            builder: (context, displayedAlerts, child) {
              try {
                // Calculate the vertical offset to stack alerts correctly.
                final offsetY = calculateVerticalOffset(
                  displayedAlerts,
                  currentOrientation,
                  screenHeight,
                );

                return AnimatedPositioned(
                  key: alertKey, // Key to identify the alert's render box.
                  duration: DEFAULT_REPOSITION_DURATION,
                  curve: DEFAULT_ALERT_CURVE,
                  width: alertWidth,
                  // Position from top if aligned to top or center, otherwise null.
                  top: (AlertManager.isTopAligned(resolvedAlignment) ||
                          AlertManager.isCenterAligned(resolvedAlignment))
                      ? offsetY
                      : null,
                  // Position from bottom if aligned to bottom, otherwise null.
                  bottom: AlertManager.isBottomAligned(resolvedAlignment)
                      ? offsetY
                      : null,
                  child: SimpleAlertInteractiveContainer(
                    routeName: routeName,
                    alertWidth: alertWidth,
                    title: title,
                    description: description,
                    textDirection: textDirection,
                    withProgressBar: withProgressBar,
                    closeOnPress: closeOnPress,
                    onTap: onTap,
                    onTapDown: onTapDown,
                    onTapUp: onTapUp,
                    onTapCancel: onTapCancel,
                    getBorderRadius: getBorderRadius,
                    getBackgroundColor: getBackgroundColor,
                    loading: loading,
                    centerContent: centerContent,
                    actions: actions,
                    withClose: withClose,
                    onWidthAnimationControllerCreated:
                        onWidthAnimationControllerCreated,
                    resolvedDuration: resolvedDuration,
                    getForegroundColor: getForegroundColor,
                    getIcon: getIcon,
                    onClosePressed: onClosePressed,
                    onDismissedImmediate: onDismissedImmediate,
                  ),
                );
              } catch (e) {
                debugPrint('SimpleAlertPositionedContainer builder safe error: $e');
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      );
    } catch (e) {
      debugPrint('SimpleAlertPositionedContainer safe error: $e');
      return const SizedBox.shrink();
    }
  }
}

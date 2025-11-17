import 'package:flutter/material.dart';
import '../backend/alert_manager.dart';
import 'simple_alert_positioned_container.dart';
import '../simple_alert.dart';

/// A widget that wraps the alert content in a [SafeArea] and handles orientation changes.
class SimpleAlertSafeAreaWrapper extends StatefulWidget {
  /// Creates a [SimpleAlertSafeAreaWrapper] instance.
  const SimpleAlertSafeAreaWrapper({
    super.key,
    required this.alertKey,
    required this.resolvedAlignment,
    required this.alertWidth,
    required this.calculateVerticalOffset,
    required this.alertManager,
    required this.routeName,
    required this.updateAlertSize,
    // Properties for SimpleAlertPositionedContainer
    required this.title,
    this.description,
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
    required this.widthAnimationController,
    required this.resolvedDuration,
    required this.getForegroundColor,
    required this.getIcon,
    required this.onClosePressed,
  });

  /// A global key used to obtain the render box of the alert for size calculations.
  final GlobalKey alertKey;

  /// The resolved alignment for the alert.
  final AlignmentDirectional resolvedAlignment;

  /// The calculated width of the alert.
  final double alertWidth;

  /// Callback function to calculate the vertical offset for the alert.
  final double Function(Map<String, AlertData>, Orientation, double) calculateVerticalOffset;

  /// The alert manager responsible for tracking active alerts.
  final AlertManager alertManager;

  /// The unique route name for this specific alert instance.
  final String routeName;

  /// Callback function to update the size of an alert in the `_AlertManager`.
  final void Function(String, Size) updateAlertSize;

  // Properties to pass down to SimpleAlertPositionedContainer
  final String title;
  final String? description;
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
  final ValueNotifier<AnimationController?> widthAnimationController;
  final Duration resolvedDuration;
  final Color Function() getForegroundColor;
  final Icon Function() getIcon;
  final VoidCallback onClosePressed;

  @override
  State<SimpleAlertSafeAreaWrapper> createState() => _SimpleAlertSafeAreaWrapperState();
}

class _SimpleAlertSafeAreaWrapperState extends State<SimpleAlertSafeAreaWrapper> {
  Orientation? _currentOrientation;

  /// Handles changes in device orientation, ensuring all displayed alerts update their sizes.
  ///
  /// This method is called whenever the device orientation changes. It compares
  /// the new orientation with the `_currentOrientation` and, if different,
  /// triggers a post-frame callback to iterate through all registered alerts
  /// and update their sizes in the `_AlertManager`.
  /// This ensures correct positioning and rendering after an orientation shift.
  ///
  /// [orientation] The new [Orientation] of the device.
  void _handleOrientationChange(Orientation orientation) {
    if (_currentOrientation != orientation) {
      _currentOrientation = orientation;

      // Update sizes for all alerts after orientation change
      // This is crucial for correct positioning of stacked alerts.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        for (final routeName in widget.alertManager.displayedAlerts.value.keys) {
          final key = widget.alertKey;
          if (key.currentContext != null) {
            final renderBox = key.currentContext!.findRenderObject() as RenderBox?;
            if (renderBox != null && renderBox.hasSize) {
              widget.updateAlertSize(routeName, renderBox.size);
            }
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: OrientationBuilder(
        builder: (context, orientation) {
          // Handle orientation changes and update alert sizes.
          _handleOrientationChange(orientation);
          // Build the alert positioned on the screen.
          final mediaSize = MediaQuery.sizeOf(context);
          return SimpleAlertPositionedContainer(
            alertKey: widget.alertKey,
            resolvedAlignment: widget.resolvedAlignment,
            alertWidth: widget.alertWidth,
            calculateVerticalOffset: widget.calculateVerticalOffset,
            alertManager: widget.alertManager,
            routeName: widget.routeName,
            currentOrientation: orientation,
            screenHeight: mediaSize.height,
            // Pass-through properties for SimpleAlertInteractiveContainer
            title: widget.title,
            description: widget.description,
            withProgressBar: widget.withProgressBar,
            closeOnPress: widget.closeOnPress,
            onTap: widget.onTap,
            onTapDown: widget.onTapDown,
            onTapUp: widget.onTapUp,
            onTapCancel: widget.onTapCancel,
            getBorderRadius: widget.getBorderRadius,
            getBackgroundColor: widget.getBackgroundColor,
            loading: widget.loading,
            centerContent: widget.centerContent,
            actions: widget.actions,
            withClose: widget.withClose,
            widthAnimationController: widget.widthAnimationController,
            resolvedDuration: widget.resolvedDuration,
            getForegroundColor: widget.getForegroundColor,
            getIcon: widget.getIcon,
            onClosePressed: widget.onClosePressed,
          );
        },
      ),
    );
  }
}

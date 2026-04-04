import 'package:flutter/material.dart';
import '../_alert.dart';
import 'simple_alert_safe_area_wrapper.dart';
import '../backend/alert_manager.dart';

/// A widget that represents the content of the [SimpleAlertRoute].
///
/// This widget handles the initial setup of the alert, including
/// registering its size and starting the auto-dismissal timer after
/// the first frame is rendered. It also provides the main structure
/// for the alert's UI, including safe area handling and orientation changes.
class SimpleAlertRouteContent extends StatefulWidget {
  /// Creates a [SimpleAlertRouteContent] instance.
  const SimpleAlertRouteContent({
    super.key,
    required this.routeContext,
    required this.onFirstFrameBuilt,
    required this.closeAlert,
    required this.onOpacityAnimationControllerCreated,
    required this.animatedOpacityDuration,
    // Properties for SimpleAlertSafeAreaWrapper
    required this.alertKey,
    required this.resolvedAlignment,
    required this.alertWidth,
    required this.calculateVerticalOffset,
    required this.alertManager,
    required this.routeName,
    required this.updateAlertSize,
    // Pass-through properties for SimpleAlertInteractiveContainer
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
    required this.onWidthAnimationControllerCreated,
    required this.resolvedDuration,
    required this.getForegroundColor,
    required this.getIcon,
    required this.onClosePressed,
  });

  /// The build context of the alert's route.
  final BuildContext routeContext;

  /// Callback to be invoked after the first frame of the alert is built.
  final VoidCallback onFirstFrameBuilt;

  /// Callback to close the alert.
  final Future<void> Function() closeAlert;

  /// The callback for the opacity animation controller.
  final ValueChanged<AnimationController> onOpacityAnimationControllerCreated;

  /// The duration of the opacity animation.
  final Duration animatedOpacityDuration;

  // Properties for SimpleAlertSafeAreaWrapper
  final GlobalKey alertKey;
  final AlignmentDirectional resolvedAlignment;
  final double alertWidth;
  final double Function(Map<String, AlertData>, Orientation, double)
      calculateVerticalOffset;
  final AlertManager alertManager;
  final String routeName;
  final void Function(String, Size) updateAlertSize;

  // Pass-through properties for SimpleAlertInteractiveContainer
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
  final ValueChanged<AnimationController> onWidthAnimationControllerCreated;
  final Duration resolvedDuration;
  final Color Function() getForegroundColor;
  final Icon Function() getIcon;
  final VoidCallback onClosePressed;

  @override
  State<SimpleAlertRouteContent> createState() =>
      _SimpleAlertRouteContentState();
}

class _SimpleAlertRouteContentState extends State<SimpleAlertRouteContent> {
  @override
  void initState() {
    super.initState();
    // Schedule a callback to run after the first frame is rendered to calculate alert size.
    WidgetsBinding.instance
        .addPostFrameCallback((_) => widget.onFirstFrameBuilt());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:
          false, // Prevent the system back button from directly dismissing the alert.
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        // If a pop is invoked and not prevented by canPop, close the alert gracefully.
        if (!didPop) widget.closeAlert();
      },
      child: Alert(
        onAnimationControllerCreated: widget
            .onOpacityAnimationControllerCreated, // Controller for opacity animations.
        animatedOpacityDuration: widget.animatedOpacityDuration,
        child: SimpleAlertSafeAreaWrapper(
          alertKey: widget.alertKey,
          resolvedAlignment: widget.resolvedAlignment,
          alertWidth: widget.alertWidth,
          calculateVerticalOffset: widget.calculateVerticalOffset,
          alertManager: widget.alertManager,
          routeName: widget.routeName,
          updateAlertSize: widget.updateAlertSize,
          // Pass-through properties for [SimpleAlertInteractiveContainer].
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
          onWidthAnimationControllerCreated:
              widget.onWidthAnimationControllerCreated,
          resolvedDuration: widget.resolvedDuration,
          getForegroundColor: widget.getForegroundColor,
          getIcon: widget.getIcon,
          onClosePressed: widget.onClosePressed,
        ),
      ),
    );
  }
}

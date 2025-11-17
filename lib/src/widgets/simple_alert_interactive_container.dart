import 'package:flutter/material.dart';
import 'simple_alert_inner_content.dart'; // For SimpleAlertInnerContent

/// A widget that provides the interactive container for the alert, including gestures and semantic labels.
class SimpleAlertInteractiveContainer extends StatelessWidget {
  /// Creates a [SimpleAlertInteractiveContainer] instance.
  const SimpleAlertInteractiveContainer({
    super.key,
    required this.alertWidth,
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
    // Properties for SimpleAlertInnerContent
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

  /// The calculated width of the alert.
  final double alertWidth;

  /// The main title text displayed in the alert.
  final String title;

  /// An optional detailed description text for the alert.
  final String? description;

  /// If true, a progress bar indicating the remaining duration will be displayed.
  final bool withProgressBar;

  /// If true, the alert will close when pressed, unless [withProgressBar] is true.
  final bool closeOnPress;

  /// Callback function for a tap gesture on the alert.
  final VoidCallback onTap;

  /// Callback function for a tap down gesture on the alert.
  final GestureTapDownCallback? onTapDown;

  /// Callback function for a tap up gesture on the alert.
  final GestureTapUpCallback? onTapUp;

  /// Callback function for a tap cancel gesture on the alert.
  final GestureTapCancelCallback? onTapCancel;

  /// Callback function to get the border radius for the alert's container.
  final BorderRadius Function() getBorderRadius;

  /// Callback function to get the background color of the alert.
  final Color Function() getBackgroundColor;

  // Properties to pass down to SimpleAlertInnerContent
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
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true, // Announce changes to screen readers.
      label: 'Alert: $title', // Semantic label for the alert. // TODO
      hint: (description ?? ''), // Semantic hint.
      child: GestureDetector(
        onTap: onTap,
        onTapDown: withProgressBar ? onTapDown : null, // Only handle tap down if progress bar is enabled.
        onTapUp: withProgressBar ? onTapUp : null, // Only handle tap up if progress bar is enabled.
        onTapCancel: withProgressBar ? onTapCancel : null, // Only handle tap cancel if progress bar is enabled.
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          padding: const EdgeInsets.symmetric(horizontal: 13.0),
          child: ClipRRect(
            borderRadius: getBorderRadius(), // Apply border radius based on shape.
            child: Material(
              color: getBackgroundColor(), // Set background color.
              child: Padding(
                padding: const EdgeInsets.all(11.0),
                child: SimpleAlertInnerContent(
                  alertWidth: alertWidth,
                  loading: loading,
                  title: title,
                  description: description,
                  centerContent: centerContent,
                  actions: actions,
                  withClose: withClose,
                  withProgressBar: withProgressBar,
                  widthAnimationController: widthAnimationController,
                  resolvedDuration: resolvedDuration,
                  getForegroundColor: getForegroundColor,
                  getBackgroundColor: getBackgroundColor,
                  getIcon: getIcon,
                  onClosePressed: onClosePressed,
                ), // Inner content of the alert.
              ),
            ),
          ),
        ),
      ),
    );
  }
}

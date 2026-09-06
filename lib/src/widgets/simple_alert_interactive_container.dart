import 'package:flutter/material.dart';

import '../../i18n/translations.g.dart';
import '../misc/constants.dart';
import 'simple_alert_inner_content.dart';

/// A widget that provides the interactive container for the alert, including gestures and semantic labels.
class SimpleAlertInteractiveContainer extends StatelessWidget {
  /// Creates a [SimpleAlertInteractiveContainer] instance.
  const SimpleAlertInteractiveContainer({
    super.key,
    required this.routeName,
    required this.alertWidth,
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
    // Properties for SimpleAlertInnerContent
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

  /// The unique route name for this specific alert instance.
  final String routeName;

  /// The calculated width of the alert.
  final double alertWidth;

  /// The main title text displayed in the alert.
  final String title;

  /// An optional detailed description text for the alert.
  final String? description;

  /// The explicit or resolved text direction for the alert.
  final TextDirection? textDirection;

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
  final ValueChanged<AnimationController> onWidthAnimationControllerCreated;
  final Duration resolvedDuration;
  final Color Function() getForegroundColor;
  final Icon Function() getIcon;
  final VoidCallback onClosePressed;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = getBackgroundColor();
    final foregroundColor = getForegroundColor();
    final borderRadius = getBorderRadius();

    return Semantics(
      container: true,
      liveRegion: true, // Announce changes to screen readers.
      label:
          t.alertSemanticLabel(title: title), // Semantic label for the alert.
      hint: (description ?? ''), // Semantic hint.
      child: Dismissible(
        key: ValueKey('SimpleAlert_Dismissible_$routeName'),
        direction: DismissDirection.horizontal,
        onDismissed: (_) => onClosePressed(),
        child: GestureDetector(
          onTap: onTap,
          onTapDown: withProgressBar ? onTapDown : null,
          onTapUp: withProgressBar ? onTapUp : null,
          onTapCancel: withProgressBar ? onTapCancel : null,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: ALERT_VERTICAL_SPACING),
            padding: const EdgeInsets.symmetric(horizontal: ALERT_HORIZONTAL_PADDING),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(
                  color: foregroundColor.withValues(alpha: 0.14),
                  width: 1.0,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.alphaBlend(
                      foregroundColor.withValues(alpha: 0.05),
                      backgroundColor,
                    ),
                    backgroundColor,
                  ],
                ),
                boxShadow: [
                  // Key directional shadow
                  BoxShadow(
                    color: backgroundColor.withValues(alpha: 0.28),
                    blurRadius: 18.0,
                    offset: const Offset(0, 8),
                    spreadRadius: -2.0,
                  ),
                  // Ambient grounding shadow
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: borderRadius,
                child: Material(
                  color: Colors.transparent, // Let gradient shine through
                  child: Padding(
                    padding: const EdgeInsets.all(ALERT_CONTENT_PADDING),
                    child: SimpleAlertInnerContent(
                      alertWidth: alertWidth,
                      loading: loading,
                      title: title,
                      description: description,
                      textDirection: textDirection,
                      centerContent: centerContent,
                      actions: actions,
                      withClose: withClose,
                      withProgressBar: withProgressBar,
                      onWidthAnimationControllerCreated:
                          onWidthAnimationControllerCreated,
                      resolvedDuration: resolvedDuration,
                      getForegroundColor: getForegroundColor,
                      getBackgroundColor: getBackgroundColor,
                      getIcon: getIcon,
                      onClosePressed: onClosePressed,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

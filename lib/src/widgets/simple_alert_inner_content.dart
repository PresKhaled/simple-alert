import 'package:flutter/material.dart';
import 'package:simple_alert/src/widgets/simple_alert_progress_bar.dart';
import '../../simple_alert.dart';
import 'simple_alert_leading_icon.dart';
import 'simple_alert_content_section.dart';

/// A widget that builds the internal content of the alert, including icon, text, and optional progress bar/actions.
class SimpleAlertInnerContent extends StatelessWidget {
  /// Creates a [SimpleAlertInnerContent] instance.
  const SimpleAlertInnerContent({
    super.key,
    required this.alertWidth,
    required this.loading,
    required this.title,
    this.description,
    required this.centerContent,
    this.actions,
    required this.withClose,
    required this.withProgressBar,
    required this.widthAnimationController,
    required this.resolvedDuration,
    required this.getForegroundColor,
    required this.getBackgroundColor,
    required this.getIcon,
    required this.onClosePressed,
  });

  /// The calculated width of the alert.
  final double alertWidth;

  /// If true, the alert will display a loading indicator instead of a type icon.
  final bool loading;

  /// The main title text displayed in the alert.
  final String title;

  /// An optional detailed description text for the alert.
  final String? description;

  /// If true, the alert's content (title and description) will be horizontally centered.
  final bool centerContent;

  /// An optional list of [IconButton] widgets to display as actions in the alert.
  final List<IconButton>? actions;

  /// If true, a close button will be displayed in the alert.
  final bool withClose;

  /// If true, a progress bar indicating the remaining duration will be displayed.
  final bool withProgressBar;

  /// The animation controller for the width animation (used by the progress bar).
  final ValueNotifier<AnimationController?> widthAnimationController;

  /// The resolved duration for the alert's display time.
  final Duration resolvedDuration;

  /// Callback function to get the resolved foreground color.
  final Color Function() getForegroundColor;

  /// Callback function to get the resolved background color.
  final Color Function() getBackgroundColor;

  /// Callback function to get the resolved icon widget.
  final Icon Function() getIcon;

  /// Callback function to be invoked when the close button is pressed.
  final VoidCallback onClosePressed;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final foregroundColor = getForegroundColor();

    return Theme(
      data: themeData.copyWith(
        iconTheme: themeData.iconTheme.copyWith(
          color: (SimpleAlertPreferences().iconsColor ?? foregroundColor), // Customize icon color.
        ),
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            foregroundColor: WidgetStatePropertyAll<Color>(
              (SimpleAlertPreferences().iconsColor ?? foregroundColor), // Customize icon button foreground color.
            ),
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Take minimum vertical space.
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Row(
              children: [
                SimpleAlertLeadingIcon(
                  loading: loading,
                  foregroundColor: foregroundColor,
                  getBackgroundColor: getBackgroundColor,
                  getIcon: getIcon,
                ), // Leading icon or loading indicator.
                Expanded(
                  child: SimpleAlertContentSection(
                    title: title,
                    description: description,
                    foregroundColor: foregroundColor,
                    centerContent: centerContent,
                    actions: actions,
                    withClose: withClose,
                    onClosePressed: onClosePressed,
                  ),
                ), // Main content and actions.
              ],
            ),
          ),
          if (withProgressBar) // Conditionally display progress bar.
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SimpleAlertProgressBar(
                  animationController: widthAnimationController,
                  alertWidth: alertWidth,
                  alertDuration: resolvedDuration,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

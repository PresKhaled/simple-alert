import 'package:flutter/material.dart';
import 'simple_alert_text_content.dart';
import 'simple_alert_actions_section.dart';

/// A widget that displays the main content section of the alert, including text and actions.
class SimpleAlertContentSection extends StatelessWidget {
  /// Creates a [SimpleAlertContentSection] instance.
  const SimpleAlertContentSection({
    super.key,
    required this.title,
    this.description,
    required this.foregroundColor,
    required this.centerContent,
    this.actions,
    required this.withClose,
    required this.onClosePressed,
  });

  /// The main title text of the alert.
  final String title;

  /// An optional detailed description text for the alert.
  final String? description;

  /// The color to apply to the text content.
  final Color foregroundColor;

  /// If true, the alert's content (title and description) will be horizontally centered.
  final bool centerContent;

  /// An optional list of [IconButton] widgets to display as actions in the alert.
  final List<IconButton>? actions;

  /// If true, a close button will be displayed in the alert.
  final bool withClose;

  /// Callback function to be invoked when the close button is pressed.
  final VoidCallback onClosePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space out text and actions.
      children: [
        // Title and description.
        Expanded(
          child: SimpleAlertTextContent(
            title: title,
            description: description,
            foregroundColor: foregroundColor,
            centerContent: centerContent,
          ),
        ),

        // Optional actions and close button.
        SimpleAlertActionsSection(
          actions: actions,
          withClose: withClose,
          onClosePressed: onClosePressed,
        ),
      ],
    );
  }
}

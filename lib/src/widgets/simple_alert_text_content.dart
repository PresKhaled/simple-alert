import 'package:flutter/material.dart';
import '../../simple_alert.dart';

/// A widget that displays the title and an optional description for a [SimpleAlert].
class SimpleAlertTextContent extends StatelessWidget {
  /// Creates a [SimpleAlertTextContent] instance.
  const SimpleAlertTextContent({
    super.key,
    required this.title,
    this.description,
    required this.foregroundColor,
    required this.centerContent,
  });

  /// The main title text to display.
  final String title;

  /// An optional detailed description text.
  final String? description;

  /// The color to apply to the title and description text.
  final Color foregroundColor;

  /// If true, the text content will be horizontally centered.
  final bool centerContent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // Take minimum vertical space.
      crossAxisAlignment: centerContent
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start, // Align text.
      children: [
        Text(
          title,
          style: SimpleAlertPreferences().titleStyle.copyWith(
                color: foregroundColor, // Apply foreground color to title.
              ),
        ),
        if (description != null) ...[
          const SizedBox(height: 5.0), // Spacing between title and description.
          Text(
            description!,
            style: SimpleAlertPreferences().descriptionStyle.copyWith(
                  color:
                      foregroundColor, // Apply foreground color to description.
                ),
          ),
        ],
      ],
    );
  }
}

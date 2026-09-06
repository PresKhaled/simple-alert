import 'package:flutter/material.dart';
import '../../simple_alert.dart';

/// A widget that displays the title and an optional description for a [SimpleAlert]
/// with intelligent BiDi support for mixed-script text and file paths.
class SimpleAlertTextContent extends StatelessWidget {
  /// Creates a [SimpleAlertTextContent] instance.
  const SimpleAlertTextContent({
    super.key,
    required this.title,
    this.description,
    this.textDirection,
    required this.foregroundColor,
    required this.centerContent,
  });

  /// The main title text to display.
  final String title;

  /// An optional detailed description text.
  final String? description;

  /// An optional explicit text direction override.
  final TextDirection? textDirection;

  /// The color to apply to the title and description text.
  final Color foregroundColor;

  /// If true, the text content will be horizontally centered.
  final bool centerContent;

  @override
  Widget build(BuildContext context) {
    try {
      final contextDirection = Directionality.maybeOf(context);
      final primaryDirection = SimpleAlertBidiUtil.resolveDirection(
        text: title,
        explicitDirection:
            textDirection ?? SimpleAlertPreferences().textDirection,
        fallbackDirection: contextDirection,
      );

      final formattedTitle = SimpleAlertBidiUtil.isolateBiDi(
        title,
        baseDirection: primaryDirection,
      );

      final descriptionDirection = description != null
          ? SimpleAlertBidiUtil.resolveDirection(
              text: description,
              explicitDirection:
                  textDirection ?? SimpleAlertPreferences().textDirection,
              fallbackDirection: primaryDirection,
            )
          : primaryDirection;

      final formattedDescription = description != null
          ? SimpleAlertBidiUtil.isolateBiDi(
              description!,
              baseDirection: descriptionDirection,
            )
          : null;

      final titleAlign =
          centerContent ? TextAlign.center : TextAlign.start;
      final descriptionAlign =
          centerContent ? TextAlign.center : TextAlign.start;

      return Directionality(
        textDirection: primaryDirection,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Take minimum vertical space.
          crossAxisAlignment: centerContent
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.stretch,
          children: [
            Text(
              formattedTitle,
              textAlign: titleAlign,
              textDirection: primaryDirection,
              style: SimpleAlertPreferences().titleStyle.copyWith(
                    color: foregroundColor,
                  ),
            ),
            if (formattedDescription != null) ...[
              const SizedBox(height: 5.0),
              Text(
                formattedDescription,
                textAlign: descriptionAlign,
                textDirection: descriptionDirection,
                style: SimpleAlertPreferences().descriptionStyle.copyWith(
                      color: foregroundColor.withValues(alpha: 0.90),
                    ),
              ),
            ],
          ],
        ),
      );
    } catch (e) {
      debugPrint('SimpleAlertTextContent safe error: $e');
      return const SizedBox.shrink();
    }
  }
}

/*
* This file is a part of "SimpleAlert" project.
* Khaled Mohsen <pres.kbayomy@gmail.com>
* Copyrights (BSD-3-Clause), LICENSE.
*/

import 'package:flutter/material.dart';
import '../simple_alert_preferences.dart';

/// A widget that displays the title and an optional description for a [SimpleAlert].
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
      final effectiveDirection = textDirection ??
          SimpleAlertPreferences().textDirection ??
          Directionality.maybeOf(context) ??
          TextDirection.ltr;

      final hasDescription =
          description != null && description!.trim().isNotEmpty;

      final titleAlign = centerContent ? TextAlign.center : TextAlign.start;
      final descriptionAlign =
          centerContent ? TextAlign.center : TextAlign.start;

      final prefTitleStyle = SimpleAlertPreferences().titleStyle;
      final effectiveTitleStyle = prefTitleStyle.copyWith(
        color: foregroundColor,
      );

      final prefDescStyle = SimpleAlertPreferences().descriptionStyle;
      final effectiveDescStyle = prefDescStyle.copyWith(
        color: foregroundColor.withValues(alpha: 0.90),
      );

      return Directionality(
        textDirection: effectiveDirection,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Take minimum vertical space.
          crossAxisAlignment: centerContent
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              semanticsLabel: title,
              textAlign: titleAlign,
              softWrap: true,
              style: effectiveTitleStyle,
            ),
            if (hasDescription) ...[
              const SizedBox(height: 5.0),
              Text(
                description!.trim(),
                semanticsLabel: description!.trim(),
                textAlign: descriptionAlign,
                softWrap: true,
                style: effectiveDescStyle,
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

import 'package:flutter/material.dart';
import '../../i18n/translations.g.dart';
import '../simple_alert.dart';

/// A widget that displays the leading icon or a loading indicator for a [SimpleAlert].
class SimpleAlertLeadingIcon extends StatelessWidget {
  /// Creates a [SimpleAlertLeadingIcon] instance.
  const SimpleAlertLeadingIcon({
    super.key,
    required this.loading,
    required this.foregroundColor,
    required this.getBackgroundColor,
    required this.getIcon,
  });

  /// If true, a loading indicator will be displayed. Otherwise, a type-specific icon.
  final bool loading;

  /// The color to apply to the icon or loading indicator.
  final Color foregroundColor;

  /// A callback function to get the background color of the alert.
  final Color Function() getBackgroundColor;

  /// A callback function to get the type-specific icon widget.
  final Icon Function() getIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 9.0),
      child: loading
          ? Semantics(
              label: t.loadingIndicatorSemanticLabel, // Semantic label for loading indicator.
              child: CircleAvatar(
                backgroundColor: Colors.white70,
                radius: 15.0,
                child: SizedBox.square(
                  dimension: 18.0,
                  child: CircularProgressIndicator(
                    color: getBackgroundColor(), // Loading indicator color.
                    strokeWidth: 2.0,
                  ),
                ),
              ),
            )
          : getIcon(), // Display type-specific icon.
    );
  }
}

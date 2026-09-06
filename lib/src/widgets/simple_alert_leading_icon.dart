import 'package:flutter/material.dart';
import '../../i18n/translations.g.dart';

/// A widget that displays the leading icon or a loading indicator for a [SimpleAlert].
class SimpleAlertLeadingIcon extends StatelessWidget {
  /// Creates a [SimpleAlertLeadingIcon] instance.
  const SimpleAlertLeadingIcon({
    super.key,
    required this.loading,
    required this.foregroundColor,
    required this.getBackgroundColor,
    required this.getIcon,
    required this.iconsSize,
  });

  /// If true, a loading indicator will be displayed. Otherwise, a type-specific icon.
  final bool loading;

  /// The color to apply to the icon or loading indicator.
  final Color foregroundColor;

  /// A callback function to get the background color of the alert.
  final Color Function() getBackgroundColor;

  /// A callback function to get the type-specific icon widget.
  final Icon Function() getIcon;

  /// The size of the icon from preferences.
  final double iconsSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 2.0, end: 12.0),
      child: Container(
        padding: const EdgeInsets.all(7.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: foregroundColor.withValues(alpha: 0.14),
          border: Border.all(
            color: foregroundColor.withValues(alpha: 0.18),
            width: 1.0,
          ),
        ),
        child: loading
            ? Semantics(
                label: t
                    .loadingIndicatorSemanticLabel, // Semantic label for loading indicator.
                child: SizedBox.square(
                  dimension: iconsSize - 4,
                  child: CircularProgressIndicator(
                    color: foregroundColor,
                    strokeWidth: 2.5,
                  ),
                ),
              )
            : getIcon(), // Display type-specific icon.
      ),
    );
  }
}

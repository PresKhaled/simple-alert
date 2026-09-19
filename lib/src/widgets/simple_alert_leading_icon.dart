/*
* This file is a part of "SimpleAlert" project.
* Khaled Mohsen <pres.kbayomy@gmail.com>
* Copyrights (BSD-3-Clause), LICENSE.
*/

import 'package:flutter/material.dart';

import '../misc/simple_alert_localizations.dart';

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
    try {
      final effectiveIconSize = iconsSize.clamp(16.0, 48.0);

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
                  label: t.loadingIndicatorSemanticLabel,
                  child: SizedBox.square(
                    dimension: (effectiveIconSize - 4.0).clamp(14.0, 44.0),
                    child: CircularProgressIndicator(
                      color: foregroundColor,
                      strokeWidth: 2.5,
                    ),
                  ),
                )
              : ExcludeSemantics(
                  excluding: true,
                  child: getIcon(),
                ),
        ),
      );
    } catch (e) {
      debugPrint('SimpleAlertLeadingIcon safe error: $e');
      return const SizedBox.shrink();
    }
  }
}

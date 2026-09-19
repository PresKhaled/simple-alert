import 'package:flutter/material.dart';
import '../../simple_alert.dart';
import '../misc/constants.dart';

/// A widget that displays action buttons and an optional close button for a [SimpleAlert].
class SimpleAlertActionsSection extends StatelessWidget {
  /// Creates a [SimpleAlertActionsSection] instance.
  const SimpleAlertActionsSection({
    super.key,
    this.actions,
    required this.withClose,
    required this.onClosePressed,
  });

  /// An optional list of [IconButton] widgets to display as actions.
  final List<IconButton>? actions;

  /// If true, a close button will be displayed.
  final bool withClose;

  /// Callback function to be invoked when the close button is pressed.
  final VoidCallback onClosePressed;

  @override
  Widget build(BuildContext context) {
    try {
      final hasActions = actions != null && actions!.isNotEmpty;

      // If no actions and no close button, return an empty box to save space.
      if (!hasActions && !withClose) {
        return const SizedBox.shrink();
      }

      final buttonCount =
          (hasActions ? actions!.length : 0) + (withClose ? 1 : 0);
      final maxAllowedWidth = (buttonCount * 44.0).clamp(44.0, 140.0);

      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxAllowedWidth),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Take minimum horizontal space.
            children: [
              if (hasActions) ...actions!, // Display specified action buttons.
              if (withClose) // Conditionally display a close button.
                IconButton(
                  onPressed: () {
                    try {
                      onClosePressed();
                    } catch (e) {
                      debugPrint('SimpleAlert close button safe error: $e');
                    }
                  },
                  icon: Icon(SimpleAlertPreferences()
                      .icons
                      .close), // Close icon from preferences.
                  splashRadius: ICON_BUTTON_SPLASH_RADIUS,
                  tooltip: SimpleAlertPreferences().closeTooltip,
                  constraints: const BoxConstraints(
                    minWidth: 40.0,
                    minHeight: 40.0,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
        ),
      );
    } catch (e) {
      debugPrint('SimpleAlertActionsSection safe error: $e');
      return const SizedBox.shrink();
    }
  }
}

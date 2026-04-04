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
    // If no actions and no close button, return an empty box to save space.
    if (actions == null && !withClose) {
      return const SizedBox.shrink();
    }

    return ConstrainedBox(
      constraints:
          const BoxConstraints(maxWidth: 92.0), // Limit width for actions.
      child: SingleChildScrollView(
        scrollDirection:
            Axis.horizontal, // Allow horizontal scrolling for multiple actions.
        child: Row(
          mainAxisSize: MainAxisSize.min, // Take minimum horizontal space.
          children: [
            if (actions != null)
              ...actions!, // Display specified action buttons.
            if (withClose) // Conditionally display a close button.
              IconButton(
                onPressed: onClosePressed, // Callback to close the alert.
                icon: Icon(SimpleAlertPreferences()
                    .icons
                    .close), // Close icon from preferences.
                splashRadius: ICON_BUTTON_SPLASH_RADIUS,
                tooltip: SimpleAlertPreferences().closeTooltip,
              ),
          ],
        ),
      ),
    );
  }
}

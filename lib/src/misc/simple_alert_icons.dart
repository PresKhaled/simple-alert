import 'package:flutter/material.dart' show IconData, Icons;

/// A class that defines the set of icons used for different types of [SimpleAlert]s.
///
/// This allows for easy customization of alert icons by providing alternative
/// [IconData] values during initialization of [SimpleAlertPreferences] or
/// directly in the [SimpleAlert] constructor.
///
/// Example usage with default icons:
/// ```dart
/// SimpleAlertIcons myIcons = const SimpleAlertIcons();
/// // Use myIcons.info, myIcons.success, etc.
/// ```
///
/// Example with custom icons:
/// ```dart
/// SimpleAlertPreferences(
///   icons: SimpleAlertIcons(
///     info: Icons.help_outline,
///     success: Icons.thumb_up,
///   ),
/// );
/// ```
class SimpleAlertIcons {
  /// The icon for a normal or default alert type.
  final IconData normal;

  /// The icon for a successful operation alert type.
  final IconData success;

  /// The icon for an informational alert type.
  final IconData info;

  /// The icon for a warning alert type.
  final IconData warning;

  /// The icon for a danger or error alert type.
  final IconData danger;

  /// The icon for the close button within an alert.
  final IconData close;

  /// Creates a [SimpleAlertIcons] instance with customizable icons.
  ///
  /// All parameters have default [MaterialIcons] values:
  /// - [normal] defaults to [Icons.message_outlined].
  /// - [info] defaults to [Icons.info_outline_rounded].
  /// - [success] defaults to [Icons.check_circle_outline].
  /// - [warning] defaults to [Icons.warning_amber_rounded].
  /// - [danger] defaults to [Icons.error_outline_rounded].
  /// - [close] defaults to [Icons.close_rounded].
  const SimpleAlertIcons({
    this.normal = Icons.message_outlined,
    this.info = Icons.info_outline_rounded,
    this.success = Icons.check_circle_outline,
    this.warning = Icons.warning_amber_rounded,
    this.danger = Icons.error_outline_rounded,
    this.close = Icons.close_rounded,
  });
}

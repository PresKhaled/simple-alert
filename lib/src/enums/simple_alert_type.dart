/// Defines the predefined types of alerts available in [SimpleAlert].
///
/// Each type is associated with a specific semantic meaning (e.g., success, warning)
/// and often corresponds to a default color and icon defined in [SimpleAlertPreferences].
/// This useful for quickly conveying the nature of the alert to the user.
enum SimpleAlertType {
  /// A general-purpose alert with no specific semantic meaning.
  normal,

  /// Indicates that an operation was successful or completed without issues.
  success,

  /// Provides general information or a neutral update to the user.
  info,

  /// Warns the user about a potential issue, a non-critical error, or something requiring attention.
  warning,

  /// Indicates a critical error, a failed operation, or something requiring immediate attention.
  danger,
}

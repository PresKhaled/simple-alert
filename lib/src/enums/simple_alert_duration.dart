/// Defines predefined durations for which a [SimpleAlert] remains visible.
///
/// These durations offer common timeframes for alerts, from quick notifications
/// to alerts that stay on screen for a full day.
enum SimpleAlertDuration {
  /// A quick duration, typically a few seconds.
  quick,

  /// A medium duration, longer than [quick] but shorter than [long].
  medium,

  /// A long duration, suitable for more persistent notifications.
  long,

  /// An exceptionally long duration, causing the alert to remain visible for a full day.
  /// Use with caution for non-critical alerts.
  day,
}

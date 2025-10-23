/// Defines the predefined corner shapes for [SimpleAlert] widgets.
///
/// These shapes determine the [BorderRadius] applied to the alert container,
/// allowing for visual customization of how alerts are presented.
enum SimpleAlertShape {
  /// The alert will have sharp, non-rounded corners (a [BorderRadius.zero]).
  sharp,

  /// The alert will have a default, moderately rounded corner radius, typically [BORDER_RADIUS].
  defaultRadius,

  /// The alert will have highly rounded corners, appearing pill-shaped if the dimensions allow.
  rounded,
}

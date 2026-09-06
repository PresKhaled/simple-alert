import 'package:flutter/material.dart';

/// Data model for alert information, including its size and alignment properties.
class AlertData {
  /// The current size of the alert.
  Size size;

  /// The alignment of the alert on screen.
  final AlignmentDirectional alignment;

  /// Indicates if the alert is aligned from the top.
  final bool fromTop;

  /// Indicates if the alert is aligned from the center.
  final bool fromCenter;

  /// Indicates if the alert is aligned from the bottom.
  final bool fromBottom;

  /// Creates an instance of [AlertData].
  AlertData({
    required this.size,
    this.alignment = AlignmentDirectional.topCenter,
    required this.fromTop,
    required this.fromCenter,
    required this.fromBottom,
  });
}

/// Manages the state and lifecycle of all displayed alerts.
/// This class separates backend from UI concerns.
class AlertManager {
  /// Singleton instance of [AlertManager].
  static final AlertManager _instance = AlertManager._internal();

  /// Factory constructor to return the singleton instance.
  factory AlertManager() => _instance;

  /// Private constructor for the singleton pattern.
  AlertManager._internal();

  /// A [ValueNotifier] that holds a map of currently displayed alerts,
  /// keyed by their route names.
  final ValueNotifier<Map<String, AlertData>> _displayedAlerts =
      ValueNotifier<Map<String, AlertData>>({});

  /// Provides access to the [ValueNotifier] containing the currently displayed alerts.
  ValueNotifier<Map<String, AlertData>> get displayedAlerts => _displayedAlerts;

  /// Registers a new alert with a specified route name and its associated data.
  ///
  /// [routeName] The unique name of the route associated with the alert.
  /// [data] The [AlertData] containing information about the alert.
  void registerAlert(String routeName, AlertData data) {
    _displayedAlerts.value = {
      ..._displayedAlerts.value,
      routeName: data,
    };
  }

  /// Unregisters (deletes) an alert using its route name.
  ///
  /// [routeName] The unique name of the route associated with the alert to unregister.
  void unregisterAlert(String routeName) {
    if (_displayedAlerts.value.containsKey(routeName)) {
      final newMap = Map<String, AlertData>.from(_displayedAlerts.value);
      newMap.remove(routeName);
      _displayedAlerts.value = newMap;
    }
  }

  /// Updates the size of an already registered alert.
  ///
  /// [routeName] The unique name of the route associated with the alert.
  /// [size] The new [Size] of the alert.
  void updateAlertSize(String routeName, Size size) {
    if (_displayedAlerts.value.containsKey(routeName)) {
      final data = _displayedAlerts.value[routeName]!;
      data.size = size;
      _displayedAlerts.value = Map<String, AlertData>.from(_displayedAlerts.value);
    }
  }

  /// Retrieves a list of alerts that share the same alignment direction
  /// as the current alert and are displayed before it.
  ///
  /// This is used to calculate the vertical offset for new alerts to prevent overlaps.
  ///
  /// [currentRouteName] The route name of the current alert.
  /// [alignment] The [AlignmentDirectional] of the current alert.
  /// Returns a list of [AlertData] for alerts in the same direction.
  List<AlertData> getAlertsInSameDirection(
    String currentRouteName,
    AlignmentDirectional alignment,
  ) {
    final alerts = _displayedAlerts.value;
    final keys = alerts.keys.toList();
    final currentIndex = keys.indexOf(currentRouteName);

    if (currentIndex == -1) return [];

    // Determine the vertical alignment direction of the current alert.
    final bool fromTop = isTopAligned(alignment);
    final bool fromCenter = isCenterAligned(alignment);
    final bool fromBottom = isBottomAligned(alignment);

    // Filter alerts that are displayed before the current one, share the same
    // vertical direction and horizontal alignment slot.
    return keys
        .take(currentIndex)
        .map((key) => alerts[key]!)
        .where(
          (data) =>
              (data.fromTop == fromTop &&
                  data.fromCenter == fromCenter &&
                  data.fromBottom == fromBottom) &&
              (data.alignment.start == alignment.start),
        )
        .toList();
  }

  /// Checks if the specified alignment is top-aligned.
  static bool isTopAligned(AlignmentDirectional alignment) {
    return [
      AlignmentDirectional.topStart,
      AlignmentDirectional.topCenter,
      AlignmentDirectional.topEnd,
    ].contains(alignment);
  }

  /// Checks if the specified alignment is center-aligned.
  static bool isCenterAligned(AlignmentDirectional alignment) {
    return [
      AlignmentDirectional.centerStart,
      AlignmentDirectional.center,
      AlignmentDirectional.centerEnd,
    ].contains(alignment);
  }

  /// Checks if the specified alignment is bottom-aligned.
  static bool isBottomAligned(AlignmentDirectional alignment) {
    return [
      AlignmentDirectional.bottomStart,
      AlignmentDirectional.bottomCenter,
      AlignmentDirectional.bottomEnd,
    ].contains(alignment);
  }

  /// Disposes of the [_displayedAlerts] [ValueNotifier] to prevent memory leaks.
  void dispose() {
    _displayedAlerts.dispose();
  }
}

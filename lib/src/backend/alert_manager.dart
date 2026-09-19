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

/// Represents an active alert entry managed and rendered by [SimpleAlertHost].
class AlertEntry {
  /// Unique identifier for this alert instance.
  final String id;

  /// The widget representing the alert to render.
  final Widget widget;

  /// Callback to dismiss this alert.
  final Future<void> Function({bool immediate}) dismiss;

  /// Creates an [AlertEntry] instance.
  AlertEntry({
    required this.id,
    required this.widget,
    required this.dismiss,
  });
}

/// Manages the state and lifecycle of all displayed alerts.
/// This class separates backend from UI concerns and provides a single source
/// of truth for active alert entries and spatial stacking data.
class AlertManager {
  /// Singleton instance of [AlertManager].
  static final AlertManager _instance = AlertManager._internal();

  /// Factory constructor to return the singleton instance.
  factory AlertManager() => _instance;

  /// Private constructor for the singleton pattern.
  AlertManager._internal();

  /// Tracks whether a [SimpleAlertHost] is currently active in the widget tree.
  final ValueNotifier<bool> _isHostAttached = ValueNotifier<bool>(false);

  /// Whether a [SimpleAlertHost] is currently active.
  bool get hasHost => _isHostAttached.value;

  /// Attaches a [SimpleAlertHost] to the manager.
  void attachHost() {
    _isHostAttached.value = true;
  }

  /// Detaches the [SimpleAlertHost] from the manager.
  void detachHost() {
    _isHostAttached.value = false;
  }

  /// A [ValueNotifier] holding all active [AlertEntry] items rendered by [SimpleAlertHost].
  final ValueNotifier<Map<String, AlertEntry>> _activeEntries =
      ValueNotifier<Map<String, AlertEntry>>({});

  /// Provides access to the active alert entries.
  ValueNotifier<Map<String, AlertEntry>> get activeEntries => _activeEntries;

  /// A [ValueNotifier] that holds a map of currently displayed alert geometry data,
  /// keyed by their route/alert names.
  final ValueNotifier<Map<String, AlertData>> _displayedAlerts =
      ValueNotifier<Map<String, AlertData>>({});

  /// Provides access to the [ValueNotifier] containing the currently displayed alert geometry.
  ValueNotifier<Map<String, AlertData>> get displayedAlerts => _displayedAlerts;

  /// Registers a host alert entry.
  void registerHostAlert(AlertEntry entry) {
    try {
      _activeEntries.value = {
        ..._activeEntries.value,
        entry.id: entry,
      };
    } catch (e) {
      debugPrint('AlertManager registerHostAlert safe error: $e');
    }
  }

  /// Unregisters a host alert entry.
  void unregisterHostAlert(String id) {
    try {
      if (_activeEntries.value.containsKey(id)) {
        final newMap = Map<String, AlertEntry>.from(_activeEntries.value);
        newMap.remove(id);
        _activeEntries.value = newMap;
      }
    } catch (e) {
      debugPrint('AlertManager unregisterHostAlert safe error: $e');
    }
  }

  /// Registers alert geometry data with a specified alert name.
  void registerAlert(String routeName, AlertData data) {
    try {
      _displayedAlerts.value = {
        ..._displayedAlerts.value,
        routeName: data,
      };
    } catch (e) {
      debugPrint('AlertManager registerAlert safe error: $e');
    }
  }

  /// Unregisters (deletes) alert geometry data using its alert name.
  void unregisterAlert(String routeName) {
    try {
      if (_displayedAlerts.value.containsKey(routeName)) {
        final newMap = Map<String, AlertData>.from(_displayedAlerts.value);
        newMap.remove(routeName);
        _displayedAlerts.value = newMap;
      }
    } catch (e) {
      debugPrint('AlertManager unregisterAlert safe error: $e');
    }
  }

  /// Updates the size of an already registered alert.
  void updateAlertSize(String routeName, Size size) {
    try {
      if (_displayedAlerts.value.containsKey(routeName)) {
        final data = _displayedAlerts.value[routeName];
        if (data != null) {
          data.size = size;
          _displayedAlerts.value =
              Map<String, AlertData>.from(_displayedAlerts.value);
        }
      }
    } catch (e) {
      debugPrint('AlertManager updateAlertSize safe error: $e');
    }
  }

  /// Retrieves a list of alerts that share the same alignment direction
  /// as the current alert and are displayed before it.
  List<AlertData> getAlertsInSameDirection(
    String currentRouteName,
    AlignmentDirectional alignment,
  ) {
    try {
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
          .map((key) => alerts[key])
          .whereType<AlertData>()
          .where(
            (data) =>
                (data.fromTop == fromTop &&
                    data.fromCenter == fromCenter &&
                    data.fromBottom == fromBottom) &&
                (data.alignment.start == alignment.start),
          )
          .toList();
    } catch (e) {
      debugPrint('AlertManager getAlertsInSameDirection safe error: $e');
      return [];
    }
  }

  /// Dismisses all currently active alerts.
  Future<void> dismissAll({bool immediate = false}) async {
    try {
      final entries = _activeEntries.value.values.toList();
      for (final entry in entries) {
        try {
          entry.dismiss(immediate: immediate);
        } catch (_) {}
      }
    } catch (e) {
      debugPrint('AlertManager dismissAll safe error: $e');
    }
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

  /// Disposes of all value notifiers to prevent memory leaks.
  void dispose() {
    _displayedAlerts.dispose();
    _activeEntries.dispose();
    _isHostAttached.dispose();
  }
}

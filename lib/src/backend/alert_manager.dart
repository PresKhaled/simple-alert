/*
* This file is a part of "SimpleAlert" project.
* Khaled Mohsen <pres.kbayomy@gmail.com>
* Copyrights (BSD-3-Clause), LICENSE.
*/

import 'package:flutter/material.dart';

import '../misc/constants.dart';

/// Data model for alert layout geometry and alignment.
class AlertData {
  /// The measured size of the alert.
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

/// Manages the state, registration, and spatial stacking of all active alerts.
class AlertManager {
  static final AlertManager _instance = AlertManager._internal();

  /// Factory constructor to return the singleton instance.
  factory AlertManager() => _instance;

  AlertManager._internal();

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

  final ValueNotifier<Map<String, AlertEntry>> _activeEntries =
      ValueNotifier<Map<String, AlertEntry>>({});

  /// Provides access to the active alert entries.
  ValueNotifier<Map<String, AlertEntry>> get activeEntries => _activeEntries;

  final ValueNotifier<Map<String, AlertData>> _displayedAlerts =
      ValueNotifier<Map<String, AlertData>>({});

  /// Provides access to the geometry data of currently displayed alerts.
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

  /// Unregisters alert geometry data using its alert name.
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
  /// as the current alert and were registered before it.
  List<AlertData> getAlertsInSameDirection(
    String currentRouteName,
    AlignmentDirectional alignment,
  ) {
    try {
      final alerts = _displayedAlerts.value;
      final keys = alerts.keys.toList();
      final currentIndex = keys.indexOf(currentRouteName);

      if (currentIndex == -1) return [];

      final bool fromTop = isTopAligned(alignment);
      final bool fromCenter = isCenterAligned(alignment);
      final bool fromBottom = isBottomAligned(alignment);

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

  /// Calculates the vertical stacking offset for an alert.
  double calculateVerticalOffset({
    required String routeName,
    required AlignmentDirectional alignment,
    required Orientation orientation,
    required double screenHeight,
  }) {
    final previousAlerts = getAlertsInSameDirection(routeName, alignment);

    final baseOffset = isCenterAligned(alignment)
        ? (screenHeight / 2) -
            (orientation == Orientation.portrait
                ? AVERAGE_PORTRAIT_HEIGHT
                : AVERAGE_LANDSCAPE_HEIGHT)
        : 0.0;

    return previousAlerts.fold<double>(
      baseOffset,
      (offset, data) => offset + data.size.height + ALERT_VERTICAL_SPACING,
    );
  }

  /// Dismisses all currently active alerts across the application.
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

  /// Clears active alerts without destroying internal listeners.
  void clear() {
    _displayedAlerts.value = {};
    _activeEntries.value = {};
  }

  /// Safe disposal method for testing teardown that preserves reusability.
  void dispose() {
    clear();
  }
}

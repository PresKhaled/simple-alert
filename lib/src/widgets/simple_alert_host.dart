/*
* This file is a part of "SimpleAlert" project.
* Khaled Mohsen <pres.kbayomy@gmail.com>
* Copyrights (BSD-3-Clause), LICENSE.
*/

import 'package:flutter/material.dart';

import '../backend/alert_manager.dart';

/// A root host widget that enables [SimpleAlert] to display persistent alerts
/// above the entire application, including all Navigator routes, modal dialogs,
/// and bottom sheets.
///
/// Place this widget in your `MaterialApp.builder` or `WidgetsApp.builder`:
/// ```dart
/// MaterialApp(
///   builder: (context, child) => SimpleAlertHost(child: child!),
///   home: const MyHomePage(),
/// );
/// ```
class SimpleAlertHost extends StatefulWidget {
  /// The child widget, typically the [Navigator] provided by `MaterialApp.builder`.
  final Widget child;

  /// Creates a [SimpleAlertHost] instance.
  const SimpleAlertHost({
    super.key,
    required this.child,
  });

  @override
  State<SimpleAlertHost> createState() => _SimpleAlertHostState();
}

class _SimpleAlertHostState extends State<SimpleAlertHost> {
  final AlertManager _alertManager = AlertManager();

  @override
  void initState() {
    super.initState();
    _alertManager.attachHost();
  }

  @override
  void dispose() {
    _alertManager.detachHost();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        // The underlying application (Navigator, routes, modal dialogs, etc.)
        widget.child,

        // The floating alert layer, encapsulated within an Overlay so tooltips,
        // popups, and raw tooltips have an ancestor Overlay and render without errors.
        Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) =>
                  ValueListenableBuilder<Map<String, AlertEntry>>(
                valueListenable: _alertManager.activeEntries,
                builder: (context, entries, _) {
                  if (entries.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      for (final entry in entries.values) entry.widget,
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

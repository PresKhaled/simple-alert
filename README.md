# Simple Alert

[![Pub Version](https://img.shields.io/pub/v/simple_alert?color=blue&style=flat-square)](https://pub.dev/packages/simple_alert)
[![Dart SDK Version](https://img.shields.io/badge/dart-%3E%3D3.3.0-0175C2.svg?style=flat-square&logo=dart)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/flutter-%3E%3D3.19.0-02569B.svg?style=flat-square&logo=flutter)](https://flutter.dev)
[![License: BSD-3-Clause](https://img.shields.io/badge/License-BSD--3--Clause-blue.svg?style=flat-square)](https://opensource.org/licenses/BSD-3-Clause)
[![Tests](https://img.shields.io/badge/tests-46%20passed-success?style=flat-square)](https://github.com/PresKhaled/simple-alert)

A lightweight, robust, and accessible Flutter package for displaying responsive, beautifully styled, and dynamically stacked in-app alerts.

Engineered with a root overlay architecture, `SimpleAlert` renders notifications seamlessly above all routes, dialogs, and bottom sheets without blocking underlying user interaction. It features automatic spatial collision avoidance, interactive countdown progress bars, velocity-based swipe-to-dismiss gestures, bidirectional (BiDi) script handling, and zero external runtime dependencies.

---

## Features

- **Global Overlay Architecture**: Display alerts on top of every `Navigator` route, modal dialog, and bottom sheet without context routing dependencies.
- **Dynamic Vertical Stacking**: Automatically calculates spatial offsets to stack multiple concurrent notifications smoothly without visual overlapping.
- **Interactive Countdown Progress Bar**: Visual progress indicator that pauses on tap-and-hold and resumes on release.
- **Fluid Swipe-to-Dismiss Physics**: Natural horizontal drag interactions with velocity threshold detection, fling transitions, and spring-back recovery.
- **Smart BiDi & Technical Token Isolation**: Built-in `SimpleAlertBidiUtil` with Unicode isolation markers (`U+2066` / `U+2069`) preventing URLs, file paths, and LTR identifiers from flipping in RTL languages (Arabic, Urdu, etc.).
- **Zero External Dependencies**: Built exclusively on Flutter SDK primitives for maximum stability and minimal footprint.
- **Built-in Multi-language Support**: Zero-dependency localization for English, Arabic, Urdu, Turkish, Indonesian, and Portuguese.
- **WCAG-Compliant Accessibility**: Full screen-reader support via `SemanticsService.announce`, live regions, and automatic reduced-motion adaptation (`disableAnimations`).
- **Tactile Haptic Feedback**: Context-aware haptic patterns corresponding to alert severity (`heavyImpact`, `mediumImpact`, `lightImpact`).
- **Asynchronous Signal Dismissal**: Dismiss alerts remotely via `ValueNotifier<bool>` triggers (`removalSignal`).
- **Global & Local Preferences**: Configure app-wide aesthetics once using `SimpleAlertPreferences`, with per-alert overrides when needed.

---

## Installation

Add `simple_alert` to your `pubspec.yaml` dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  simple_alert: ^1.0.0
```

Or run:

```bash
flutter pub add simple_alert
```

Then import the library:

```dart
import 'package:simple_alert/simple_alert.dart';
```

---

## Initial Setup

To enable alerts to float above your entire application (including modal dialogs and bottom sheets), wrap your `MaterialApp.builder` or `WidgetsApp.builder` with `SimpleAlertHost`:

```dart
import 'package:flutter/material.dart';
import 'package:simple_alert/simple_alert.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      // Register the alert host layer
      builder: (context, child) => SimpleAlertHost(child: child!),
      home: const HomeScreen(),
    );
  }
}
```

> **Note**: `SimpleAlertHost` encapsulates an internal `Overlay`, ensuring tooltips, actions, and animations render reliably without conflicting with the root navigator.

---

## Usage Examples

### 1. Basic Semantic Alerts

Trigger alerts with semantic presets (`normal`, `info`, `success`, `warning`, `danger`):

```dart
// Success alert
SimpleAlert(
  context: context,
  title: 'Saved Successfully',
  description: 'Your document changes have been synchronized.',
  type: SimpleAlertType.success,
  duration: SimpleAlertDuration.quick,
);

// Danger / Error alert
SimpleAlert(
  context: context,
  title: 'Connection Lost',
  description: 'Unable to reach the backend server. Retrying...',
  type: SimpleAlertType.danger,
  withClose: true,
);
```

---

### 2. Interactive Countdown Progress Bar

Display a countdown timer that users can hold to pause and inspect:

```dart
SimpleAlert(
  context: context,
  title: 'Upload Queued',
  description: 'Press and hold to pause auto-dismissal.',
  type: SimpleAlertType.info,
  duration: SimpleAlertDuration.medium,
  withProgressBar: true,
  closeOnPress: false,
  withClose: true,
);
```

---

### 3. Custom Actions and Dismissal Controls

Provide contextual action buttons alongside the alert content:

```dart
SimpleAlert(
  context: context,
  title: 'New Update Available',
  description: 'Version 2.4.0 is ready for installation.',
  type: SimpleAlertType.normal,
  duration: SimpleAlertDuration.long,
  withClose: true,
  actions: [
    IconButton(
      icon: const Icon(Icons.download_rounded),
      tooltip: 'Download',
      onPressed: () {
        // Perform action
      },
    ),
  ],
);
```

---

### 4. Loading State with Async Dismissal Signal

Display persistent loading indicators during long operations and dismiss them when the task finishes:

```dart
final stopSignal = ValueNotifier<bool>(false);

// Show the loading notification
SimpleAlert.loading(
  context: context,
  title: 'Generating Report...',
  removalSignal: stopSignal,
);

// Trigger dismissal when background work concludes
await generateFinancialReport();
stopSignal.value = true;
```

---

### 5. Smart BiDi & File Path Isolation

Prevent punctuation inversion and reversed path segments in RTL interfaces:

```dart
SimpleAlert(
  context: context,
  type: SimpleAlertType.success,
  title: 'تم حفظ الملف بنجاح',
  // Slashes and extensions remain cleanly ordered: /storage/emulated/0/Books/Clean_Architecture.epub
  description: 'تم التخزين في: /storage/emulated/0/Books/Clean_Architecture.epub',
  duration: SimpleAlertDuration.long,
  withClose: true,
);
```

---

### 6. Multiple Concurrent Stacked Alerts

Multiple alerts fired simultaneously automatically calculate their layout bounds and stack cleanly without clipping:

```dart
for (int i = 1; i <= 3; i++) {
  SimpleAlert(
    context: context,
    title: 'Notification #$i',
    description: 'Alerts automatically stack and rearrange upon dismissal.',
    alignmentDirectional: AlignmentDirectional.topCenter,
    duration: SimpleAlertDuration.long,
    withClose: true,
    withProgressBar: true,
  );
}
```

---

### 7. Global Configuration (`SimpleAlertPreferences`)

Configure global aesthetics during app initialization. Properties are safely preserved across subsequent calls:

```dart
SimpleAlertPreferences(
  context: context,
  alignmentDirectional: AlignmentDirectional.topCenter,
  shape: SimpleAlertShape.rounded,
  duration: SimpleAlertDuration.medium,
  enableHapticFeedback: true,
  titleStyle: const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w700,
  ),
  descriptionStyle: const TextStyle(
    fontSize: 14.0,
    height: 1.3,
  ),
).setLocale('en'); // Supports 'en', 'ar', 'ur', 'tr', 'id', 'pt'
```

---

### 8. Batch and Programmatic Dismissal

Dismiss alerts programmatically:

```dart
// Dismiss a specific instance
final alert = SimpleAlert(context: context, title: 'Notice');
await alert.dismiss();

// Dismiss all active alerts across the application immediately
await SimpleAlert.dismissAll(immediate: true);
```

---

## API Reference

### `SimpleAlert` Constructor

| Parameter | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `context` | `BuildContext` | *required* | Build context associated with the caller. |
| `title` | `String` | *required* | Primary alert headline text. |
| `description` | `String?` | `null` | Optional descriptive message. |
| `alignmentDirectional` | `AlignmentDirectional?` | Global preference (`topCenter`) | On-screen placement alignment. |
| `width` | `double?` | Screen-calculated optimal | Explicit alert width. |
| `type` | `SimpleAlertType?` | Global preference (`info`) | Semantic preset (`normal`, `info`, `success`, `warning`, `danger`). |
| `duration` | `SimpleAlertDuration?` | Global preference (`medium`) | Predefined display duration. |
| `customDuration` | `Duration?` | `null` | Custom duration override. |
| `shape` | `SimpleAlertShape?` | Global preference (`defaultRadius`) | Corner radius preset (`sharp`, `defaultRadius`, `rounded`). |
| `borderRadius` | `BorderRadius?` | `null` | Explicit border radius override. |
| `backgroundColor` | `Color?` | Type-dependent contrast | Alert background color override. |
| `foregroundColor` | `Color?` | Contrast-adapted | Alert content/icon color override. |
| `withProgressBar` | `bool` | `false` | Displays interactive countdown progress bar. |
| `closeOnPress` | `bool` | `true` | Dismisses when the card body is tapped. |
| `withClose` | `bool` | `false` | Renders a standard close icon button. |
| `actions` | `List<IconButton>?` | `null` | Trailing action buttons. |
| `removalSignal` | `ValueNotifier<bool>?`| `null` | External signal that triggers dismissal on `true`. |
| `enableHapticFeedback`| `bool?` | Global preference (`true`) | Emits tactile vibration on display. |
| `loading` | `bool` | `false` | Replaces leading icon with `CircularProgressIndicator`. |
| `centerContent` | `bool` | `false` | Horizontally centers title and description. |
| `textDirection` | `TextDirection?` | BiDi detected / context | Explicit text direction override. |
| `animatedOpacityDuration` | `Duration` | `280ms` | Transition entrance/exit duration. |
| `routeName` | `String?` | Generated unique ID | Identifier for tracking in `AlertManager`. |

---

### Enumerations

#### `SimpleAlertType`
- `normal`: Neutral, dark/light grey palette for general messages.
- `info`: Blue palette indicating updates or status changes.
- `success`: Green palette for successful transactions or completions.
- `warning`: Amber palette for non-fatal warnings requiring user awareness.
- `danger`: Red palette for errors, failures, and critical alerts.

#### `SimpleAlertDuration`
- `quick`: Approximately 3 seconds.
- `medium`: Approximately 5 seconds.
- `long`: Approximately 8 seconds.
- `day`: Approximately 24 hours (persistent display).

#### `SimpleAlertShape`
- `sharp`: Sharp rectangle (`BorderRadius.zero`).
- `defaultRadius`: Moderately rounded corners (`14.0px`).
- `rounded`: Pill-style fully rounded corners (`255.0px`).

---

## Accessibility (a11y) & WCAG Compliance

`SimpleAlert` is built to comply with international accessibility standards:
- **Screen Reader Announcements**: Uses `SemanticsService.announce` to read the title and description upon presentation, and an announcement when dismissed.
- **Reduced Motion Support**: Automatically queries `MediaQuery.maybeDisableAnimationsOf(context)`. When animations are disabled, transitions complete instantaneously to prevent vestibular distress.
- **High-Contrast Typography**: Uses `AlertColorUtils` to verify color combinations against WCAG AA and AAA guidelines.
- **Safe Focus Traversal**: Employs non-intrusive focus containers so alerts do not disrupt keyboard or screen-reader navigation on active forms.

---

## License

This project is licensed under the BSD-3-Clause License. See the [LICENSE](LICENSE) file for details.

Copyright (c) 2026 Khaled Mohsen.

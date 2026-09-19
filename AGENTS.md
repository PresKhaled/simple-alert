# AGENTS.md

## Repository Overview & Mission

`simple_alert` is a self-contained, enterprise-ready Flutter package providing responsive, dynamically stacked, and accessible in-app alerts. It operates above all navigation routes, modal dialogs, and bottom sheets using a dedicated root overlay architecture.

This document establishes operational constraints, architectural standards, and coding conventions for autonomous agents and AI-assisted contributors working within this repository.

---

## Architectural Blueprint

The codebase is organized into clean functional layers under `lib/`:

```
lib/
├── simple_alert.dart                    # Public API barrel export
└── src/
    ├── simple_alert.dart                # Public facade & lifecycle orchestrator
    ├── simple_alert_preferences.dart    # App-wide configuration singleton
    ├── backend/
    │   ├── alert_manager.dart           # Global registry, layout geometry & stacking
    │   └── alert_timer_controller.dart  # 100ms periodic countdown timer & state
    ├── enums/
    │   ├── simple_alert_duration.dart   # Predefined display durations
    │   ├── simple_alert_shape.dart      # Container border-radius shapes
    │   └── simple_alert_type.dart       # Semantic alert variants
    ├── misc/
    │   ├── constants.dart               # Dimensions, durations, validation & WCAG
    │   ├── simple_alert_icons.dart      # Material icon definitions per alert type
    │   └── simple_alert_localizations.dart # Zero-dependency i18n (en, ar, ur, tr, id, pt)
    └── widgets/
        ├── simple_alert_actions_section.dart # Trailing action & close buttons
        ├── simple_alert_card.dart       # Core animated card & physics handler
        ├── simple_alert_host.dart       # Root stack/overlay host widget
        ├── simple_alert_leading_icon.dart # Leading type icon or loading spinner
        └── simple_alert_text_content.dart # Title & description content layout
```

### Component Roles & Data Flow

1. **Facade Layer (`SimpleAlert`)**:
   - Entry point instantiated by the consumer.
   - Immediately validates arguments, registers with `AlertManager`, triggers haptic feedback via `HapticFeedback`, and mounts the entry in `SimpleAlertHost`.
   - Supports remote programmatic dismissal via `removalSignal` (`ValueNotifier<bool>`).

2. **Host Layer (`SimpleAlertHost`)**:
   - Injected in `MaterialApp.builder` or `WidgetsApp.builder`.
   - Renders a top-level `Stack` where the bottom child is `widget.child` (the application) and the upper child is an independent `Overlay` containing `ValueListenableBuilder<Map<String, AlertEntry>>`.
   - Wrapping the alert layer in an `Overlay` is mandatory so that internal widgets (such as `Tooltip`) have an ancestor `Overlay` accessible at all times.

3. **Backend Registry & Geometry Stacking (`AlertManager`)**:
   - Singleton storing active `AlertEntry` widgets and measured `AlertData` geometries.
   - Calculates dynamic vertical stacking offsets (`calculateVerticalOffset`) based on alignment direction (`top`, `center`, `bottom`), orientation, and previous alert heights.
   - Emits batch dismissal operations via `dismissAll()`.

4. **Card Rendering & Gesture Physics (`SimpleAlertCard`)**:
   - Employs `TickerProviderStateMixin` with multiple concurrent controllers:
     - `_transitionController`: Combined entrance/exit (Fade + Slide + Scale) governed by `DEFAULT_ALERT_CURVE` (`Curves.easeOutCubic`).
     - `_dragAnimController`: Swipe-to-dismiss drag physics with velocity and displacement threshold evaluation.
     - `_progressController`: Drives visual countdown bar when `withProgressBar` is enabled.
   - Listens to tap events to pause countdown on tap-down and resume on tap-up.
   - Automatically reports measured box dimensions to `AlertManager` post-frame.

5. **Native Bidirectional (BiDi) & Text Direction Handling**:
   - Leverages Flutter's native text engine (HarfBuzz / UAX #9) to cleanly lay out mixed-script content (e.g., Arabic & Latin) without intrusive string mutations.
   - Accurately respects ambient `Directionality`, per-alert `textDirection`, or global `SimpleAlertPreferences().textDirection`.

---

## Critical Invariants & Rules

When modifying or expanding this codebase, agents MUST adhere to the following invariants:

### 1. Zero External Runtime Dependencies
The package must strictly rely on the Flutter SDK (`flutter: sdk: flutter`). **DO NOT** add third-party dependencies to `dependencies` in `pubspec.yaml`. All animations, physics, localizations, icons, and layout handling must be implemented using pure Flutter primitives.

### 2. Fail-Safe / Non-Crashing Guarantee
Alerts are supplementary UI elements and must **NEVER** crash the host application under any circumstances:
- Guard all post-frame measurement callbacks, lifecycle transitions, and haptic feedback invocations with appropriate defensive checks and try-catch blocks where external system states may fail.
- Gracefully sanitize invalid inputs (e.g., negative widths or non-positive durations) to reasonable defaults rather than throwing unhandled exceptions in production code.

### 3. Non-Destructive Singleton Factory
`SimpleAlertPreferences` maintains global configurations across the app lifecycle. The factory constructor must preserve previously set values:
- Omitting a parameter when calling `SimpleAlertPreferences(...)` must **NOT** reset existing properties to null or defaults. Only explicitly provided non-null values should override the state.
- When `context` is provided, text styles derived from `ThemeData` must leave their `color` property null to prevent light/dark theme text colors from overriding dynamic high-contrast foreground colors on colored alert cards.

### 4. Accessibility & Reduced Motion
- Always verify reduced-motion preferences via `MediaQuery.maybeDisableAnimationsOf(context)` or `MediaQuery.maybeOf(context)?.disableAnimations`.
- When reduced motion is requested, animation durations must collapse to `Duration.zero` or skip interpolation to prevent motion discomfort.
- Preserve accessibility announcements (`SemanticsService.announce`), screen reader labels, and live region semantics for all visual transitions.

### 5. Proper Controller & Resource Disposal
- Every allocated `AnimationController`, `Timer`, or `ValueNotifier` owned by a widget or service must be cancelled and disposed of in `dispose()` to prevent memory leaks and zombie execution frames.

---

## Development & Verification Protocols

Before submitting any code changes, execute the following verification steps:

### 1. Static Analysis
Run static analysis to ensure zero lints or warnings:
```bash
flutter analyze
```

### 2. Automated Test Suite
Execute the full unit and widget test suite:
```bash
flutter test
```
- Tests are located in `test/` (`simple_alert_test.dart`, `simple_alert_preferences_test.dart`).
- When adding new features or fixing bugs, create corresponding test cases in `test/` to maintain high test coverage.

### 3. Example App Verification
Validate the example application in `example/`:
```bash
cd example
flutter run
```
- Verify that interactive features (stacking, mixed-script text, route transitions, dialog overlays, progress bar hold-to-pause) behave smoothly.

---

## Code Style & Idioms

- **Language Level**: Dart >= 3.3.0.
- **Pattern Matching & Switch Expressions**: Prefer exhaustive `switch` expressions for enums (`SimpleAlertType`, `SimpleAlertDuration`, `SimpleAlertShape`, locales) over cascading `if-else` statements.
- **Null Safety**: Maintain sound null safety. Avoid force unwraps (`!`) unless guaranteed by preceding validation.
- **Documentation**: All public APIs in `lib/simple_alert.dart` and `lib/src/` must contain descriptive dartdoc comments (`///`).
- **Copyright Header**: Maintain the standard project copyright header on all newly created or edited Dart source files:
  ```dart
  /*
  * This file is a part of "SimpleAlert" project.
  * Khaled Mohsen <pres.kbayomy@gmail.com>
  * Copyrights (BSD-3-Clause), LICENSE.
  */
  ```

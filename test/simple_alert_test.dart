import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_alert/simple_alert.dart';
import 'package:simple_alert/src/backend/alert_manager.dart';
import 'package:simple_alert/src/backend/alert_timer_controller.dart';
import 'package:simple_alert/src/misc/constants.dart';

// Import your alert files
// import 'package:your_package/simple_alert.dart';
// import 'package:your_package/simple_alert_constants.dart';

/// Comprehensive test suite for SimpleAlert
void main() {
  group('AlertValidator Tests', () {
    test('validateTitle throws on empty string', () {
      expect(
        () => AlertValidator.validateTitle(''),
        throwsArgumentError,
      );
    });

    test('validateTitle throws on whitespace-only string', () {
      expect(
        () => AlertValidator.validateTitle('   '),
        throwsArgumentError,
      );
    });

    test('validateTitle accepts valid title', () {
      expect(
        () => AlertValidator.validateTitle('Valid Title'),
        returnsNormally,
      );
    });

    test('validateDuration throws on negative duration', () {
      expect(
        () =>
            AlertValidator.validateDuration(const Duration(milliseconds: -100)),
        throwsArgumentError,
      );
    });

    test('validateDuration throws on zero duration', () {
      expect(
        () => AlertValidator.validateDuration(Duration.zero),
        throwsArgumentError,
      );
    });

    test('validateDuration accepts positive duration', () {
      expect(
        () => AlertValidator.validateDuration(const Duration(seconds: 5)),
        returnsNormally,
      );
    });

    test('validateWidth throws on negative width', () {
      expect(
        () => AlertValidator.validateWidth(-100),
        throwsArgumentError,
      );
    });

    test('validateWidth throws on zero width', () {
      expect(
        () => AlertValidator.validateWidth(0),
        throwsArgumentError,
      );
    });

    test('validateWidth accepts positive width', () {
      expect(
        () => AlertValidator.validateWidth(300),
        returnsNormally,
      );
    });
  });

  group('AlertPerformanceUtils Tests', () {
    test('calculateOptimalWidth for small phone', () {
      final width = AlertPerformanceUtils.calculateOptimalWidth(360);
      expect(width, 342); // 360 * 0.95
    });

    test('calculateOptimalWidth for normal phone', () {
      final width = AlertPerformanceUtils.calculateOptimalWidth(400);
      expect(width, 360); // 400 * 0.90
    });

    test('calculateOptimalWidth for tablet', () {
      final width = AlertPerformanceUtils.calculateOptimalWidth(800);
      expect(width, 560); // 800 * 0.70
    });

    test('calculateOptimalWidth respects maximum', () {
      final width = AlertPerformanceUtils.calculateOptimalWidth(2000);
      expect(width, lessThanOrEqualTo(MAX_ALERT_WIDTH));
    });

    testWidgets('getAverageHeight returns correct portrait value',
        (tester) async {
      double? height;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(400, 800),
          ),
          child: Builder(
            builder: (context) {
              height = AlertPerformanceUtils.getAverageHeight(
                Orientation.portrait,
                context,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(height, AVERAGE_PORTRAIT_HEIGHT);
    });

    testWidgets('getAverageHeight returns correct landscape value',
        (tester) async {
      double? height;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
            size: Size(800, 400),
          ),
          child: Builder(
            builder: (context) {
              height = AlertPerformanceUtils.getAverageHeight(
                Orientation.landscape,
                context,
              );
              return const SizedBox();
            },
          ),
        ),
      );

      expect(height, AVERAGE_LANDSCAPE_HEIGHT);
    });
  });

  group('AlertColorUtils Tests', () {
    test('calculateContrastRatio between black and white', () {
      final ratio = AlertColorUtils.calculateContrastRatio(
        Colors.black,
        Colors.white,
      );
      expect(ratio, closeTo(21, 0.1)); // Maximum contrast ratio
    });

    test('calculateContrastRatio between same colors', () {
      final ratio = AlertColorUtils.calculateContrastRatio(
        Colors.blue,
        Colors.blue,
      );
      expect(ratio, closeTo(1, 0.1)); // Minimum contrast ratio
    });

    test('meetsWCAGAA returns true for sufficient contrast', () {
      expect(
        AlertColorUtils.meetsWCAGAA(Colors.white, Colors.black),
        isTrue,
      );
    });

    test('meetsWCAGAA returns false for insufficient contrast', () {
      expect(
        AlertColorUtils.meetsWCAGAA(
          const Color(0xFFCCCCCC),
          const Color(0xFFDDDDDD),
        ),
        isFalse,
      );
    });

    test('getContrastingColor returns white for dark background', () {
      final color = AlertColorUtils.getContrastingColor(Colors.black);
      expect(color, Colors.white);
    });

    test('getContrastingColor returns black for light background', () {
      final color = AlertColorUtils.getContrastingColor(Colors.white);
      expect(color, Colors.black);
    });
  });

  group('_AlertManager Tests', () {
    late AlertManager manager;

    setUp(() {
      manager = AlertManager();
      manager.displayedAlerts.value = {};
    });

    test('registerAlert adds alert to displayed alerts', () {
      final data = AlertData(
        size: const Size(300, 70),
        fromTop: true,
        fromCenter: false,
        fromBottom: false,
      );

      manager.registerAlert('test_route', data);

      expect(manager.displayedAlerts.value.containsKey('test_route'), isTrue);
      expect(manager.displayedAlerts.value['test_route'], data);
    });

    test('unregisterAlert removes alert from displayed alerts', () {
      final data = AlertData(
        size: const Size(300, 70),
        fromTop: true,
        fromCenter: false,
        fromBottom: false,
      );

      manager.registerAlert('test_route', data);
      manager.unregisterAlert('test_route');

      expect(manager.displayedAlerts.value.containsKey('test_route'), isFalse);
    });

    test('updateAlertSize updates size correctly', () {
      final data = AlertData(
        size: const Size(300, 70),
        fromTop: true,
        fromCenter: false,
        fromBottom: false,
      );

      manager.registerAlert('test_route', data);
      manager.updateAlertSize('test_route', const Size(300, 100));

      expect(manager.displayedAlerts.value['test_route']!.size.height, 100);
    });

    test('getAlertsInSameDirection filters correctly', () {
      final data1 = AlertData(
        size: const Size(300, 70),
        fromTop: true,
        fromCenter: false,
        fromBottom: false,
      );
      final data2 = AlertData(
        size: const Size(300, 70),
        fromTop: true,
        fromCenter: false,
        fromBottom: false,
      );
      final data3 = AlertData(
        size: const Size(300, 70),
        fromTop: false,
        fromCenter: false,
        fromBottom: true,
      );

      manager.registerAlert('route1', data1);
      manager.registerAlert('route2', data2);
      manager.registerAlert('route3', data3);

      final sameDirection = manager.getAlertsInSameDirection(
        'route3',
        AlignmentDirectional.topCenter,
      );

      expect(sameDirection.length, 2); // route1 and route2
    });
  });

  group('_AlertTimerController Tests', () {
    test('timer starts and counts down', () async {
      var completed = false;
      final controller = AlertTimerController(
        duration: const Duration(milliseconds: 300),
        onComplete: () => completed = true,
      );

      controller.start();

      await Future.delayed(const Duration(milliseconds: 400));

      expect(completed, isTrue);
      expect(controller.remainingMilliseconds.value, lessThanOrEqualTo(0));

      controller.dispose();
    });

    test('pause stops countdown', () async {
      var completed = false;
      final controller = AlertTimerController(
        duration: const Duration(milliseconds: 500),
        onComplete: () => completed = true,
      );

      controller.start();
      await Future.delayed(const Duration(milliseconds: 150));

      final remainingBeforePause = controller.remainingMilliseconds.value;
      controller.pause();

      await Future.delayed(const Duration(milliseconds: 200));

      // Value should not have changed much during pause
      expect(
        (controller.remainingMilliseconds.value - remainingBeforePause).abs(),
        lessThan(50),
      );
      expect(completed, isFalse);

      controller.dispose();
    });

    test('resume continues countdown after pause', () async {
      var completed = false;
      final controller = AlertTimerController(
        duration: const Duration(milliseconds: 300),
        onComplete: () => completed = true,
      );

      controller.start();
      await Future.delayed(const Duration(milliseconds: 100));

      controller.pause();
      await Future.delayed(const Duration(milliseconds: 100));

      controller.resume();
      await Future.delayed(const Duration(milliseconds: 250));

      expect(completed, isTrue);

      controller.dispose();
    });

    test('dispose stops timer', () async {
      var completed = false;
      final controller = AlertTimerController(
        duration: const Duration(milliseconds: 300),
        onComplete: () => completed = true,
      );

      controller.start();
      await Future.delayed(const Duration(milliseconds: 100));

      controller.dispose();
      await Future.delayed(const Duration(milliseconds: 300));

      expect(completed, isFalse);
    });
  });

  group('SimpleAlert Fail-Safe and Gesture Widget Tests', () {
    testWidgets('Swipe to dismiss closes alert cleanly without exceptions',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => SimpleAlertHost(child: child!),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    SimpleAlert(
                      context: context,
                      title: 'Swipe me away',
                      duration: SimpleAlertDuration.long,
                    );
                  },
                  child: const Text('Show Alert'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Alert'));
      await tester.pumpAndSettle();

      expect(find.text('Swipe me away'), findsOneWidget);

      // Fling horizontally to dismiss
      await tester.fling(
        find.text('Swipe me away'),
        const Offset(500, 0),
        1000,
      );
      await tester.pumpAndSettle();

      // Ensure alert is removed cleanly without any Dismissible assertion error
      expect(find.text('Swipe me away'), findsNothing);
    });

    testWidgets(
        'SimpleAlert handles bad parameters gracefully without crashing host app',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => SimpleAlertHost(child: child!),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    SimpleAlert(
                      context: context,
                      title: 'Safe Alert',
                      width: -50,
                      customDuration: const Duration(milliseconds: -10),
                    );
                  },
                  child: const Text('Show Bad Alert'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Bad Alert'));
      await tester.pumpAndSettle();

      expect(find.text('Safe Alert'), findsOneWidget);

      // Dismiss the alert to ensure timers are cleanly cancelled
      await tester.tap(find.text('Safe Alert'));
      await tester.pumpAndSettle();
      expect(find.text('Safe Alert'), findsNothing);
    });

    testWidgets('Accessibility and Focus management test',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => SimpleAlertHost(child: child!),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    SimpleAlert(
                      context: context,
                      title: 'A11y Alert',
                      description: 'Testing screen reader announcement',
                    );
                  },
                  child: const Text('Show A11y Alert'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show A11y Alert'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      // Verify alert is visible
      expect(find.text('A11y Alert'), findsOneWidget);

      // Verify liveRegion semantics is enabled
      final semanticsFinder = find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.liveRegion == true,
      );
      expect(semanticsFinder, findsWidgets);

      // Verify non-focus-stealing FocusScope is present
      final focusScopeFinder = find.byWidgetPredicate(
        (widget) => widget is FocusScope && widget.canRequestFocus == false,
      );
      expect(focusScopeFinder, findsWidgets);

      // Dismiss all alerts
      await SimpleAlert.dismissAll();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.text('A11y Alert'), findsNothing);
    });

    testWidgets(
        'Alert persists and remains visible above newly pushed routes and dialogs',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => SimpleAlertHost(child: child!),
          home: Scaffold(
            appBar: AppBar(title: const Text('Screen 1')),
            body: Builder(
              builder: (context) {
                return Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        SimpleAlert(
                          context: context,
                          title: 'Persistent Alert',
                          duration: SimpleAlertDuration.long,
                        );
                      },
                      child: const Text('Show Persistent Alert'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => Scaffold(
                              appBar: AppBar(title: const Text('Screen 2')),
                              body:
                                  const Center(child: Text('Screen 2 Content')),
                            ),
                          ),
                        );
                      },
                      child: const Text('Push Screen 2'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // 1. Trigger the alert on Screen 1
      await tester.tap(find.text('Show Persistent Alert'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.text('Persistent Alert'), findsOneWidget);

      // 2. Navigate to Screen 2
      await tester.tap(find.text('Push Screen 2'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      // Verify Screen 2 is active
      expect(find.text('Screen 2 Content'), findsOneWidget);

      // CRITICAL: Verify the alert is STILL visible above Screen 2!
      expect(find.text('Persistent Alert'), findsOneWidget);

      // 3. Show a modal dialog on Screen 2
      final BuildContext screen2Context =
          tester.element(find.text('Screen 2 Content'));
      showDialog(
        context: screen2Context,
        builder: (_) => const AlertDialog(
          title: Text('Modal Dialog'),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      // Dialog is visible
      expect(find.text('Modal Dialog'), findsOneWidget);

      // CRITICAL: The alert is STILL visible above the modal dialog!
      expect(find.text('Persistent Alert'), findsOneWidget);

      // Dismiss all alerts
      await SimpleAlert.dismissAll();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.text('Persistent Alert'), findsNothing);
    });

    testWidgets(
        'Tooltip inside SimpleAlert finds Overlay ancestor and renders without error',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => SimpleAlertHost(child: child!),
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    SimpleAlert(
                      context: context,
                      title: 'Tooltip Test Alert',
                      withClose: true,
                    );
                  },
                  child: const Text('Show Tooltip Alert'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Tooltip Alert'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text('Tooltip Test Alert'), findsOneWidget);

      // Verify that Tooltip exists in the alert and has an Overlay ancestor without throwing assertions
      final tooltipFinder = find.byType(Tooltip);
      expect(tooltipFinder, findsWidgets);

      await SimpleAlert.dismissAll();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(find.text('Tooltip Test Alert'), findsNothing);
    });

    test(
        'SimpleAlertPreferences retains values when instantiated without arguments',
        () {
      SimpleAlertPreferences(
        titleStyle: const TextStyle(fontSize: 42.0, color: Colors.purple),
        iconsColor: Colors.deepOrange,
      );

      // Subsequent call without arguments must retain configured preferences
      final prefs = SimpleAlertPreferences();
      expect(prefs.titleStyle.fontSize, 42.0);
      expect(prefs.titleStyle.color, Colors.purple);
      expect(prefs.iconsColor, Colors.deepOrange);
    });
  });
}

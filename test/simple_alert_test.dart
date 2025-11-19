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
        () => AlertValidator.validateDuration(const Duration(milliseconds: -100)),
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

    test('getAverageHeight returns correct portrait value', () {
      final testContext = _MockBuildContext(
        size: const Size(400, 800),
        orientation: Orientation.portrait,
      );

      final height = AlertPerformanceUtils.getAverageHeight(
        Orientation.portrait,
        testContext,
      );

      expect(height, AVERAGE_PORTRAIT_HEIGHT);
    });

    test('getAverageHeight returns correct landscape value', () {
      final testContext = _MockBuildContext(
        size: const Size(800, 400),
        orientation: Orientation.landscape,
      );

      final height = AlertPerformanceUtils.getAverageHeight(
        Orientation.landscape,
        testContext,
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

  /*group('AlertA11yUtils Tests', () {
    test('getTypeSemanticLabel returns correct labels', () {
      expect(
        AlertA11yUtils.getTypeSemanticLabel(SimpleAlertType.success),
        'تنبيه نجاح',
      );
      expect(
        AlertA11yUtils.getTypeSemanticLabel(SimpleAlertType.danger),
        'تنبيه خطر',
      );
      expect(
        AlertA11yUtils.getTypeSemanticLabel(SimpleAlertType.warning),
        'تنبيه تحذير',
      );
    });

    test('getSemanticHint for loading alert', () {
      final hint = AlertA11yUtils.getSemanticHint(
        closeOnPress: false,
        withProgressBar: false,
        loading: true,
      );
      expect(hint, contains('جاري التحميل'));
    });

    test('getSemanticHint for progress bar alert', () {
      final hint = AlertA11yUtils.getSemanticHint(
        closeOnPress: false,
        withProgressBar: true,
        loading: false,
      );
      expect(hint, contains('اضغط مع الاستمرار'));
    });

    test('getSemanticHint for closeable alert', () {
      final hint = AlertA11yUtils.getSemanticHint(
        closeOnPress: true,
        withProgressBar: false,
        loading: false,
      );
      expect(hint, contains('اضغط للإغلاق'));
    });
  });*/

  /*group('Extension Methods Tests', () {
    test('Duration.toReadableString for days', () {
      expect(
        const Duration(days: 2).toReadableString(),
        '2 يوم',
      );
    });

    test('Duration.toReadableString for hours', () {
      expect(
        const Duration(hours: 3).toReadableString(),
        '3 ساعة',
      );
    });

    test('Duration.toReadableString for minutes', () {
      expect(
        const Duration(minutes: 5).toReadableString(),
        '5 دقيقة',
      );
    });

    test('Duration.toReadableString for seconds', () {
      expect(
        const Duration(seconds: 30).toReadableString(),
        '30 ثانية',
      );
    });

    test('Duration.isInstant returns true for very short durations', () {
      expect(const Duration(milliseconds: 10).isInstant, isTrue);
      expect(const Duration(milliseconds: 50).isInstant, isTrue);
    });

    test('Duration.isInstant returns false for longer durations', () {
      expect(const Duration(milliseconds: 100).isInstant, isFalse);
      expect(const Duration(seconds: 1).isInstant, isFalse);
    });

    test('SimpleAlertType.priority returns correct values', () {
      expect(SimpleAlertType.danger.priority, 4);
      expect(SimpleAlertType.warning.priority, 3);
      expect(SimpleAlertType.info.priority, 2);
      expect(SimpleAlertType.success.priority, 1);
      expect(SimpleAlertType.normal.priority, 0);
    });

    test('SimpleAlertType.isCritical identifies critical alerts', () {
      expect(SimpleAlertType.danger.isCritical, isTrue);
      expect(SimpleAlertType.warning.isCritical, isTrue);
      expect(SimpleAlertType.info.isCritical, isFalse);
      expect(SimpleAlertType.success.isCritical, isFalse);
    });
  });*/

  group('_AlertManager Tests', () {
    late AlertManager manager;

    setUp(() {
      manager = AlertManager();
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
}

// ============================================================================
// Mock Classes for Testing
// ============================================================================

class _MockBuildContext extends BuildContext {
  @override
  final Size size;
  final Orientation orientation;

  _MockBuildContext({
    required this.size,
    required this.orientation,
  });

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

// Additional helper functions for widget testing
class AlertTestHelpers {
  /// Creates a test app wrapper for alert testing
  static Widget createTestApp({
    required Widget child,
    ThemeData? theme,
  }) {
    return MaterialApp(
      theme: theme ?? ThemeData.light(),
      home: Scaffold(
        body: child,
      ),
    );
  }

  /// Finds alert widget in widget tree
  static Finder findAlert() {
    return find.byType(SimpleAlert);
  }

  /// Waits for alert to appear
  static Future<void> waitForAlert(WidgetTester tester) async {
    await tester.pumpAndSettle();
  }

  /// Taps on alert
  static Future<void> tapAlert(WidgetTester tester) async {
    await tester.tap(findAlert());
    await tester.pumpAndSettle();
  }

  /// Verifies alert is visible
  static void verifyAlertVisible(WidgetTester tester) {
    expect(findAlert(), findsOneWidget);
  }

  /// Verifies alert is not visible
  static void verifyAlertNotVisible(WidgetTester tester) {
    expect(findAlert(), findsNothing);
  }
}

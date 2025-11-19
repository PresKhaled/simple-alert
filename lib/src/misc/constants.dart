import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../i18n/translations.g.dart';
import '../../simple_alert.dart';

// ============================================================================
// Constants
// ============================================================================

/// Default border radius value for alerts
const double BORDER_RADIUS = 12.0;

/// Default splash radius for icon buttons within alerts
const double ICON_BUTTON_SPLASH_RADIUS = 20.0;

/// Minimum alert width in pixels
const double MIN_ALERT_WIDTH = 200.0;

/// Maximum alert width in pixels
const double MAX_ALERT_WIDTH = 600.0;

/// Default animation duration for opacity transitions
const Duration DEFAULT_OPACITY_DURATION = Duration(milliseconds: 250);

/// Default animation duration for width transitions
const Duration DEFAULT_WIDTH_DURATION = Duration(milliseconds: 200);

/// Timer tick interval for countdown
const Duration TIMER_TICK_INTERVAL = Duration(milliseconds: 100);

/// Default vertical spacing between stacked alerts
const double ALERT_VERTICAL_SPACING = 5.0;

/// Default horizontal padding for alerts
const double ALERT_HORIZONTAL_PADDING = 13.0;

/// Default content padding inside alerts
const double ALERT_CONTENT_PADDING = 11.0;

/// Default icon padding
const double ICON_PADDING = 9.0;

/// Average portrait alert height (for initial calculations)
const double AVERAGE_PORTRAIT_HEIGHT = 70.0;

/// Average landscape alert height (for initial calculations)
const double AVERAGE_LANDSCAPE_HEIGHT = 50.0;

// ============================================================================
// Validation Utilities
// ============================================================================

/// Validates alert configuration parameters
class AlertValidator {
  /// Validates that the title is not empty
  static void validateTitle(String title) {
    if (title.trim().isEmpty) {
      throw ArgumentError('Alert title cannot be empty');
    }
  }

  /// Validates that the duration is positive
  static void validateDuration(Duration? duration) {
    if (duration != null && duration.inMilliseconds <= 0) {
      throw ArgumentError(
        'Duration must be positive, got: ${duration.inMilliseconds}ms',
      );
    }
  }

  /// Validates that the width is within acceptable bounds
  static void validateWidth(double? width) {
    if (width != null) {
      if (width <= 0) {
        throw ArgumentError('Width must be positive, got: $width');
      }
      if (width < MIN_ALERT_WIDTH) {
        debugPrint(
          'Warning: Alert width ($width) is less than recommended minimum ($MIN_ALERT_WIDTH)',
        );
      }
    }
  }

  /// Validates border radius
  static void validateBorderRadius(BorderRadius? borderRadius) {
    if (borderRadius != null) {
      final radii = [
        borderRadius.topLeft.x,
        borderRadius.topRight.x,
        borderRadius.bottomLeft.x,
        borderRadius.bottomRight.x,
      ];

      for (final radius in radii) {
        if (radius < 0) {
          throw ArgumentError('Border radius cannot be negative');
        }
      }
    }
  }

  /// Validates animation duration
  static void validateAnimationDuration(Duration duration) {
    if (duration.inMilliseconds < 0) {
      throw ArgumentError(
        'Animation duration cannot be negative: ${duration.inMilliseconds}ms',
      );
    }
    if (duration.inMilliseconds > 5000) {
      debugPrint(
        'Warning: Animation duration (${duration.inMilliseconds}ms) is unusually long',
      );
    }
  }
}

// ============================================================================
// Performance Utilities
// ============================================================================

/// Utilities for optimizing alert performance
class AlertPerformanceUtils {
  /// Calculates optimal alert width based on screen size
  static double calculateOptimalWidth(double screenWidth) {
    if (screenWidth <= 360) {
      // Small phones
      return screenWidth * 0.95;
    } else if (screenWidth <= 600) {
      // Normal phones
      return screenWidth * 0.90;
    } else if (screenWidth <= 840) {
      // Tablets portrait
      return screenWidth * 0.70;
    } else {
      // Large tablets and desktops
      return screenWidth.clamp(MIN_ALERT_WIDTH, MAX_ALERT_WIDTH);
    }
  }

  /// Determines if the device is likely a tablet
  static bool isTablet(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final diagonal = sqrt(size.width * size.width + size.height * size.height);
    return diagonal > 1100; // Rough estimate for tablets
  }

  /// Gets appropriate average height based on orientation and device
  static double getAverageHeight(Orientation orientation, BuildContext context) {
    final isTabletDevice = isTablet(context);

    if (orientation == Orientation.portrait) {
      return isTabletDevice ? 80.0 : AVERAGE_PORTRAIT_HEIGHT;
    } else {
      return isTabletDevice ? 60.0 : AVERAGE_LANDSCAPE_HEIGHT;
    }
  }

  /// Debounce rapid successive calls (useful for orientation changes)
  static void debounce(
    VoidCallback callback, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    Timer? timer;
    return () {
      timer?.cancel();
      timer = Timer(delay, callback);
    }();
  }
}

// ============================================================================
// Accessibility Utilities
// ============================================================================

/// Utilities for improving accessibility
class AlertA11yUtils {
  /// Gets semantic label for alert type
  static String getTypeSemanticLabel(SimpleAlertType type) {
    return switch (type) {
      SimpleAlertType.normal => t.generalAlertType,
      SimpleAlertType.success => t.successAlertType,
      SimpleAlertType.warning => t.warningAlertType,
      SimpleAlertType.danger => t.dangerAlertType,
      SimpleAlertType.info => t.informationAlertType,
    };
  }

  /// Gets appropriate semantic hint for alert
  static String getSemanticHint({
    required bool closeOnPress,
    required bool withProgressBar,
    required bool loading,
  }) {
    if (loading) {
      return t.loadingSemanticHint;
    }
    if (withProgressBar) {
      return t.pressAndHoldToPauseCountdownSemanticHint;
    }
    if (closeOnPress) {
      return t.clickToCloseSemanticHint;
    }
    return '';
  }

  /// Checks if we should reduce motion based on accessibility settings
  static bool shouldReduceMotion(BuildContext context) {
    final mediaQuery = MediaQuery.maybeOf(context);
    return mediaQuery?.disableAnimations ?? false;
  }

  /// Gets adjusted animation duration based on accessibility settings
  static Duration getAccessibleDuration(
    BuildContext context,
    Duration normalDuration,
  ) {
    if (shouldReduceMotion(context)) {
      return Duration.zero;
    }
    return normalDuration;
  }

  /// Announces alert to screen readers
  static Future<void> announceAlert({
    required String title,
    String? description,
    required SimpleAlertType type,
  }) async {
    final typeLabel = getTypeSemanticLabel(type);
    final message = description != null ? '$typeLabel: $title. $description' : '$typeLabel: $title';

    await SemanticsService.announce(
      message,
      ui.TextDirection.rtl,
    );
  }
}

// ============================================================================
// Color Utilities
// ============================================================================

/// Utilities for color calculations and accessibility
class AlertColorUtils {
  /// Calculates contrast ratio between two colors
  static double calculateContrastRatio(Color color1, Color color2) {
    final luminance1 = color1.computeLuminance();
    final luminance2 = color2.computeLuminance();

    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Checks if color contrast meets WCAG AA standards (4.5:1 for normal text)
  static bool meetsWCAGAA(Color foreground, Color background) {
    return calculateContrastRatio(foreground, background) >= 4.5;
  }

  /// Checks if color contrast meets WCAG AAA standards (7:1 for normal text)
  static bool meetsWCAGAAA(Color foreground, Color background) {
    return calculateContrastRatio(foreground, background) >= 7.0;
  }

  /// Gets appropriate foreground color based on background
  static Color getContrastingColor(Color background) {
    final luminance = background.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Validates color contrast and warns if insufficient
  static void validateColorContrast({
    required Color foreground,
    required Color background,
    required String context,
  }) {
    if (!meetsWCAGAA(foreground, background)) {
      final ratio = calculateContrastRatio(foreground, background);
      debugPrint(
        'Warning: Color contrast in $context (${ratio.toStringAsFixed(2)}:1) '
        'does not meet WCAG AA standards (4.5:1)',
      );
    }
  }
}

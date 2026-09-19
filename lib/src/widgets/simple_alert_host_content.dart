import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../i18n/translations.g.dart';
import '../_alert.dart';
import '../backend/alert_manager.dart';
import 'simple_alert_safe_area_wrapper.dart';

/// A widget that represents the content of an alert within [SimpleAlertHost].
///
/// It handles size registration and timer triggering after the first frame,
/// provides accessibility announcements (`SemanticsService.announce` & `liveRegion`),
/// and manages animations and safe area wrapping.
class SimpleAlertHostContent extends StatefulWidget {
  /// Creates a [SimpleAlertHostContent] instance.
  const SimpleAlertHostContent({
    super.key,
    required this.onFirstFrameBuilt,
    required this.closeAlert,
    required this.onOpacityAnimationControllerCreated,
    required this.animatedOpacityDuration,
    this.themeData,
    this.textDirection,
    this.announcement,
    // Properties for SimpleAlertSafeAreaWrapper
    required this.alertKey,
    required this.resolvedAlignment,
    required this.alertWidth,
    required this.calculateVerticalOffset,
    required this.alertManager,
    required this.routeName,
    required this.updateAlertSize,
    // Pass-through properties for SimpleAlertInteractiveContainer
    required this.title,
    this.description,
    required this.withProgressBar,
    required this.closeOnPress,
    required this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    required this.getBorderRadius,
    required this.getBackgroundColor,
    required this.loading,
    required this.centerContent,
    this.actions,
    required this.withClose,
    required this.onWidthAnimationControllerCreated,
    required this.resolvedDuration,
    required this.getForegroundColor,
    required this.getIcon,
    required this.onClosePressed,
  });

  /// Callback to be invoked after the first frame of the alert is built.
  final VoidCallback onFirstFrameBuilt;

  /// Callback to close the alert.
  final Future<void> Function({bool immediate}) closeAlert;

  /// The callback for the opacity animation controller.
  final ValueChanged<AnimationController> onOpacityAnimationControllerCreated;

  /// The duration of the opacity animation.
  final Duration animatedOpacityDuration;

  /// Optional theme override captured from caller context.
  final ThemeData? themeData;

  /// Optional text direction override.
  final TextDirection? textDirection;

  /// Optional semantic announcement for screen readers.
  final String? announcement;

  // Properties for SimpleAlertSafeAreaWrapper
  final GlobalKey alertKey;
  final AlignmentDirectional resolvedAlignment;
  final double alertWidth;
  final double Function(Map<String, AlertData>, Orientation, double)
      calculateVerticalOffset;
  final AlertManager alertManager;
  final String routeName;
  final void Function(String, Size) updateAlertSize;

  // Pass-through properties for SimpleAlertInteractiveContainer
  final String title;
  final String? description;
  final bool withProgressBar;
  final bool closeOnPress;
  final VoidCallback onTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final BorderRadius Function() getBorderRadius;
  final Color Function() getBackgroundColor;
  final bool loading;
  final bool centerContent;
  final List<IconButton>? actions;
  final bool withClose;
  final ValueChanged<AnimationController> onWidthAnimationControllerCreated;
  final Duration resolvedDuration;
  final Color Function() getForegroundColor;
  final Icon Function() getIcon;
  final VoidCallback onClosePressed;

  @override
  State<SimpleAlertHostContent> createState() => _SimpleAlertHostContentState();
}

class _SimpleAlertHostContentState extends State<SimpleAlertHostContent> {
  @override
  void initState() {
    super.initState();
    // Schedule a callback to run after the first frame is rendered to calculate alert size.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          widget.onFirstFrameBuilt();
        } catch (e) {
          debugPrint('SimpleAlertHostContent onFirstFrameBuilt safe error: $e');
        }
      }
    });

    // Announce to screen readers (TalkBack / VoiceOver) upon alert display
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          final direction = widget.textDirection ??
              Directionality.maybeOf(context) ??
              TextDirection.ltr;
          final message = (widget.announcement != null &&
                  widget.announcement!.trim().isNotEmpty)
              ? widget.announcement!
              : t.newAlertDisplayedAnnouncement;

          // ignore: deprecated_member_use
          SemanticsService.announce(message, direction);
        } catch (_) {}
      }
    });
  }

  @override
  void dispose() {
    try {
      final direction = widget.textDirection ?? TextDirection.ltr;
      // ignore: deprecated_member_use
      SemanticsService.announce(t.alertClosedAnnouncement, direction);
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      Widget content = Alert(
        alignment: widget.resolvedAlignment,
        onAnimationControllerCreated: widget.onOpacityAnimationControllerCreated,
        animatedOpacityDuration: widget.animatedOpacityDuration,
        child: SimpleAlertSafeAreaWrapper(
          alertKey: widget.alertKey,
          resolvedAlignment: widget.resolvedAlignment,
          alertWidth: widget.alertWidth,
          calculateVerticalOffset: widget.calculateVerticalOffset,
          alertManager: widget.alertManager,
          routeName: widget.routeName,
          updateAlertSize: widget.updateAlertSize,
          title: widget.title,
          description: widget.description,
          textDirection: widget.textDirection,
          withProgressBar: widget.withProgressBar,
          closeOnPress: widget.closeOnPress,
          onTap: widget.onTap,
          onTapDown: widget.onTapDown,
          onTapUp: widget.onTapUp,
          onTapCancel: widget.onTapCancel,
          getBorderRadius: widget.getBorderRadius,
          getBackgroundColor: widget.getBackgroundColor,
          loading: widget.loading,
          centerContent: widget.centerContent,
          actions: widget.actions,
          withClose: widget.withClose,
          onWidthAnimationControllerCreated:
              widget.onWidthAnimationControllerCreated,
          resolvedDuration: widget.resolvedDuration,
          getForegroundColor: widget.getForegroundColor,
          getIcon: widget.getIcon,
          onClosePressed: widget.onClosePressed,
          onDismissedImmediate: () {
            try {
              widget.closeAlert(immediate: true);
            } catch (_) {}
          },
        ),
      );

      final direction = widget.textDirection ??
          Directionality.maybeOf(context) ??
          TextDirection.ltr;

      content = Semantics(
        container: true,
        liveRegion: true,
        label: widget.announcement ?? t.generalAlertType,
        child: Directionality(
          textDirection: direction,
          child: content,
        ),
      );

      if (widget.themeData != null) {
        content = Theme(
          data: widget.themeData!,
          child: content,
        );
      }

      return content;
    } catch (e) {
      debugPrint('SimpleAlertHostContent build safe error: $e');
      try {
        widget.closeAlert(immediate: true);
      } catch (_) {}
      return const SizedBox.shrink();
    }
  }
}

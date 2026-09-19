/*
* This file is a part of "SimpleAlert" project.
* Khaled Mohsen <pres.kbayomy@gmail.com>
* Copyrights (BSD-3-Clause), LICENSE.
*/

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../backend/alert_manager.dart';
import '../enums/simple_alert_shape.dart';
import '../enums/simple_alert_type.dart';
import '../misc/constants.dart';
import '../misc/simple_alert_localizations.dart';
import '../simple_alert_preferences.dart';
import 'simple_alert_actions_section.dart';
import 'simple_alert_leading_icon.dart';
import 'simple_alert_text_content.dart';

/// A self-contained, high-performance widget representing a single alert card.
///
/// Handles its own entrance/exit animations, touch gestures, swipe-to-dismiss physics,
/// auto-dismiss timer, progress bar rendering, and spatial size reporting.
class SimpleAlertCard extends StatefulWidget {
  /// Unique identifier for this alert instance.
  final String routeName;

  /// The main title text.
  final String title;

  /// Optional description text.
  final String? description;

  /// The alignment of the alert on screen.
  final AlignmentDirectional alignment;

  /// The specified width of the alert.
  final double? width;

  /// The shape of the alert container.
  final SimpleAlertShape? shape;

  /// The border radius for the alert's corners. Overrides [shape] if specified.
  final BorderRadius? borderRadius;

  /// The predefined semantic type of the alert.
  final SimpleAlertType type;

  /// The custom background color, if any.
  final Color? backgroundColor;

  /// The custom foreground color, if any.
  final Color? foregroundColor;

  /// The duration before auto-dismissal.
  final Duration duration;

  /// The duration of the entrance/exit animation.
  final Duration animatedOpacityDuration;

  /// Explicit text direction override.
  final TextDirection? textDirection;

  /// Whether to display a loading indicator.
  final bool loading;

  /// Whether content should be horizontally centered.
  final bool centerContent;

  /// Whether the alert closes when tapped.
  final bool closeOnPress;

  /// Whether to show the close button.
  final bool withClose;

  /// Whether to show the countdown progress bar.
  final bool withProgressBar;

  /// Action buttons to display.
  final List<IconButton>? actions;

  /// Optional theme override captured from caller.
  final ThemeData? themeData;

  /// Callback to dismiss this alert from the manager.
  final VoidCallback onDismissed;

  /// Creates a [SimpleAlertCard] instance.
  const SimpleAlertCard({
    super.key,
    required this.routeName,
    required this.title,
    this.description,
    required this.alignment,
    this.width,
    this.shape,
    this.borderRadius,
    required this.type,
    this.backgroundColor,
    this.foregroundColor,
    required this.duration,
    this.animatedOpacityDuration = DEFAULT_OPACITY_DURATION,
    this.textDirection,
    this.loading = false,
    this.centerContent = false,
    this.closeOnPress = true,
    this.withClose = false,
    this.withProgressBar = false,
    this.actions,
    this.themeData,
    required this.onDismissed,
  });

  @override
  State<SimpleAlertCard> createState() => SimpleAlertCardState();
}

class SimpleAlertCardState extends State<SimpleAlertCard>
    with TickerProviderStateMixin {
  final AlertManager _alertManager = AlertManager();
  final GlobalKey _measureKey = GlobalKey();

  late final AnimationController _transitionController;
  late final CurvedAnimation _curvedAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _scaleAnimation;

  late final AnimationController _dragAnimController;
  Animation<double>? _dragAnimation;
  double _dragOffset = 0.0;

  AnimationController? _progressController;
  Timer? _dismissTimer;
  DateTime? _timerStartTime;
  late Duration _remainingDuration;

  bool _isClosing = false;
  Orientation? _lastOrientation;

  @override
  void initState() {
    super.initState();
    _remainingDuration = widget.duration;

    // 1. Setup Entrance/Exit Animation
    _transitionController = AnimationController(
      vsync: this,
      duration: widget.animatedOpacityDuration,
      reverseDuration: widget.animatedOpacityDuration,
    )..forward();

    _curvedAnimation = CurvedAnimation(
      parent: _transitionController,
      curve: DEFAULT_ALERT_CURVE,
      reverseCurve: Curves.easeInCubic,
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_curvedAnimation);

    final Offset beginSlide;
    if (widget.alignment.y < 0) {
      beginSlide = const Offset(0.0, -0.35);
    } else if (widget.alignment.y > 0) {
      beginSlide = const Offset(0.0, 0.35);
    } else {
      beginSlide = const Offset(0.0, -0.12);
    }

    _slideAnimation = Tween<Offset>(
      begin: beginSlide,
      end: Offset.zero,
    ).animate(_curvedAnimation);

    _scaleAnimation =
        Tween<double>(begin: 0.94, end: 1.0).animate(_curvedAnimation);

    // 2. Setup Drag Controller for Swipe-To-Dismiss
    _dragAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    // 3. Setup Progress Controller if progress bar is enabled
    if (widget.withProgressBar) {
      _progressController = AnimationController(
        vsync: this,
        duration: widget.duration,
      );
    }

    // 4. Start auto-dismiss timer
    _startTimer();

    // 5. Measure Size and Register with AlertManager after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _reportSizeToManager();
    });

    // 6. Accessibility announcement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        final direction = widget.textDirection ??
            Directionality.maybeOf(context) ??
            TextDirection.ltr;
        final announcement = (widget.description != null &&
                widget.description!.trim().isNotEmpty)
            ? '${widget.title}. ${widget.description}'
            : widget.title;
        // ignore: deprecated_member_use
        SemanticsService.announce(announcement, direction);
      } catch (_) {}
    });
  }

  void _startTimer() {
    _dismissTimer?.cancel();
    _timerStartTime = DateTime.now();
    _dismissTimer = Timer(_remainingDuration, () {
      if (mounted && !_isClosing) {
        dismiss();
      }
    });
    if (widget.withProgressBar && _progressController != null) {
      _progressController!.forward();
    }
  }

  void _pauseTimer() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    if (_timerStartTime != null) {
      final elapsed = DateTime.now().difference(_timerStartTime!);
      _remainingDuration = _remainingDuration - elapsed;
      if (_remainingDuration.isNegative) {
        _remainingDuration = Duration.zero;
      }
    }
    if (widget.withProgressBar && _progressController != null) {
      _progressController!.stop(canceled: false);
    }
  }

  void _resumeTimer() {
    if (_remainingDuration > Duration.zero) {
      _startTimer();
    } else {
      dismiss();
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _dismissTimer = null;

    try {
      final direction = widget.textDirection ?? TextDirection.ltr;
      // ignore: deprecated_member_use
      SemanticsService.announce(t.alertClosedAnnouncement, direction);
    } catch (_) {}

    _transitionController.dispose();
    _curvedAnimation.dispose();
    _dragAnimController.dispose();
    _progressController?.dispose();
    super.dispose();
  }

  void _reportSizeToManager() {
    try {
      final context = _measureKey.currentContext;
      if (context == null) return;
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null || !renderBox.hasSize) return;

      final alertData = AlertData(
        size: renderBox.size,
        alignment: widget.alignment,
        fromTop: AlertManager.isTopAligned(widget.alignment),
        fromCenter: AlertManager.isCenterAligned(widget.alignment),
        fromBottom: AlertManager.isBottomAligned(widget.alignment),
      );

      _alertManager.registerAlert(widget.routeName, alertData);
    } catch (e) {
      debugPrint('SimpleAlertCard reportSize safe error: $e');
    }
  }

  /// Initiates the animated closing sequence.
  Future<void> dismiss({bool immediate = false}) async {
    if (_isClosing) return;
    _isClosing = true;

    _dismissTimer?.cancel();
    _dismissTimer = null;

    try {
      if (widget.withProgressBar && _progressController != null) {
        _progressController!.stop();
      }

      if (!immediate) {
        try {
          await _transitionController.reverse().timeout(
              widget.animatedOpacityDuration +
                  const Duration(milliseconds: 100));
        } catch (_) {}
      }
    } catch (_) {
    } finally {
      _alertManager.unregisterAlert(widget.routeName);
      widget.onDismissed();
    }
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_isClosing) return;
    try {
      if (mounted) {
        setState(() {
          _dragOffset += details.primaryDelta ?? 0.0;
        });
      }
    } catch (_) {}
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_isClosing) return;
    try {
      final mediaWidth = MediaQuery.maybeSizeOf(context)?.width ?? 400.0;
      final effectiveWidth = widget.width ?? mediaWidth;
      final threshold = effectiveWidth * 0.35;
      final velocity = details.primaryVelocity ?? 0.0;

      if (_dragOffset.abs() > threshold || velocity.abs() > 400.0) {
        _flingAndDismiss(velocity, effectiveWidth);
      } else {
        _springBack();
      }
    } catch (_) {
      _springBack();
    }
  }

  void _flingAndDismiss(double velocity, double cardWidth) {
    if (_isClosing) return;

    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (reduceMotion) {
      dismiss(immediate: true);
      return;
    }

    final direction = _dragOffset >= 0 ? 1.0 : -1.0;
    final target = direction * (cardWidth + 80.0);

    _dragAnimation = Tween<double>(
      begin: _dragOffset,
      end: target,
    ).animate(
      CurvedAnimation(
        parent: _dragAnimController,
        curve: Curves.easeOutQuad,
      ),
    );

    _dragAnimController.duration = const Duration(milliseconds: 140);
    _dragAnimController.forward(from: 0.0).then((_) {
      dismiss(immediate: true);
    }).catchError((_) {
      dismiss(immediate: true);
    });

    if (mounted) setState(() {});
  }

  void _springBack() {
    try {
      _dragAnimation = Tween<double>(
        begin: _dragOffset,
        end: 0.0,
      ).animate(
        CurvedAnimation(
          parent: _dragAnimController,
          curve: Curves.easeOutCubic,
        ),
      );

      _dragAnimController.duration = const Duration(milliseconds: 200);
      _dragAnimController.forward(from: 0.0).then((_) {
        if (mounted) {
          setState(() {
            _dragOffset = 0.0;
            _dragAnimation = null;
          });
        }
      }).catchError((_) {});
    } catch (_) {}
  }

  Color _resolveBackgroundColor(Brightness brightness) {
    if (widget.backgroundColor != null) return widget.backgroundColor!;
    final isLight = (brightness == Brightness.light);
    return switch (widget.type) {
      SimpleAlertType.normal => isLight
          ? const Color.fromRGBO(82, 82, 91, 1.0)
          : const Color.fromRGBO(228, 228, 231, 1.0),
      SimpleAlertType.success => isLight
          ? const Color.fromRGBO(22, 135, 80, 1.0)
          : const Color.fromRGBO(74, 210, 130, 1.0),
      SimpleAlertType.warning => isLight
          ? const Color.fromRGBO(217, 142, 11, 1.0)
          : const Color.fromRGBO(252, 196, 25, 1.0),
      SimpleAlertType.danger => isLight
          ? const Color.fromRGBO(190, 24, 58, 1.0)
          : const Color.fromRGBO(248, 105, 125, 1.0),
      SimpleAlertType.info => isLight
          ? const Color.fromRGBO(30, 72, 156, 1.0)
          : const Color.fromRGBO(120, 195, 252, 1.0),
    };
  }

  Color _resolveForegroundColor(Brightness brightness) {
    if (widget.foregroundColor != null) return widget.foregroundColor!;
    return brightness == Brightness.dark ? Colors.black : Colors.white;
  }

  BorderRadius _resolveBorderRadius() {
    if (widget.borderRadius != null) return widget.borderRadius!;
    final prefRadius = SimpleAlertPreferences().borderRadius;
    if (prefRadius != null) return prefRadius;
    final shape = widget.shape ?? SimpleAlertPreferences().shape;
    return switch (shape) {
      SimpleAlertShape.defaultRadius => BorderRadius.circular(BORDER_RADIUS),
      SimpleAlertShape.sharp => BorderRadius.zero,
      SimpleAlertShape.rounded => BorderRadius.circular(255.0),
    };
  }

  Icon _resolveIcon() {
    final icons = SimpleAlertPreferences().icons;
    final size = SimpleAlertPreferences().iconsSize;
    final (iconData, semanticLabel) = switch (widget.type) {
      SimpleAlertType.normal => (icons.normal, t.normalAlertIconDescription),
      SimpleAlertType.success => (icons.success, t.successAlertIconDescription),
      SimpleAlertType.warning => (icons.warning, t.warningAlertIconDescription),
      SimpleAlertType.danger => (icons.danger, t.dangerAlertIconDescription),
      SimpleAlertType.info => (icons.info, t.informationAlertIconDescription),
    };
    return Icon(iconData, size: size, semanticLabel: semanticLabel);
  }

  double _resolveAlertWidth(double screenWidth) {
    if (widget.width != null && widget.width! > 0) return widget.width!;
    try {
      final prefWidth = SimpleAlertPreferences().getWidth?.call();
      if (prefWidth != null && prefWidth > 0) return prefWidth;
    } catch (_) {}
    return screenWidth;
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (_lastOrientation != orientation) {
          _lastOrientation = orientation;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) _reportSizeToManager();
          });
        }

        final mediaSize =
            MediaQuery.maybeSizeOf(context) ?? const Size(400, 800);
        final screenWidth = mediaSize.width;
        final screenHeight = mediaSize.height;
        final alertWidth = _resolveAlertWidth(screenWidth);
        final keyboardBottom =
            MediaQuery.maybeViewInsetsOf(context)?.bottom ?? 0.0;
        final theme = widget.themeData ?? Theme.of(context);
        final brightness = theme.brightness;
        final backgroundColor = _resolveBackgroundColor(brightness);
        final foregroundColor = _resolveForegroundColor(brightness);
        final borderRadius = _resolveBorderRadius();

        final resolvedDirection = widget.textDirection ??
            Directionality.maybeOf(context) ??
            SimpleAlertPreferences().textDirection ??
            TextDirection.ltr;

        return ValueListenableBuilder<Map<String, AlertData>>(
          valueListenable: _alertManager.displayedAlerts,
          builder: (context, displayedAlerts, _) {
            final offsetY = _alertManager.calculateVerticalOffset(
              routeName: widget.routeName,
              alignment: widget.alignment,
              orientation: orientation,
              screenHeight: screenHeight,
            );

            return SafeArea(
              child: Stack(
                alignment: widget.alignment,
                fit: StackFit.expand,
                children: [
                  AnimatedPositioned(
                    duration: DEFAULT_REPOSITION_DURATION,
                    curve: DEFAULT_ALERT_CURVE,
                    width: alertWidth,
                    top: (AlertManager.isTopAligned(widget.alignment) ||
                            AlertManager.isCenterAligned(widget.alignment))
                        ? offsetY
                        : null,
                    bottom: AlertManager.isBottomAligned(widget.alignment)
                        ? (offsetY + keyboardBottom)
                        : null,
                    child: FocusScope(
                      canRequestFocus: false,
                      child: Semantics(
                        container: true,
                        liveRegion: true,
                        label: widget.description != null &&
                                widget.description!.trim().isNotEmpty
                            ? '${t.alertSemanticLabel(title: widget.title)}. ${widget.description}'
                            : t.alertSemanticLabel(title: widget.title),
                        hint: AlertA11yUtils.getSemanticHint(
                          closeOnPress: widget.closeOnPress,
                          withProgressBar: widget.withProgressBar,
                          loading: widget.loading,
                        ),
                        child: Directionality(
                          textDirection: resolvedDirection,
                          child: Theme(
                            data: theme.copyWith(
                              iconTheme: theme.iconTheme.copyWith(
                                color: (SimpleAlertPreferences().iconsColor ??
                                    foregroundColor),
                              ),
                              iconButtonTheme: IconButtonThemeData(
                                style: ButtonStyle(
                                  foregroundColor:
                                      WidgetStatePropertyAll<Color>(
                                    (SimpleAlertPreferences().iconsColor ??
                                        foregroundColor),
                                  ),
                                ),
                              ),
                            ),
                            child: _buildCardBody(
                              alertWidth: alertWidth,
                              backgroundColor: backgroundColor,
                              foregroundColor: foregroundColor,
                              borderRadius: borderRadius,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCardBody({
    required double alertWidth,
    required Color backgroundColor,
    required Color foregroundColor,
    required BorderRadius borderRadius,
  }) {
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    // Direct card entrance transitions
    Widget card = AnimatedBuilder(
      animation: _dragAnimController,
      builder: (context, child) {
        final currentOffset =
            _dragAnimation != null ? _dragAnimation!.value : _dragOffset;
        final opacity =
            (1.0 - (currentOffset.abs() / (alertWidth * 1.2))).clamp(0.0, 1.0);

        return Transform.translate(
          offset: Offset(currentOffset, 0.0),
          child: Opacity(
            opacity: opacity,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          if (widget.closeOnPress && !widget.withProgressBar) {
            dismiss();
          }
        },
        onTapDown: widget.withProgressBar ? (_) => _pauseTimer() : null,
        onTapUp: widget.withProgressBar ? (_) => _resumeTimer() : null,
        onTapCancel: widget.withProgressBar ? () => _resumeTimer() : null,
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        child: Container(
          key: _measureKey,
          margin: const EdgeInsets.symmetric(vertical: ALERT_VERTICAL_SPACING),
          padding:
              const EdgeInsets.symmetric(horizontal: ALERT_HORIZONTAL_PADDING),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(
                color: foregroundColor.withValues(alpha: 0.14),
                width: 1.0,
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.alphaBlend(
                    foregroundColor.withValues(alpha: 0.05),
                    backgroundColor,
                  ),
                  backgroundColor,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: backgroundColor.withValues(alpha: 0.28),
                  blurRadius: 18.0,
                  offset: const Offset(0, 8),
                  spreadRadius: -2.0,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6.0,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: borderRadius,
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.all(ALERT_CONTENT_PADDING),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: (widget.description != null &&
                                widget.description!.trim().isNotEmpty)
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.center,
                        children: [
                          SimpleAlertLeadingIcon(
                            loading: widget.loading,
                            foregroundColor: foregroundColor,
                            getBackgroundColor: () => backgroundColor,
                            getIcon: _resolveIcon,
                            iconsSize: SimpleAlertPreferences().iconsSize,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: SimpleAlertTextContent(
                                    title: widget.title,
                                    description: widget.description,
                                    textDirection: widget.textDirection,
                                    foregroundColor: foregroundColor,
                                    centerContent: widget.centerContent,
                                  ),
                                ),
                                SimpleAlertActionsSection(
                                  actions: widget.actions,
                                  withClose: widget.withClose,
                                  onClosePressed: () => dismiss(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (widget.withProgressBar && _progressController != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: AnimatedBuilder(
                            animation: _progressController!,
                            builder: (context, _) {
                              final fraction =
                                  (1.0 - _progressController!.value)
                                      .clamp(0.0, 1.0);
                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  final totalWidth = constraints.maxWidth;
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(4.0),
                                    child: Container(
                                      width: totalWidth,
                                      height: 3.5,
                                      color: foregroundColor.withValues(
                                          alpha: 0.18),
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Container(
                                        width: totalWidth * fraction,
                                        height: 3.5,
                                        decoration: BoxDecoration(
                                          color: foregroundColor.withValues(
                                              alpha: 0.90),
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (reduceMotion) {
      return card;
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: card,
        ),
      ),
    );
  }
}

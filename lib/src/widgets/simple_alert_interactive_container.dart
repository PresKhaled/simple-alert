import 'package:flutter/material.dart';

import '../../i18n/translations.g.dart';
import '../misc/constants.dart';
import 'simple_alert_inner_content.dart';

/// A widget that provides the interactive container for the alert, including gestures,
/// swipe-to-dismiss tracking, and semantic labels.
class SimpleAlertInteractiveContainer extends StatefulWidget {
  /// Creates a [SimpleAlertInteractiveContainer] instance.
  const SimpleAlertInteractiveContainer({
    super.key,
    required this.routeName,
    required this.alertWidth,
    required this.title,
    this.description,
    this.textDirection,
    required this.withProgressBar,
    required this.closeOnPress,
    required this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    required this.getBorderRadius,
    required this.getBackgroundColor,
    // Properties for SimpleAlertInnerContent
    required this.loading,
    required this.centerContent,
    this.actions,
    required this.withClose,
    required this.onWidthAnimationControllerCreated,
    required this.resolvedDuration,
    required this.getForegroundColor,
    required this.getIcon,
    required this.onClosePressed,
    this.onDismissedImmediate,
  });

  /// The unique route name for this specific alert instance.
  final String routeName;

  /// The calculated width of the alert.
  final double alertWidth;

  /// The main title text displayed in the alert.
  final String title;

  /// An optional detailed description text for the alert.
  final String? description;

  /// The explicit or resolved text direction for the alert.
  final TextDirection? textDirection;

  /// If true, a progress bar indicating the remaining duration will be displayed.
  final bool withProgressBar;

  /// If true, the alert will close when pressed, unless [withProgressBar] is true.
  final bool closeOnPress;

  /// Callback function for a tap gesture on the alert.
  final VoidCallback onTap;

  /// Callback function for a tap down gesture on the alert.
  final GestureTapDownCallback? onTapDown;

  /// Callback function for a tap up gesture on the alert.
  final GestureTapUpCallback? onTapUp;

  /// Callback function for a tap cancel gesture on the alert.
  final GestureTapCancelCallback? onTapCancel;

  /// Callback function to get the border radius for the alert's container.
  final BorderRadius Function() getBorderRadius;

  /// Callback function to get the background color of the alert.
  final Color Function() getBackgroundColor;

  // Properties to pass down to SimpleAlertInnerContent
  final bool loading;
  final bool centerContent;
  final List<IconButton>? actions;
  final bool withClose;
  final ValueChanged<AnimationController> onWidthAnimationControllerCreated;
  final Duration resolvedDuration;
  final Color Function() getForegroundColor;
  final Icon Function() getIcon;
  final VoidCallback onClosePressed;

  /// Optional callback invoked when the alert is swiped off-screen for immediate dismissal.
  final VoidCallback? onDismissedImmediate;

  @override
  State<SimpleAlertInteractiveContainer> createState() =>
      _SimpleAlertInteractiveContainerState();
}

class _SimpleAlertInteractiveContainerState
    extends State<SimpleAlertInteractiveContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _dragAnimController;
  Animation<double>? _dragAnimation;
  double _dragOffset = 0.0;
  bool _isDismissed = false;

  @override
  void initState() {
    super.initState();
    _dragAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    try {
      _dragAnimController.stop();
      _dragAnimController.dispose();
    } catch (_) {}
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (_isDismissed) return;
    try {
      if (mounted) {
        setState(() {
          _dragOffset += details.primaryDelta ?? 0.0;
        });
      }
    } catch (_) {}
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_isDismissed) return;
    try {
      final threshold = widget.alertWidth * 0.35;
      final velocity = details.primaryVelocity ?? 0.0;

      // Check if user swiped past threshold or flicked with sufficient velocity
      if (_dragOffset.abs() > threshold || velocity.abs() > 400.0) {
        _dismiss(velocity);
      } else {
        _springBack();
      }
    } catch (e) {
      debugPrint('SimpleAlert drag end safe error: $e');
      _springBack();
    }
  }

  void _dismiss(double velocity) {
    if (_isDismissed) return;
    _isDismissed = true;

    try {
      final direction = _dragOffset >= 0 ? 1.0 : -1.0;
      final target = direction * (widget.alertWidth + 60.0);

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
        if (mounted) {
          try {
            if (widget.onDismissedImmediate != null) {
              widget.onDismissedImmediate!();
            } else {
              widget.onClosePressed();
            }
          } catch (e) {
            debugPrint('SimpleAlert dismiss callback safe error: $e');
          }
        }
      }).catchError((e) {
        debugPrint('SimpleAlert dismiss animation safe error: $e');
        try {
          widget.onDismissedImmediate?.call();
        } catch (_) {}
      });
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint('SimpleAlert _dismiss safe error: $e');
      try {
        widget.onDismissedImmediate?.call();
      } catch (_) {}
    }
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

  @override
  Widget build(BuildContext context) {
    try {
      final backgroundColor = widget.getBackgroundColor();
      final foregroundColor = widget.getForegroundColor();
      final borderRadius = widget.getBorderRadius();

      return AnimatedBuilder(
        animation: _dragAnimController,
        builder: (context, child) {
          final currentOffset =
              _dragAnimation != null ? _dragAnimation!.value : _dragOffset;
          final opacity = (1.0 -
                  (currentOffset.abs() / (widget.alertWidth * 1.2)))
              .clamp(0.0, 1.0);

          return Transform.translate(
            offset: Offset(currentOffset, 0.0),
            child: Opacity(
              opacity: opacity,
              child: child,
            ),
          );
        },
        child: Semantics(
          container: true,
          liveRegion: true, // Announce changes to screen readers.
          label: t.alertSemanticLabel(
              title: widget.title), // Semantic label for the alert.
          hint: (widget.description ?? ''), // Semantic hint.
          child: GestureDetector(
            onTap: widget.onTap,
            onTapDown: widget.withProgressBar ? widget.onTapDown : null,
            onTapUp: widget.withProgressBar ? widget.onTapUp : null,
            onTapCancel: widget.withProgressBar ? widget.onTapCancel : null,
            onHorizontalDragUpdate: _onHorizontalDragUpdate,
            onHorizontalDragEnd: _onHorizontalDragEnd,
            child: Container(
              margin:
                  const EdgeInsets.symmetric(vertical: ALERT_VERTICAL_SPACING),
              padding: const EdgeInsets.symmetric(
                  horizontal: ALERT_HORIZONTAL_PADDING),
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
                    // Key directional shadow
                    BoxShadow(
                      color: backgroundColor.withValues(alpha: 0.28),
                      blurRadius: 18.0,
                      offset: const Offset(0, 8),
                      spreadRadius: -2.0,
                    ),
                    // Ambient grounding shadow
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
                    color: Colors.transparent, // Let gradient shine through
                    child: Padding(
                      padding: const EdgeInsets.all(ALERT_CONTENT_PADDING),
                      child: SimpleAlertInnerContent(
                        alertWidth: widget.alertWidth,
                        loading: widget.loading,
                        title: widget.title,
                        description: widget.description,
                        textDirection: widget.textDirection,
                        centerContent: widget.centerContent,
                        actions: widget.actions,
                        withClose: widget.withClose,
                        withProgressBar: widget.withProgressBar,
                        onWidthAnimationControllerCreated:
                            widget.onWidthAnimationControllerCreated,
                        resolvedDuration: widget.resolvedDuration,
                        getForegroundColor: widget.getForegroundColor,
                        getBackgroundColor: widget.getBackgroundColor,
                        getIcon: widget.getIcon,
                        onClosePressed: widget.onClosePressed,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      debugPrint('SimpleAlertInteractiveContainer safe error: $e');
      return const SizedBox.shrink();
    }
  }
}

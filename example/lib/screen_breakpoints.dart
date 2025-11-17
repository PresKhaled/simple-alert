import 'package:flutter/material.dart' show BuildContext, MediaQuery;

abstract mixin class ScreenBreakpoints {
  final double _mediaExtraSmall = 320.0,
      _mediaSmall = 480.0, // ~ (35% of devices in 2020).
      _mediaMedium = 768.0,
      _mediaLarge = 1024.0,
      _mediaExtraLarge = 1280.0;

  String getCurrentBreakpointName(double width) {
    // final double contextWidth = (MediaQuery.of(context).size.width);

    if (width <= _mediaExtraSmall) {
      return 'xs';
    }

    if (width <= _mediaSmall) {
      return 'sm';
    }

    if (width <= _mediaMedium) {
      return 'md';
    }

    if (width <= _mediaLarge) {
      return 'lg';
    }

    if (width <= _mediaExtraLarge) {
      return 'xlg';
    }

    return 'xxlg';
  }

  // Get the appropriate space for the content to be appropriate and readable.
  double getMainContentWidth(BuildContext context) {
    final double contextWidth = (MediaQuery.of(context).size.width - MediaQuery.of(context).systemGestureInsets.horizontal);
    final String currentBreakpointName = getCurrentBreakpointName(contextWidth);

    switch (currentBreakpointName) {
      case 'md':
      case 'lg':
        return (contextWidth / 1.5);

      case 'xlg':
        return (contextWidth / 2);

      case 'xxlg':
        return (contextWidth / 3);

      case 'xs':
      case 'sm':
      default:
        return contextWidth;
    }
  }
}

import 'package:flutter/material.dart' show IconData, Icons;

class SimpleAlertIcons {
  final IconData normal, success, info, warning, danger, close;

  const SimpleAlertIcons({
    this.normal = Icons.message_outlined,
    this.info = Icons.info_outline_rounded,
    this.success = Icons.check_circle_outline,
    this.warning = Icons.warning_amber_rounded,
    this.danger = Icons.error_outline_rounded,
    this.close = Icons.close_rounded,
  });
}

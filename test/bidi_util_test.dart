import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_alert/simple_alert.dart';

void main() {
  group('SimpleAlertBidiUtil Tests', () {
    test('containsRtl identifies Arabic text correctly', () {
      expect(SimpleAlertBidiUtil.containsRtl('مرحبا بك'), isTrue);
      expect(SimpleAlertBidiUtil.containsRtl('Hello world'), isFalse);
      expect(SimpleAlertBidiUtil.containsRtl('Hello مرحبا'), isTrue);
      expect(SimpleAlertBidiUtil.containsRtl('/path/to/file.epub'), isFalse);
    });

    test('detectDirection detects correct primary script', () {
      expect(SimpleAlertBidiUtil.detectDirection('تنبيه هام'), equals(TextDirection.rtl));
      expect(SimpleAlertBidiUtil.detectDirection('Warning: something broke'), equals(TextDirection.ltr));
      expect(SimpleAlertBidiUtil.detectDirection('12345'), equals(TextDirection.ltr));
    });

    test('resolveDirection respects explicit override', () {
      expect(
        SimpleAlertBidiUtil.resolveDirection(
          text: 'مرحبا',
          explicitDirection: TextDirection.ltr,
        ),
        equals(TextDirection.ltr),
      );
      expect(
        SimpleAlertBidiUtil.resolveDirection(
          text: 'English title',
          explicitDirection: TextDirection.rtl,
        ),
        equals(TextDirection.rtl),
      );
    });

    test('isolateBiDi isolates file paths and extensions within Arabic text', () {
      const arabicWithPath = 'تعذر فتح الملف /storage/emulated/0/Books/read.epub للتعديل';
      final isolated = SimpleAlertBidiUtil.isolateBiDi(arabicWithPath);

      expect(isolated, contains(SimpleAlertBidiUtil.lri));
      expect(isolated, contains(SimpleAlertBidiUtil.pdi));
      expect(isolated, contains('${SimpleAlertBidiUtil.lri}/storage/emulated/0/Books/read.epub${SimpleAlertBidiUtil.pdi}'));
    });

    test('isolateBiDi does not alter purely LTR text without RTL characters', () {
      const ltr = 'Error 404: /api/v1/users not found';
      expect(SimpleAlertBidiUtil.isolateBiDi(ltr), equals(ltr));
    });
  });
}

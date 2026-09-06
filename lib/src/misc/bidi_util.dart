import 'package:flutter/material.dart';

/// A utility class for handling bidirectional (BiDi) text, smart script direction
/// detection, and isolating file paths, URLs, and Latin identifiers in RTL contexts.
class SimpleAlertBidiUtil {
  SimpleAlertBidiUtil._();

  /// Unicode directional formatting characters (Unicode Standard Annex #9).
  static const String lri = '\u2066'; // Left-to-Right Isolate
  static const String rli = '\u2067'; // Right-to-Left Isolate
  static const String fsi = '\u2068'; // First Strong Isolate
  static const String pdi = '\u2069'; // Pop Directional Isolate
  static const String lrm = '\u200E'; // Left-to-Right Mark
  static const String rlm = '\u200F'; // Right-to-Left Mark

  /// Regex pattern matching Arabic-script RTL languages (Arabic, Persian, Urdu, etc.).
  static final RegExp _rtlRegExp = RegExp(
    r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
  );

  /// Regex pattern matching file paths, URLs, and Latin-based identifiers with extensions.
  /// Examples: `/path/to/book.epub`, `C:\Files\doc.pdf`, `https://example.com`, `package.json`
  static final RegExp _ltrIsolatedPattern = RegExp(
    r'(?:[a-zA-Z]:\\|\/|\bhttps?:\/\/|\bwww\.)[^\s\u0600-\u06FF]+|[a-zA-Z0-9_\-\.]+\.[a-zA-Z0-9]{2,5}\b|[a-zA-Z0-9_\-\/\\:]{3,}',
  );

  /// Checks whether the [text] contains any RTL characters.
  static bool containsRtl(String text) {
    return _rtlRegExp.hasMatch(text);
  }

  /// Determines the primary direction of the text based on its first strong character.
  ///
  /// Returns [TextDirection.rtl] if the first strong directional character is RTL,
  /// otherwise returns [TextDirection.ltr].
  static TextDirection detectDirection(String text) {
    for (final char in text.runes) {
      final str = String.fromCharCode(char);
      if (_rtlRegExp.hasMatch(str)) {
        return TextDirection.rtl;
      }
      // Check for Latin/strong LTR characters
      if (RegExp(r'[a-zA-Z]').hasMatch(str)) {
        return TextDirection.ltr;
      }
    }
    return TextDirection.ltr;
  }

  /// Resolves the effective [TextDirection] considering:
  /// 1. An explicit override [explicitDirection].
  /// 2. Automatic detection from [text] if provided.
  /// 3. Contextual fallback [fallbackDirection].
  static TextDirection resolveDirection({
    String? text,
    TextDirection? explicitDirection,
    TextDirection? fallbackDirection,
  }) {
    if (explicitDirection != null) {
      return explicitDirection;
    }
    if (text != null && text.trim().isNotEmpty) {
      return detectDirection(text);
    }
    return fallbackDirection ?? TextDirection.ltr;
  }

  /// Isolates LTR tokens (such as file paths, URLs, and English book/file names)
  /// within an RTL context so that slashes, colons, dots, and file extensions
  /// are not reversed by the Unicode Bidirectional Algorithm.
  ///
  /// If the text is purely LTR, it is returned unchanged.
  static String isolateBiDi(String text, {TextDirection? baseDirection}) {
    if (text.isEmpty) return text;

    final effectiveDir = baseDirection ?? detectDirection(text);
    if (effectiveDir == TextDirection.ltr && !containsRtl(text)) {
      return text;
    }

    // Replace LTR paths and technical identifiers with isolated LTR blocks
    return text.replaceAllMapped(_ltrIsolatedPattern, (match) {
      final matchStr = match.group(0)!;
      // Do not re-wrap if already isolated
      if (matchStr.startsWith(lri) && matchStr.endsWith(pdi)) {
        return matchStr;
      }
      return '$lri$matchStr$pdi';
    });
  }
}

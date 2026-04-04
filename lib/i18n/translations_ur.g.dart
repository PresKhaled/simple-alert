///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsUr extends Translations {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsUr(
      {Map<String, Node>? overrides,
      PluralResolver? cardinalResolver,
      PluralResolver? ordinalResolver,
      TranslationMetadata<AppLocale, Translations>? meta})
      : assert(overrides == null,
            'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ??
            TranslationMetadata(
              locale: AppLocale.ur,
              overrides: overrides ?? {},
              cardinalResolver: cardinalResolver,
              ordinalResolver: ordinalResolver,
            ),
        super(
            cardinalResolver: cardinalResolver,
            ordinalResolver: ordinalResolver);

  /// Metadata for the translations of <ur>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  late final TranslationsUr _root = this; // ignore: unused_field

  @override
  TranslationsUr $copyWith(
          {TranslationMetadata<AppLocale, Translations>? meta}) =>
      TranslationsUr(meta: meta ?? this.$meta);

  // Translations

  /// ایک انتباہ کے لیے معنیاتی لیبل، جس میں اس کا عنوان شامل ہے۔
  @override
  String alertSemanticLabel({required String title}) => 'انتباہ: ${title}';

  /// لوڈنگ اشارے کے لیے معنیاتی لیبل۔
  @override
  String get loadingIndicatorSemanticLabel => 'لوڈ ہو رہا ہے';

  /// الرٹ کے لیے باقی وقت کی نشاندہی کرنے والی پیشرفت بار کے لیے معنیاتی لیبل۔
  @override
  String get alertTimerSemanticLabel => 'انتباہ کا ٹائمر';

  /// ایک نیا انتباہ دکھائے جانے پر رسائی کے آلات کے لیے اعلان۔
  @override
  String get newAlertDisplayedAnnouncement => 'ایک نیا انتباہ دکھایا گیا ہے۔';

  /// انتباہ بند ہونے پر رسائی کے آلات کے لیے اعلان۔
  @override
  String get alertClosedAnnouncement => 'انتباہ بند کر دیا گیا ہے۔';

  /// معیاری ڈیزائن کے ساتھ ایک عمومی انتباہ کی قسم، جو مختلف معلوماتی پیغامات کے لیے موزوں ہے۔
  @override
  String get generalAlertType => 'عام انتباہ';

  /// معلومات پہنچانے والا ایک انتباہی قسم، جو ایک مخصوص ڈیزائن اور معنیاتی مطلب سے ممتاز ہے۔
  @override
  String get informationAlertType => 'معلوماتی انتباہ';

  /// کامیاب آپریشن کی نشاندہی کرنے والا ایک انتباہی قسم، جو ایک مخصوص ڈیزائن اور معنیاتی مطلب سے ممتاز ہے۔
  @override
  String get successAlertType => 'کامیابی کا انتباہ';

  /// ایک تنبیہ کی نشاندہی کرنے والا انتباہی قسم، جو ایک مخصوص ڈیزائن اور معنیاتی مطلب سے ممتاز ہے۔
  @override
  String get warningAlertType => 'تنبیہی انتباہ';

  /// ایک اہم خطرے یا غلطی کی نشاندہی کرنے والا انتباہی قسم، جو ایک مخصوص ڈیزائن اور معنیاتی مطلب سے ممتاز ہے۔
  @override
  String get dangerAlertType => 'خطرناک انتباہ';

  /// عام انتباہ کی نمائندگی کرنے والے آئیکن کی تفصیل۔
  @override
  String get normalAlertIconDescription => 'عام انتباہ کا آئیکن';

  /// معلوماتی انتباہ کی نمائندگی کرنے والے آئیکن کی تفصیل۔
  @override
  String get informationAlertIconDescription => 'معلوماتی انتباہ کا آئیکن';

  /// کامیابی کے انتباہ کی نمائندگی کرنے والے آئیکن کی تفصیل۔
  @override
  String get successAlertIconDescription => 'کامیابی کے انتباہ کا آئیکن';

  /// تنبیہی انتباہ کی نمائندگی کرنے والے آئیکن کی تفصیل۔
  @override
  String get warningAlertIconDescription => 'تنبیہی انتباہ کا آئیکن';

  /// خطرناک انتباہ کی نمائندگی کرنے والے آئیکن کی تفصیل۔
  @override
  String get dangerAlertIconDescription => 'خطرناک انتباہ کا آئیکن';

  /// معنیاتی اشارہ جو یہ ظاہر کرتا ہے کہ مواد فی الحال لوڈ ہو رہا ہے۔
  @override
  String get loadingSemanticHint => 'لوڈ ہو رہا ہے';

  /// معنیاتی اشارہ جو صارف کو الٹی گنتی روکنے کے لیے کسی عنصر کو دبانے اور تھامے رکھنے کی ہدایت کرتا ہے۔
  @override
  String get pressAndHoldToPauseCountdownSemanticHint =>
      'الٹی گنتی کو روکنے کے لیے دبائے رکھیں اور تھامے رکھیں۔';

  /// معنیاتی اشارہ جو صارف کو کسی عنصر کو بند کرنے کے لیے کلک کرنے کی ہدایت کرتا ہے۔
  @override
  String get clickToCloseSemanticHint => 'بند کرنے کے لیے کلک کریں';

  /// ایک بٹن کے لیے ٹول ٹپ متن جو ایک ڈائیلاگ یا انٹرفیس عنصر کو بند کرتا ہے۔
  @override
  String get closeButtonTooltip => 'بند کریں';
}

///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsAr extends Translations {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsAr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
      : assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ??
            TranslationMetadata(
              locale: AppLocale.ar,
              overrides: overrides ?? {},
              cardinalResolver: cardinalResolver,
              ordinalResolver: ordinalResolver,
            ),
        super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

  /// Metadata for the translations of <ar>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  late final TranslationsAr _root = this; // ignore: unused_field

  @override
  TranslationsAr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsAr(meta: meta ?? this.$meta);

  // Translations

  /// تسمية دلالية لتنبيه، تتضمن عنوانه.
  @override
  String alertSemanticLabel({required String title}) => 'تنبيه: ${title}';

  /// تسمية دلالية لمؤشر التحميل.
  @override
  String get loadingIndicatorSemanticLabel => 'جارٍ التحميل';

  /// تسمية دلالية لشريط التقدم الذي يشير إلى الوقت المتبقي للتنبيه.
  @override
  String get alertTimerSemanticLabel => 'مؤقت التنبيه';

  /// إعلان لأدوات الوصول عند عرض تنبيه جديد.
  @override
  String get newAlertDisplayedAnnouncement => 'تم عرض تنبيه جديد.';

  /// إعلان لأدوات الوصول عند إغلاق التنبيه.
  @override
  String get alertClosedAnnouncement => 'تم إغلاق التنبيه.';

  /// نوع تنبيه عام بتصميم قياسي، مناسب لرسائل معلوماتية متنوعة.
  @override
  String get generalAlertType => 'تنبيه عادي';

  /// نوع تنبيه ينقل معلومات، يتميز بتصميم ومعنى دلالي محدد.
  @override
  String get informationAlertType => 'تنبيه معلوماتي';

  /// نوع تنبيه يشير إلى عملية ناجحة، يتميز بتصميم ومعنى دلالي محدد.
  @override
  String get successAlertType => 'تنبيه نجاح';

  /// نوع تنبيه يشير إلى تحذير، يتميز بتصميم ومعنى دلالي محدد.
  @override
  String get warningAlertType => 'تنبيه تحذير';

  /// نوع تنبيه يشير إلى خطر أو خطأ حرج، يتميز بتصميم ومعنى دلالي محدد.
  @override
  String get dangerAlertType => 'تنبيه خطر';

  /// وصف لأيقونة تمثل تنبيهًا عاديًا.
  @override
  String get normalAlertIconDescription => 'أيقونة تنبيه عادي';

  /// وصف لأيقونة تمثل تنبيهًا معلوماتيًا.
  @override
  String get informationAlertIconDescription => 'أيقونة تنبيه معلوماتي';

  /// وصف لأيقونة تمثل تنبيه نجاح.
  @override
  String get successAlertIconDescription => 'أيقونة تنبيه نجاح';

  /// وصف لأيقونة تمثل تنبيه تحذير.
  @override
  String get warningAlertIconDescription => 'أيقونة تنبيه تحذير';

  /// وصف لأيقونة تمثل تنبيه خطر.
  @override
  String get dangerAlertIconDescription => 'أيقونة تنبيه خطر';

  /// تلميح دلالي يشير إلى أن المحتوى قيد التحميل حاليًا.
  @override
  String get loadingSemanticHint => 'جارٍ التحميل';

  /// تلميح دلالي يوجه المستخدم بالضغط مع الاستمرار على عنصر لإيقاف العد التنازلي مؤقتًا.
  @override
  String get pressAndHoldToPauseCountdownSemanticHint => 'اضغط مع الاستمرار لإيقاف العد التنازلي مؤقتًا.';

  /// تلميح دلالي يوجه المستخدم بالنقر على عنصر لإغلاقه.
  @override
  String get clickToCloseSemanticHint => 'انقر للإغلاق';

  /// نص تلميح لزر يقوم بإغلاق مربع حوار أو عنصر واجهة.
  @override
  String get closeButtonTooltip => 'إغلاق';
}

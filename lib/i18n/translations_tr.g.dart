///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsTr extends Translations {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsTr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
      : assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ??
            TranslationMetadata(
              locale: AppLocale.tr,
              overrides: overrides ?? {},
              cardinalResolver: cardinalResolver,
              ordinalResolver: ordinalResolver,
            ),
        super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

  /// Metadata for the translations of <tr>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  late final TranslationsTr _root = this; // ignore: unused_field

  @override
  TranslationsTr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsTr(meta: meta ?? this.$meta);

  // Translations

  /// Başlığı dahil olmak üzere bir uyarı için anlamsal etiket.
  @override
  String alertSemanticLabel({required String title}) => 'Uyarı: ${title}';

  /// Bir yükleme göstergesi için anlamsal etiket.
  @override
  String get loadingIndicatorSemanticLabel => 'Yükleniyor';

  /// Bir uyarı için kalan süreyi gösteren ilerleme çubuğu için anlamsal etiket.
  @override
  String get alertTimerSemanticLabel => 'Uyarı zamanlayıcısı';

  /// Yeni bir uyarı görüntülendiğinde erişilebilirlik araçları için duyuru.
  @override
  String get newAlertDisplayedAnnouncement => 'Yeni bir uyarı görüntülendi.';

  /// Bir uyarı kapatıldığında erişilebilirlik araçları için duyuru.
  @override
  String get alertClosedAnnouncement => 'Uyarı kapatıldı.';

  /// Çeşitli bilgilendirme mesajları için uygun, standart tasarıma sahip genel bir uyarı türü.
  @override
  String get generalAlertType => 'Normal uyarı';

  /// Belirli bir tasarım ve anlamsal anlamla ayırt edilen, bilgi ileten bir uyarı türü.
  @override
  String get informationAlertType => 'Bilgi uyarısı';

  /// Başarılı bir işlemi gösteren, belirli bir tasarım ve anlamsal anlamla ayırt edilen bir uyarı türü.
  @override
  String get successAlertType => 'Başarı uyarısı';

  /// Bir uyarıyı gösteren, belirli bir tasarım ve anlamsal anlamla ayırt edilen bir uyarı türü.
  @override
  String get warningAlertType => 'Uyarı uyarısı';

  /// Kritik bir tehlikeyi veya hatayı gösteren, belirli bir tasarım ve anlamsal anlamla ayırt edilen bir uyarı türü.
  @override
  String get dangerAlertType => 'Tehlike uyarısı';

  /// Normal bir uyarıyı temsil eden simgenin açıklaması.
  @override
  String get normalAlertIconDescription => 'Normal uyarı simgesi';

  /// Bilgi uyarısını temsil eden simgenin açıklaması.
  @override
  String get informationAlertIconDescription => 'Bilgi uyarısı simgesi';

  /// Başarı uyarısını temsil eden simgenin açıklaması.
  @override
  String get successAlertIconDescription => 'Başarı uyarısı simgesi';

  /// Uyarı uyarısını temsil eden simgenin açıklaması.
  @override
  String get warningAlertIconDescription => 'Uyarı uyarısı simgesi';

  /// Tehlike uyarısını temsil eden simgenin açıklaması.
  @override
  String get dangerAlertIconDescription => 'Tehlike uyarısı simgesi';

  /// İçeriğin şu anda yüklendiğini gösteren anlamsal ipucu.
  @override
  String get loadingSemanticHint => 'Yükleniyor';

  /// Kullanıcıya geri sayımı duraklatmak için bir öğeye basılı tutmasını söyleyen anlamsal ipucu.
  @override
  String get pressAndHoldToPauseCountdownSemanticHint => 'Geri sayımı duraklatmak için basılı tutun.';

  /// Kullanıcıya bir öğeyi kapatmak için tıklamasını söyleyen anlamsal ipucu.
  @override
  String get clickToCloseSemanticHint => 'Kapatmak için tıklayın';

  /// Bir iletişim kutusunu veya arayüz öğesini kapatan bir düğme için araç ipucu metni.
  @override
  String get closeButtonTooltip => 'Kapat';
}

///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element

class Translations implements BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  Translations(
      {Map<String, Node>? overrides,
      PluralResolver? cardinalResolver,
      PluralResolver? ordinalResolver,
      TranslationMetadata<AppLocale, Translations>? meta})
      : assert(overrides == null,
            'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ??
            TranslationMetadata(
              locale: AppLocale.en,
              overrides: overrides ?? {},
              cardinalResolver: cardinalResolver,
              ordinalResolver: ordinalResolver,
            );

  /// Metadata for the translations of <en>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  late final Translations _root = this; // ignore: unused_field

  Translations $copyWith(
          {TranslationMetadata<AppLocale, Translations>? meta}) =>
      Translations(meta: meta ?? this.$meta);

  // Translations

  /// Semantic label for an alert, including its title.
  ///
  /// en: 'Alert: {title: String}'
  ///
  /// ar: 'تنبيه: {title: String}'
  ///
  /// ur: 'انتباہ: {title: String}'
  ///
  /// id: 'Peringatan: {title: String}'
  ///
  /// tr: 'Uyarı: {title: String}'
  ///
  /// pt: 'Alerta: {title: String}'
  String alertSemanticLabel({required String title}) => 'Alert: ${title}';

  /// Semantic label for a loading indicator.
  ///
  /// en: 'Loading'
  ///
  /// ar: 'جارٍ التحميل'
  ///
  /// ur: 'لوڈ ہو رہا ہے'
  ///
  /// id: 'Memuat'
  ///
  /// tr: 'Yükleniyor'
  ///
  /// pt: 'Carregando'
  String get loadingIndicatorSemanticLabel => 'Loading';

  /// Semantic label for the progress bar indicating the remaining time for an alert.
  ///
  /// en: 'Alert timer'
  ///
  /// ar: 'مؤقت التنبيه'
  ///
  /// ur: 'انتباہ کا ٹائمر'
  ///
  /// id: 'Waktu peringatan'
  ///
  /// tr: 'Uyarı zamanlayıcısı'
  ///
  /// pt: 'Temporizador de alerta'
  String get alertTimerSemanticLabel => 'Alert timer';

  /// Announcement for accessibility tools when a new alert is displayed.
  ///
  /// en: 'A new alert has been displayed.'
  ///
  /// ar: 'تم عرض تنبيه جديد.'
  ///
  /// ur: 'ایک نیا انتباہ دکھایا گیا ہے۔'
  ///
  /// id: 'Peringatan baru telah ditampilkan.'
  ///
  /// tr: 'Yeni bir uyarı görüntülendi.'
  ///
  /// pt: 'Um novo alerta foi exibido.'
  String get newAlertDisplayedAnnouncement => 'A new alert has been displayed.';

  /// Announcement for accessibility tools when an alert is closed.
  ///
  /// en: 'The alert has been closed.'
  ///
  /// ar: 'تم إغلاق التنبيه.'
  ///
  /// ur: 'انتباہ بند کر دیا گیا ہے۔'
  ///
  /// id: 'Peringatan telah ditutup.'
  ///
  /// tr: 'Uyarı kapatıldı.'
  ///
  /// pt: 'O alerta foi fechado.'
  String get alertClosedAnnouncement => 'The alert has been closed.';

  /// A general alert type with a standard design, suitable for various informational messages.
  ///
  /// en: 'Normal alert'
  ///
  /// ar: 'تنبيه عادي'
  ///
  /// ur: 'عام انتباہ'
  ///
  /// id: 'Peringatan normal'
  ///
  /// tr: 'Normal uyarı'
  ///
  /// pt: 'Alerta normal'
  String get generalAlertType => 'Normal alert';

  /// An alert type conveying information, distinguished by a specific design and semantic meaning.
  ///
  /// en: 'Information alert'
  ///
  /// ar: 'تنبيه معلوماتي'
  ///
  /// ur: 'معلوماتی انتباہ'
  ///
  /// id: 'Peringatan informasi'
  ///
  /// tr: 'Bilgi uyarısı'
  ///
  /// pt: 'Alerta de informação'
  String get informationAlertType => 'Information alert';

  /// An alert type indicating a successful operation, distinguished by a specific design and semantic meaning.
  ///
  /// en: 'Success alert'
  ///
  /// ar: 'تنبيه نجاح'
  ///
  /// ur: 'کامیابی کا انتباہ'
  ///
  /// id: 'Peringatan sukses'
  ///
  /// tr: 'Başarı uyarısı'
  ///
  /// pt: 'Alerta de sucesso'
  String get successAlertType => 'Success alert';

  /// An alert type indicating a warning, distinguished by a specific design and semantic meaning.
  ///
  /// en: 'Warning alert'
  ///
  /// ar: 'تنبيه تحذير'
  ///
  /// ur: 'تنبیہی انتباہ'
  ///
  /// id: 'Peringatan peringatan'
  ///
  /// tr: 'Uyarı uyarısı'
  ///
  /// pt: 'Alerta de aviso'
  String get warningAlertType => 'Warning alert';

  /// An alert type indicating a critical danger or error, distinguished by a specific design and semantic meaning.
  ///
  /// en: 'Danger alert'
  ///
  /// ar: 'تنبيه خطر'
  ///
  /// ur: 'خطرناک انتباہ'
  ///
  /// id: 'Peringatan bahaya'
  ///
  /// tr: 'Tehlike uyarısı'
  ///
  /// pt: 'Alerta de perigo'
  String get dangerAlertType => 'Danger alert';

  /// Description of an icon representing a normal alert.
  ///
  /// en: 'Normal alert icon'
  ///
  /// ar: 'أيقونة تنبيه عادي'
  ///
  /// ur: 'عام انتباہ کا آئیکن'
  ///
  /// id: 'Ikon peringatan normal'
  ///
  /// tr: 'Normal uyarı simgesi'
  ///
  /// pt: 'Ícone de alerta normal'
  String get normalAlertIconDescription => 'Normal alert icon';

  /// Description of an icon representing an information alert.
  ///
  /// en: 'Information alert icon'
  ///
  /// ar: 'أيقونة تنبيه معلوماتي'
  ///
  /// ur: 'معلوماتی انتباہ کا آئیکن'
  ///
  /// id: 'Ikon peringatan informasi'
  ///
  /// tr: 'Bilgi uyarısı simgesi'
  ///
  /// pt: 'Ícone de alerta de informação'
  String get informationAlertIconDescription => 'Information alert icon';

  /// Description of an icon representing a success alert.
  ///
  /// en: 'Success alert icon'
  ///
  /// ar: 'أيقونة تنبيه نجاح'
  ///
  /// ur: 'کامیابی کے انتباہ کا آئیکن'
  ///
  /// id: 'Ikon peringatan sukses'
  ///
  /// tr: 'Başarı uyarısı simgesi'
  ///
  /// pt: 'Ícone de alerta de sucesso'
  String get successAlertIconDescription => 'Success alert icon';

  /// Description of an icon representing a warning alert.
  ///
  /// en: 'Warning alert icon'
  ///
  /// ar: 'أيقونة تنبيه تحذير'
  ///
  /// ur: 'تنبیہی انتباہ کا آئیکن'
  ///
  /// id: 'Ikon peringatan peringatan'
  ///
  /// tr: 'Uyarı uyarısı simgesi'
  ///
  /// pt: 'Ícone de alerta de aviso'
  String get warningAlertIconDescription => 'Warning alert icon';

  /// Description of an icon representing a danger alert.
  ///
  /// en: 'Danger alert icon'
  ///
  /// ar: 'أيقونة تنبيه خطر'
  ///
  /// ur: 'خطرناک انتباہ کا آئیکن'
  ///
  /// id: 'Ikon peringatan bahaya'
  ///
  /// tr: 'Tehlike uyarısı simgesi'
  ///
  /// pt: 'Ícone de alerta de perigo'
  String get dangerAlertIconDescription => 'Danger alert icon';

  /// Semantic hint indicating that content is currently loading.
  ///
  /// en: 'Loading'
  ///
  /// ar: 'جارٍ التحميل'
  ///
  /// ur: 'لوڈ ہو رہا ہے'
  ///
  /// id: 'Memuat'
  ///
  /// tr: 'Yükleniyor'
  ///
  /// pt: 'Carregando'
  String get loadingSemanticHint => 'Loading';

  /// Semantic hint instructing the user to press and hold an element to pause a countdown.
  ///
  /// en: 'Press and hold to pause the countdown.'
  ///
  /// ar: 'اضغط مع الاستمرار لإيقاف العد التنازلي مؤقتًا.'
  ///
  /// ur: 'الٹی گنتی کو روکنے کے لیے دبائے رکھیں اور تھامے رکھیں۔'
  ///
  /// id: 'Tekan dan tahan untuk menjeda hitung mundur.'
  ///
  /// tr: 'Geri sayımı duraklatmak için basılı tutun.'
  ///
  /// pt: 'Pressione e segure para pausar a contagem regressiva.'
  String get pressAndHoldToPauseCountdownSemanticHint =>
      'Press and hold to pause the countdown.';

  /// Semantic hint instructing the user to click an element to close it.
  ///
  /// en: 'Click to close'
  ///
  /// ar: 'انقر للإغلاق'
  ///
  /// ur: 'بند کرنے کے لیے کلک کریں'
  ///
  /// id: 'Klik untuk menutup'
  ///
  /// tr: 'Kapatmak için tıklayın'
  ///
  /// pt: 'Clique para fechar'
  String get clickToCloseSemanticHint => 'Click to close';

  /// Tooltip text for a button that closes a dialog or interface element.
  ///
  /// en: 'Close'
  ///
  /// ar: 'إغلاق'
  ///
  /// ur: 'بند کریں'
  ///
  /// id: 'Tutup'
  ///
  /// tr: 'Kapat'
  ///
  /// pt: 'Fechar'
  String get closeButtonTooltip => 'Close';
}

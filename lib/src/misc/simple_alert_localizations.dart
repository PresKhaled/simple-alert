/*
* This file is a part of "SimpleAlert" project.
* Khaled Mohsen <pres.kbayomy@gmail.com>
* Copyrights (BSD-3-Clause), LICENSE.
*/

/// A lightweight, built-in internationalization provider for SimpleAlert.
///
/// Supports English (en), Arabic (ar), Urdu (ur), Turkish (tr),
/// Indonesian (id), and Portuguese (pt) with zero external dependencies.
class SimpleAlertLocalizations {
  static String _currentLocale = 'en';

  /// Sets the active locale code (e.g. 'en', 'ar', 'ur', 'tr', 'id', 'pt').
  static void setLocale(String locale) {
    _currentLocale = locale.toLowerCase().split('_').first.split('-').first;
  }

  /// Gets the currently active locale code.
  static String get currentLocale => _currentLocale;

  /// Retrieves the current translations instance.
  static SimpleAlertLocalizations get current =>
      const SimpleAlertLocalizations();

  const SimpleAlertLocalizations();

  String alertSemanticLabel({required String title}) =>
      switch (_currentLocale) {
        'ar' => 'تنبيه: $title',
        'ur' => 'انتباہ: $title',
        'tr' => 'Uyarı: $title',
        'id' => 'Peringatan: $title',
        'pt' => 'Alerta: $title',
        _ => 'Alert: $title',
      };

  String get loadingIndicatorSemanticLabel => switch (_currentLocale) {
        'ar' => 'جاري التحميل',
        'ur' => 'لوڈ ہو رہا ہے',
        'tr' => 'Yükleniyor',
        'id' => 'Memuat',
        'pt' => 'Carregando',
        _ => 'Loading',
      };

  String get alertTimerSemanticLabel => switch (_currentLocale) {
        'ar' => 'مؤقت التنبيه',
        'ur' => 'انتباہی ٹائمر',
        'tr' => 'Uyarı zamanlayıcısı',
        'id' => 'Pengatur waktu peringatan',
        'pt' => 'Temporizador de alerta',
        _ => 'Alert timer',
      };

  String get newAlertDisplayedAnnouncement => switch (_currentLocale) {
        'ar' => 'تم عرض تنبيه جديد.',
        'ur' => 'ایک نیا الرٹ دکھایا گیا ہے۔',
        'tr' => 'Yeni bir uyarı görüntülendi.',
        'id' => 'Pemberitahuan baru telah ditampilkan.',
        'pt' => 'Um novo alerta foi exibido.',
        _ => 'A new alert has been displayed.',
      };

  String get alertClosedAnnouncement => switch (_currentLocale) {
        'ar' => 'تم إغلاق التنبيه.',
        'ur' => 'انتباہ بند کر دیا گیا ہے۔',
        'tr' => 'Uyarı kapatıldı.',
        'id' => 'Peringatan telah ditutup.',
        'pt' => 'O alerta foi fechado.',
        _ => 'The alert has been closed.',
      };

  String get generalAlertType => switch (_currentLocale) {
        'ar' => 'تنبيه عادي',
        'ur' => 'عام الرٹ',
        'tr' => 'Normal uyarı',
        'id' => 'Peringatan normal',
        'pt' => 'Alerta normal',
        _ => 'Normal alert',
      };

  String get informationAlertType => switch (_currentLocale) {
        'ar' => 'تنبيه معلومات',
        'ur' => 'معلوماتی الرٹ',
        'tr' => 'Bilgilendirme uyarısı',
        'id' => 'Peringatan informasi',
        'pt' => 'Alerta informativo',
        _ => 'Information alert',
      };

  String get successAlertType => switch (_currentLocale) {
        'ar' => 'تنبيه نجاح',
        'ur' => 'کامیابی کا الرٹ',
        'tr' => 'Başarı uyarısı',
        'id' => 'Peringatan sukses',
        'pt' => 'Alerta de sucesso',
        _ => 'Success alert',
      };

  String get warningAlertType => switch (_currentLocale) {
        'ar' => 'تنبيه تحذير',
        'ur' => 'وارننگ الرٹ',
        'tr' => 'Uyarı bildirimi',
        'id' => 'Peringatan waspada',
        'pt' => 'Alerta de aviso',
        _ => 'Warning alert',
      };

  String get dangerAlertType => switch (_currentLocale) {
        'ar' => 'تنبيه خطر',
        'ur' => 'خطرناک الرٹ',
        'tr' => 'Tehlike uyarısı',
        'id' => 'Peringatan bahaya',
        'pt' => 'Alerta de perigo',
        _ => 'Danger alert',
      };

  String get normalAlertIconDescription => switch (_currentLocale) {
        'ar' => 'أيقونة تنبيه عادي',
        'ur' => 'عام الرٹ کا آئیکن',
        'tr' => 'Normal uyarı simgesi',
        'id' => 'Ikon peringatan normal',
        'pt' => 'Ícone de alerta normal',
        _ => 'Normal alert icon',
      };

  String get informationAlertIconDescription => switch (_currentLocale) {
        'ar' => 'أيقونة تنبيه معلومات',
        'ur' => 'معلوماتی الرٹ کا آئیکن',
        'tr' => 'Bilgilendirme uyarısı simgesi',
        'id' => 'Ikon peringatan informasi',
        'pt' => 'Ícone de alerta informativo',
        _ => 'Information alert icon',
      };

  String get successAlertIconDescription => switch (_currentLocale) {
        'ar' => 'أيقونة تنبيه نجاح',
        'ur' => 'کامیابی کے الرٹ کا آئیکن',
        'tr' => 'Başarı uyarısı simgesi',
        'id' => 'Ikon peringatan sukses',
        'pt' => 'Ícone de alerta de sucesso',
        _ => 'Success alert icon',
      };

  String get warningAlertIconDescription => switch (_currentLocale) {
        'ar' => 'أيقونة تنبيه تحذير',
        'ur' => 'وارننگ الرٹ کا آئیکن',
        'tr' => 'Uyarı bildirimi simgesi',
        'id' => 'Ikon peringatan waspada',
        'pt' => 'Ícone de alerta de aviso',
        _ => 'Warning alert icon',
      };

  String get dangerAlertIconDescription => switch (_currentLocale) {
        'ar' => 'أيقونة تنبيه خطر',
        'ur' => 'خطرناک الرٹ کا آئیکن',
        'tr' => 'Tehlike uyarısı simgesi',
        'id' => 'Ikon peringatan bahaya',
        'pt' => 'Ícone de alerta de perigo',
        _ => 'Danger alert icon',
      };

  String get loadingSemanticHint => switch (_currentLocale) {
        'ar' => 'جاري التحميل',
        'ur' => 'لوڈ ہو رہا ہے',
        'tr' => 'Yükleniyor',
        'id' => 'Memuat',
        'pt' => 'Carregando',
        _ => 'Loading',
      };

  String get pressAndHoldToPauseCountdownSemanticHint =>
      switch (_currentLocale) {
        'ar' => 'اضغط مع الاستمرار لإيقاف العد التنازلي مؤقتاً.',
        'ur' => 'الٹی گنتی کو روکنے کے لیے دبائے رکھیں۔',
        'tr' => 'Geri sayımı duraklatmak için basılı tutun.',
        'id' => 'Tekan dan tahan untuk menjeda hitungan mundur.',
        'pt' => 'Pressione e segure para pausar a contagem regressiva.',
        _ => 'Press and hold to pause the countdown.',
      };

  String get clickToCloseSemanticHint => switch (_currentLocale) {
        'ar' => 'اضغط للإغلاق',
        'ur' => 'بند کرنے کے لیے کلک کریں',
        'tr' => 'Kapatmak için tıklayın',
        'id' => 'Klik untuk menutup',
        'pt' => 'Clique para fechar',
        _ => 'Click to close',
      };

  String get closeButtonTooltip => switch (_currentLocale) {
        'ar' => 'إغلاق',
        'ur' => 'بند کریں',
        'tr' => 'Kapat',
        'id' => 'Tutup',
        'pt' => 'Fechar',
        _ => 'Close',
      };
}

/// Convenience global accessor matching previous syntax.
SimpleAlertLocalizations get t => SimpleAlertLocalizations.current;

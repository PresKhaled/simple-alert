///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsId extends Translations {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsId({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
      : assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ??
            TranslationMetadata(
              locale: AppLocale.id,
              overrides: overrides ?? {},
              cardinalResolver: cardinalResolver,
              ordinalResolver: ordinalResolver,
            ),
        super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

  /// Metadata for the translations of <id>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  late final TranslationsId _root = this; // ignore: unused_field

  @override
  TranslationsId $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsId(meta: meta ?? this.$meta);

  // Translations

  /// Label semantik untuk peringatan, termasuk judulnya.
  @override
  String alertSemanticLabel({required String title}) => 'Peringatan: ${title}';

  /// Label semantik untuk indikator pemuatan.
  @override
  String get loadingIndicatorSemanticLabel => 'Memuat';

  /// Label semantik untuk bilah kemajuan yang menunjukkan sisa waktu untuk peringatan.
  @override
  String get alertTimerSemanticLabel => 'Waktu peringatan';

  /// Pengumuman untuk alat bantu aksesibilitas saat peringatan baru ditampilkan.
  @override
  String get newAlertDisplayedAnnouncement => 'Peringatan baru telah ditampilkan.';

  /// Pengumuman untuk alat bantu aksesibilitas saat peringatan ditutup.
  @override
  String get alertClosedAnnouncement => 'Peringatan telah ditutup.';

  /// Jenis peringatan umum dengan desain standar, cocok untuk berbagai pesan informatif.
  @override
  String get generalAlertType => 'Peringatan normal';

  /// Jenis peringatan yang menyampaikan informasi, dibedakan oleh desain dan makna semantik tertentu.
  @override
  String get informationAlertType => 'Peringatan informasi';

  /// Jenis peringatan yang menunjukkan operasi berhasil, dibedakan oleh desain dan makna semantik tertentu.
  @override
  String get successAlertType => 'Peringatan sukses';

  /// Jenis peringatan yang menunjukkan peringatan, dibedakan oleh desain dan makna semantik tertentu.
  @override
  String get warningAlertType => 'Peringatan peringatan';

  /// Jenis peringatan yang menunjukkan bahaya atau kesalahan kritis, dibedakan oleh desain dan makna semantik tertentu.
  @override
  String get dangerAlertType => 'Peringatan bahaya';

  /// Deskripsi ikon yang mewakili peringatan normal.
  @override
  String get normalAlertIconDescription => 'Ikon peringatan normal';

  /// Deskripsi ikon yang mewakili peringatan informasi.
  @override
  String get informationAlertIconDescription => 'Ikon peringatan informasi';

  /// Deskripsi ikon yang mewakili peringatan sukses.
  @override
  String get successAlertIconDescription => 'Ikon peringatan sukses';

  /// Deskripsi ikon yang mewakili peringatan.
  @override
  String get warningAlertIconDescription => 'Ikon peringatan peringatan';

  /// Deskripsi ikon yang mewakili peringatan bahaya.
  @override
  String get dangerAlertIconDescription => 'Ikon peringatan bahaya';

  /// Petunjuk semantik yang menunjukkan bahwa konten sedang dimuat.
  @override
  String get loadingSemanticHint => 'Memuat';

  /// Petunjuk semantik yang menginstruksikan pengguna untuk menekan dan menahan elemen untuk menjeda hitung mundur.
  @override
  String get pressAndHoldToPauseCountdownSemanticHint => 'Tekan dan tahan untuk menjeda hitung mundur.';

  /// Petunjuk semantik yang menginstruksikan pengguna untuk mengklik elemen untuk menutupnya.
  @override
  String get clickToCloseSemanticHint => 'Klik untuk menutup';

  /// Teks tooltip untuk tombol yang menutup dialog atau elemen antarmuka.
  @override
  String get closeButtonTooltip => 'Tutup';
}

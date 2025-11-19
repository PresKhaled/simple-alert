///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsPt extends Translations {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsPt({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
      : assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
        $meta = meta ??
            TranslationMetadata(
              locale: AppLocale.pt,
              overrides: overrides ?? {},
              cardinalResolver: cardinalResolver,
              ordinalResolver: ordinalResolver,
            ),
        super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver);

  /// Metadata for the translations of <pt>.
  @override
  final TranslationMetadata<AppLocale, Translations> $meta;

  late final TranslationsPt _root = this; // ignore: unused_field

  @override
  TranslationsPt $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsPt(meta: meta ?? this.$meta);

  // Translations

  /// Rótulo semântico para um alerta, incluindo seu título.
  @override
  String alertSemanticLabel({required String title}) => 'Alerta: ${title}';

  /// Rótulo semântico para um indicador de carregamento.
  @override
  String get loadingIndicatorSemanticLabel => 'Carregando';

  /// Rótulo semântico para a barra de progresso que indica o tempo restante para um alerta.
  @override
  String get alertTimerSemanticLabel => 'Temporizador de alerta';

  /// Anúncio para ferramentas de acessibilidade quando um novo alerta é exibido.
  @override
  String get newAlertDisplayedAnnouncement => 'Um novo alerta foi exibido.';

  /// Anúncio para ferramentas de acessibilidade quando um alerta é fechado.
  @override
  String get alertClosedAnnouncement => 'O alerta foi fechado.';

  /// Um tipo de alerta geral com design padrão, adequado para várias mensagens informativas.
  @override
  String get generalAlertType => 'Alerta normal';

  /// Um tipo de alerta que transmite informações, distinguido por um design e significado semântico específicos.
  @override
  String get informationAlertType => 'Alerta de informação';

  /// Um tipo de alerta que indica uma operação bem-sucedida, distinguido por um design e significado semântico específicos.
  @override
  String get successAlertType => 'Alerta de sucesso';

  /// Um tipo de alerta que indica um aviso, distinguido por um design e significado semântico específicos.
  @override
  String get warningAlertType => 'Alerta de aviso';

  /// Um tipo de alerta que indica um perigo ou erro crítico, distinguido por um design e significado semântico específicos.
  @override
  String get dangerAlertType => 'Alerta de perigo';

  /// Descrição de um ícone que representa um alerta normal.
  @override
  String get normalAlertIconDescription => 'Ícone de alerta normal';

  /// Descrição de um ícone que representa um alerta de informação.
  @override
  String get informationAlertIconDescription => 'Ícone de alerta de informação';

  /// Descrição de um ícone que representa um alerta de sucesso.
  @override
  String get successAlertIconDescription => 'Ícone de alerta de sucesso';

  /// Descrição de um ícone que representa um alerta de aviso.
  @override
  String get warningAlertIconDescription => 'Ícone de alerta de aviso';

  /// Descrição de um ícone que representa um alerta de perigo.
  @override
  String get dangerAlertIconDescription => 'Ícone de alerta de perigo';

  /// Dica semântica que indica que o conteúdo está sendo carregado no momento.
  @override
  String get loadingSemanticHint => 'Carregando';

  /// Dica semântica que instrui o usuário a pressionar e segurar um elemento para pausar uma contagem regressiva.
  @override
  String get pressAndHoldToPauseCountdownSemanticHint => 'Pressione e segure para pausar a contagem regressiva.';

  /// Dica semântica que instrui o usuário a clicar em um elemento para fechá-lo.
  @override
  String get clickToCloseSemanticHint => 'Clique para fechar';

  /// Texto da dica de ferramenta para um botão que fecha um diálogo ou elemento da interface.
  @override
  String get closeButtonTooltip => 'Fechar';
}

import 'dart:ui';

import 'package:likelemba_app/core/errors/failures.dart';
import 'package:likelemba_app/core/l10n/l10n.dart';

/// Les traductions de la langue du téléphone, sans BuildContext.
///
/// Les BLoC n'ont pas de contexte : ils s'en servent pour ranger un message
/// déjà traduit dans `state.message`. Le français sert de repli.
AppLocalizations get currentL10n {
  final locale = PlatformDispatcher.instance.locale;
  final supported = AppLocalizations.supportedLocales.any(
    (l) => l.languageCode == locale.languageCode,
  );
  return lookupAppLocalizations(supported ? locale : const Locale('fr'));
}

/// Message des Failure communes à toute l'application.
///
/// Chaque feature traduit ses propres Failure, puis se rabat sur
/// celle-ci pour les autres (voir les fichiers `failure_message.dart`).
String commonFailureMessage(Failure failure, AppLocalizations l10n) =>
    switch (failure) {
      NetworkFailure() => l10n.errorNetwork,
      SessionExpiredFailure() => l10n.errorSessionExpired,
      _ => l10n.errorServer,
    };

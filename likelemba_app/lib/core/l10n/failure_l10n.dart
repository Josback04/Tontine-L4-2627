import 'package:likelemba_app/core/errors/failures.dart';
import 'package:likelemba_app/core/l10n/l10n.dart';

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

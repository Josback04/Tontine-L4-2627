import 'package:likelemba_app/core/errors/failures.dart';
import 'package:likelemba_app/core/l10n/failure_l10n.dart';
import 'package:likelemba_app/features/auth/domain/failures/auth_failures.dart';

/// Traduit une Failure en phrase pour l'utilisateur : `left.message`.
/// Le trésorier ne lit jamais « ServerException(500) ».
///
/// La traduction reste dans presentation/ : le domaine ne connaît pas
/// les langues.
extension FailureMessage on Failure {
  String get message {
    final l10n = currentL10n;
    return switch (this) {
      InvalidCredentialsFailure() => l10n.errorInvalidCredentials,
      _ => commonFailureMessage(this, l10n),
    };
  }
}

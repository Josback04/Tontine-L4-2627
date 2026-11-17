import 'package:likelemba_app/core/errors/failures.dart';
import 'package:likelemba_app/core/l10n/failure_l10n.dart';
import 'package:likelemba_app/core/l10n/l10n.dart';
import 'package:likelemba_app/features/auth/domain/failures/auth_failures.dart';

/// Traduit une Failure en phrase pour l'utilisateur.
/// Le trésorier ne lit jamais « ServerException(500) ».
extension FailureMessage on Failure {
  String message(AppLocalizations l10n) => switch (this) {
    InvalidCredentialsFailure() => l10n.errorInvalidCredentials,
    EmailAlreadyUsedFailure() => l10n.errorEmailAlreadyUsed,
    InvalidRegistrationFailure() => l10n.errorInvalidRegistration,
    _ => commonFailureMessage(this, l10n),
  };
}

import 'package:likelemba_app/core/errors/failures.dart';

/// E-mail ou mot de passe incorrect.
class InvalidCredentialsFailure extends Failure {
  const new();
}

/// Un compte existe déjà avec cet e-mail.
class EmailAlreadyUsedFailure extends Failure {
  const new();
}

/// L'API a refusé les données du formulaire.
class InvalidRegistrationFailure extends Failure {
  const new();
}

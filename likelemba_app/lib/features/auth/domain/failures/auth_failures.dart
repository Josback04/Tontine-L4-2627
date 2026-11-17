import 'package:likelemba_app/core/errors/failures.dart';

/// Les échecs MÉTIER propres à l'authentification.
/// Les échecs communs (réseau, serveur) sont dans core/errors/failures.dart.
class InvalidCredentialsFailure extends Failure {
  const new();
}

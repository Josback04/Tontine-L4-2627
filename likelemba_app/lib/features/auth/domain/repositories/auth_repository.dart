import 'package:likelemba_app/features/auth/domain/entities/user.dart';

/// CONTRAT du domaine : ce que le domaine attend, sans dire comment.
///
/// Le domaine déclare l'interface ; la couche data/ l'implémente.
/// C'est l'inversion des dépendances : data/ dépend de domain/, jamais
/// l'inverse.
abstract interface class AuthRepository {
  /// Renvoie l'utilisateur connecté, ou lève une Failure
  /// (InvalidCredentialsFailure, NetworkFailure, ServerFailure).
  Future<User> login({required String email, required String password});
}

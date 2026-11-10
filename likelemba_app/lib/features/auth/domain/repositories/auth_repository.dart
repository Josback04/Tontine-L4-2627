import 'package:likelemba_app/features/auth/domain/entities/user.dart';

/// Contrat d'authentification.
///
/// Le domaine possède le contrat ; data/repositories/auth_repository_impl.dart
/// s'y conforme. Chaque méthode lève une Failure en cas d'échec.
abstract interface class AuthRepository {
  Future<User> login({required String email, required String password});

  Future<User> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  });

  /// L'utilisateur de la session enregistrée, ou null s'il n'y en a pas.
  Future<User?> getCurrentUser();

  Future<void> logout();
}

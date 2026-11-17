import 'package:likelemba_app/features/auth/domain/entities/user.dart';
import 'package:likelemba_app/features/auth/domain/failures/auth_failures.dart';
import 'package:likelemba_app/features/auth/domain/repositories/auth_repository.dart';

/// Implémentation PROVISOIRE du contrat, en mémoire, pour la séance 1.
///
/// Elle permet de faire tourner l'interface et le domaine sans API.
/// À la séance consacrée à la couche data, on la remplacera par
/// AuthRepositoryImpl (API likelemba_backend + stockage local) en ne
/// changeant qu'UNE ligne : l'enregistrement dans auth_injection.dart.
/// Ni le cas d'usage ni la page ne bougeront.
class FakeAuthRepository implements AuthRepository {
  const new();

  /// Le mot de passe des comptes de démonstration de likelemba_backend.
  static const demoPassword = 'likelemba2026';

  static const _users = {
    'tresorier1@likelemba.test': User(
      id: 'usr-001',
      fullName: 'Grâce Mbuyi',
      email: 'tresorier1@likelemba.test',
      phone: '0812345678',
    ),
    'tresorier2@likelemba.test': User(
      id: 'usr-002',
      fullName: 'Patrick Kalala',
      email: 'tresorier2@likelemba.test',
      phone: '0823456789',
    ),
  };

  @override
  Future<User> login({required String email, required String password}) async {
    // Simule la latence du réseau : on voit le bouton passer en chargement.
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final user = _users[email];
    if (user == null || password != demoPassword) {
      throw const InvalidCredentialsFailure();
    }
    return user;
  }
}

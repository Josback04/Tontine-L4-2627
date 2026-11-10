import 'package:likelemba_backend/src/password_hasher.dart';
import 'package:likelemba_backend/src/user.dart';

/// L'adresse e-mail est déjà prise.
class EmailAlreadyUsedException implements Exception {
  const EmailAlreadyUsedException();
}

/// Stockage des utilisateurs, en mémoire : tout est perdu à l'arrêt du
/// serveur, sauf les comptes de démonstration recréés au démarrage.
class UserRepository {
  UserRepository({PasswordHasher hasher = const PasswordHasher()})
    : _hasher = hasher {
    for (final seed in _seeds) {
      _users[seed.email] = User(
        id: seed.id,
        fullName: seed.fullName,
        email: seed.email,
        phone: seed.phone,
        role: seed.role,
        passwordHash: _hasher.hash(demoPassword),
        createdAt: DateTime.utc(2026, 9),
      );
    }
  }

  /// Mot de passe commun aux comptes de démonstration.
  static const demoPassword = 'likelemba2026';

  static const _seeds = [
    (
      id: 'usr-001',
      fullName: 'Grâce Mbuyi',
      email: 'tresorier1@likelemba.test',
      phone: '0812345678',
      role: UserRole.treasurer,
    ),
    (
      id: 'usr-002',
      fullName: 'Patrick Kabongo',
      email: 'tresorier2@likelemba.test',
      phone: '0998765432',
      role: UserRole.treasurer,
    ),
    (
      id: 'usr-003',
      fullName: 'Esther Lukusa',
      email: 'membre1@likelemba.test',
      phone: '0823456789',
      role: UserRole.member,
    ),
  ];

  final PasswordHasher _hasher;
  final Map<String, User> _users = {};

  User? findById(String id) {
    for (final user in _users.values) {
      if (user.id == id) return user;
    }
    return null;
  }

  /// Renvoie l'utilisateur si l'e-mail et le mot de passe correspondent.
  User? authenticate(String email, String password) {
    final user = _users[_normalize(email)];
    if (user == null || !_hasher.verify(password, user.passwordHash)) {
      return null;
    }
    return user;
  }

  /// Crée un compte. Lève [EmailAlreadyUsedException] si l'e-mail existe.
  User create({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    UserRole role = UserRole.treasurer,
  }) {
    final key = _normalize(email);
    if (_users.containsKey(key)) throw const EmailAlreadyUsedException();
    final user = User(
      id: 'usr-${(_users.length + 1).toString().padLeft(3, '0')}',
      fullName: fullName.trim(),
      email: key,
      phone: phone.trim(),
      role: role,
      passwordHash: _hasher.hash(password),
      createdAt: DateTime.now().toUtc(),
    );
    _users[key] = user;
    return user;
  }

  String _normalize(String email) => email.trim().toLowerCase();
}

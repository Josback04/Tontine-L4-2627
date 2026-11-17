/// Une personne qui a un compte Likelemba.
///
/// Pas de rôle ici : on est trésorier ou membre D'UNE tontine, pas de
/// l'application. Le rôle vit dans `Member` (voir member.dart).
///
/// [passwordHash] ne quitte jamais le serveur : [toJson] ne l'écrit pas.
class User {
  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.passwordHash,
    required this.createdAt,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String passwordHash;
  final DateTime createdAt;

  /// Représentation publique, envoyée à l'application.
  Map<String, Object?> toJson() => {
    'id': id,
    'full_name': fullName,
    'email': email,
    'phone': phone,
    'created_at': createdAt.toUtc().toIso8601String(),
  };
}

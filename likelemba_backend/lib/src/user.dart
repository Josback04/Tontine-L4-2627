/// Rôle d'un utilisateur dans une tontine.
enum UserRole {
  /// Tient la caisse : enregistre les cotisations.
  treasurer,

  /// Cotise chaque tour.
  member,
}

/// Un utilisateur tel que le serveur le stocke.
///
/// [passwordHash] ne quitte jamais le serveur : [toJson] ne l'écrit pas.
class User {
  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.passwordHash,
    required this.createdAt,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final UserRole role;
  final String passwordHash;
  final DateTime createdAt;

  /// Représentation publique, envoyée à l'application.
  Map<String, Object?> toJson() => {
    'id': id,
    'full_name': fullName,
    'email': email,
    'phone': phone,
    'role': role.name,
    'created_at': createdAt.toUtc().toIso8601String(),
  };
}

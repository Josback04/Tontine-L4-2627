import 'package:equatable/equatable.dart';

/// Rôle d'un utilisateur dans une tontine.
enum UserRole {
  /// Tient la caisse : enregistre les cotisations.
  treasurer,

  /// Cotise à chaque tour.
  member,
}

/// Un utilisateur de Likelemba, tel que le métier le voit.
///
/// Dart pur : aucune trace de JSON, d'API ou de Flutter. Le format
/// d'échange vit dans data/models/user_model.dart.
class User extends Equatable {
  const new({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;
  final UserRole role;

  /// Règle métier : seul le trésorier enregistre les cotisations.
  bool get canManageContributions => role == UserRole.treasurer;

  /// « Grâce Mbuyi » donne « Grâce ».
  String get firstName => fullName.trim().split(RegExp(r'\s+')).first;

  /// « Grâce Mbuyi » donne « GM ».
  String get initials => fullName
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .take(2)
      .map((word) => word[0].toUpperCase())
      .join();

  @override
  List<Object?> get props => [id, fullName, email, phone, role];
}

import 'package:likelemba_app/features/auth/domain/entities/user.dart';

/// Le format d'échange d'un utilisateur : JSON de l'API et du cache local.
///
/// UserModel EST un User (il en hérite) : le dépôt peut le renvoyer tel quel
/// au domaine, qui n'en connaît que la partie User.
class UserModel extends User {
  const new({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.role,
  });

  factory fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    fullName: json['full_name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String? ?? '',
    role: UserRole.values.asNameMap()[json['role']] ?? UserRole.member,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'full_name': fullName,
    'email': email,
    'phone': phone,
    'role': role.name,
  };
}

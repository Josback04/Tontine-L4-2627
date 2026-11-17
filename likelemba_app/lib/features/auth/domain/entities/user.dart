import 'package:equatable/equatable.dart';

/// ENTITÉ du domaine : ce qu'est un utilisateur pour l'application.
///
/// Dart pur : aucun import de Flutter, de dio ou de JSON. Le domaine ne sait
/// pas d'où vient l'utilisateur (API, base locale, faux dépôt…).
class User extends Equatable {
  const new({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
  });

  final String id;
  final String fullName;
  final String email;
  final String phone;

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
  List<Object?> get props => [id, fullName, email, phone];
}

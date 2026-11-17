import 'package:equatable/equatable.dart';

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
  String get initials => initialsOf(fullName);

  @override
  List<Object?> get props => [id, fullName, email, phone];
}

/// Initiales d'un nom complet, partagées avec les membres d'une tontine.
String initialsOf(String fullName) => fullName
    .trim()
    .split(RegExp(r'\s+'))
    .where((word) => word.isNotEmpty)
    .take(2)
    .map((word) => word[0].toUpperCase())
    .join();

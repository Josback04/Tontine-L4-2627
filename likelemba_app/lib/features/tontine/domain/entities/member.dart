import 'package:equatable/equatable.dart';
import 'package:likelemba_app/features/auth/domain/entities/user.dart';

/// Le rôle d'une personne DANS UNE tontine.
enum MemberRole {
  /// Tient la caisse : gère les membres et les cotisations de CETTE tontine.
  treasurer,

  /// Cotise à chaque tour.
  member,
}

/// L'appartenance d'une personne à une tontine.
///
/// C'est ici que vit le rôle, et non dans User : la même personne peut être
/// trésorière d'une tontine et simple membre d'une autre. Un rôle n'a de
/// sens que rapporté à un groupe.
///
/// Un membre n'a pas forcément de compte ([hasAccount]) : le trésorier
/// l'ajoute avec son nom et son téléphone.
class Member extends Equatable {
  const new({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.payoutOrder,
    required this.role,
    required this.hasAccount,
  });

  final String id;
  final String fullName;
  final String phone;

  /// Ordre de passage pour recevoir la cagnotte (1 = premier tour).
  final int payoutOrder;
  final MemberRole role;
  final bool hasAccount;

  bool get isTreasurer => role == MemberRole.treasurer;

  String get initials => initialsOf(fullName);

  @override
  List<Object?> get props => [
    id,
    fullName,
    phone,
    payoutOrder,
    role,
    hasAccount,
  ];
}

/// Le rôle d'une personne DANS UNE tontine.
enum MemberRole {
  /// Tient la caisse : gère les membres et les cotisations de CETTE tontine.
  treasurer,

  /// Cotise à chaque tour.
  member,
}

/// L'appartenance d'une personne à une tontine.
///
/// C'est ici que vit le rôle, pas dans User : Grâce peut être trésorière de
/// la tontine du marché et simple membre de celle des enseignants.
///
/// [userId] est facultatif : beaucoup de membres n'ont pas l'application.
/// Le trésorier les ajoute avec leur nom et leur téléphone ; si un jour ils
/// créent un compte avec ce numéro, leur fiche y est rattachée.
class Member {
  Member({
    required this.id,
    required this.tontineId,
    required this.fullName,
    required this.phone,
    required this.payoutOrder,
    required this.role,
    this.userId,
  });

  final String id;
  final String tontineId;
  String fullName;
  String phone;

  /// Ordre de passage pour recevoir la cagnotte (1 = premier tour).
  int payoutOrder;
  MemberRole role;
  String? userId;

  Map<String, Object?> toJson() => {
    'id': id,
    'tontine_id': tontineId,
    'full_name': fullName,
    'phone': phone,
    'payout_order': payoutOrder,
    'role': role.name,
    'has_account': userId != null,
  };
}

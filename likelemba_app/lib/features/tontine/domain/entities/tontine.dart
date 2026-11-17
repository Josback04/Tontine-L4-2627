import 'package:equatable/equatable.dart';
import 'package:likelemba_app/features/tontine/domain/entities/member.dart';

/// Rythme des cotisations.
enum ContributionFrequency { weekly, monthly }

/// Une tontine, vue par l'utilisateur connecté.
///
/// [myRole] est MON rôle dans CETTE tontine : la même liste peut contenir
/// une tontine où je suis trésorier et une autre où je suis membre.
class Tontine extends Equatable {
  const new({
    required this.id,
    required this.name,
    required this.contributionAmount,
    required this.frequency,
    required this.startDate,
    required this.memberCount,
    required this.myRole,
  });

  final String id;
  final String name;

  /// Montant versé par chaque membre à chaque tour, en francs congolais.
  final int contributionAmount;
  final ContributionFrequency frequency;
  final DateTime startDate;
  final int memberCount;
  final MemberRole myRole;

  /// Règle métier : seul un trésorier de CETTE tontine gère ses membres.
  /// (Dans la première version, cette règle était sur User : elle ne
  /// pouvait pas distinguer deux tontines.)
  bool get canManage => myRole == MemberRole.treasurer;

  /// La cagnotte remise au bénéficiaire de chaque tour.
  int get potAmount => contributionAmount * memberCount;

  @override
  List<Object?> get props => [
    id,
    name,
    contributionAmount,
    frequency,
    startDate,
    memberCount,
    myRole,
  ];
}

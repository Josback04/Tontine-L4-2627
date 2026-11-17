import 'package:likelemba_app/features/tontine/domain/entities/member.dart';
import 'package:likelemba_app/features/tontine/domain/entities/tontine.dart';

/// Contrat d'accès aux tontines et à leurs membres.
/// Chaque méthode lève une Failure en cas d'échec.
abstract interface class TontineRepository {
  /// Mes tontines, chacune avec MON rôle.
  Future<List<Tontine>> getMyTontines();

  Future<Tontine> getTontine(String tontineId);

  /// Je deviens le trésorier de la tontine créée.
  Future<Tontine> createTontine({
    required String name,
    required int contributionAmount,
    required ContributionFrequency frequency,
    required DateTime startDate,
  });

  /// Les membres, dans l'ordre de passage.
  Future<List<Member>> getMembers(String tontineId);

  Future<Member> addMember({
    required String tontineId,
    required String fullName,
    required String phone,
  });

  Future<Member> updateMember({
    required String tontineId,
    required String memberId,
    String? fullName,
    String? phone,
    MemberRole? role,
  });

  Future<void> removeMember({
    required String tontineId,
    required String memberId,
  });
}

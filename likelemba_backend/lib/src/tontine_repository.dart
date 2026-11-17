import 'package:likelemba_backend/src/member.dart';
import 'package:likelemba_backend/src/tontine.dart';
import 'package:likelemba_backend/src/user.dart';

/// Ce numéro est déjà membre de la tontine.
class PhoneAlreadyMemberException implements Exception {
  const PhoneAlreadyMemberException();
}

/// Retirer ou rétrograder ce membre laisserait la tontine sans trésorier.
class LastTreasurerException implements Exception {
  const LastTreasurerException();
}

/// Tontines et membres, en mémoire.
class TontineRepository {
  TontineRepository() {
    _seed();
  }

  final Map<String, Tontine> _tontines = {};
  final List<Member> _members = [];
  int _nextTontine = 1;
  int _nextMember = 1;

  /// Les tontines dont l'utilisateur est membre, avec son appartenance.
  List<({Tontine tontine, Member membership, int memberCount})> listFor(
    String userId,
  ) => [
    for (final membership in _members.where((m) => m.userId == userId))
      (
        tontine: _tontines[membership.tontineId]!,
        membership: membership,
        memberCount: membersOf(membership.tontineId).length,
      ),
  ];

  Tontine? findById(String id) => _tontines[id];

  /// L'appartenance de l'utilisateur à la tontine, ou null s'il n'en est pas.
  Member? membershipOf(String tontineId, String userId) {
    for (final m in _members) {
      if (m.tontineId == tontineId && m.userId == userId) return m;
    }
    return null;
  }

  /// Les membres, dans l'ordre de passage.
  List<Member> membersOf(String tontineId) =>
      _members.where((m) => m.tontineId == tontineId).toList()
        ..sort((a, b) => a.payoutOrder.compareTo(b.payoutOrder));

  /// Crée la tontine : son créateur en devient le premier trésorier.
  ({Tontine tontine, Member membership}) create({
    required User creator,
    required String name,
    required int contributionAmount,
    required ContributionFrequency frequency,
    required DateTime startDate,
  }) {
    final tontine = Tontine(
      id: 'tnt-${(_nextTontine++).toString().padLeft(3, '0')}',
      name: name.trim(),
      contributionAmount: contributionAmount,
      frequency: frequency,
      startDate: startDate,
      createdAt: DateTime.now().toUtc(),
    );
    _tontines[tontine.id] = tontine;
    final membership = _addMember(
      tontineId: tontine.id,
      fullName: creator.fullName,
      phone: creator.phone,
      role: MemberRole.treasurer,
      userId: creator.id,
    );
    return (tontine: tontine, membership: membership);
  }

  /// Ajoute un membre en fin d'ordre de passage.
  /// [existingUser] : le compte qui porte déjà ce numéro, s'il existe.
  Member addMember({
    required String tontineId,
    required String fullName,
    required String phone,
    MemberRole role = MemberRole.member,
    User? existingUser,
  }) {
    if (membersOf(tontineId).any((m) => m.phone == phone)) {
      throw const PhoneAlreadyMemberException();
    }
    return _addMember(
      tontineId: tontineId,
      fullName: fullName.trim(),
      phone: phone,
      role: role,
      userId: existingUser?.id,
    );
  }

  Member? findMember(String tontineId, String memberId) {
    for (final m in _members) {
      if (m.tontineId == tontineId && m.id == memberId) return m;
    }
    return null;
  }

  Member updateMember(
    Member member, {
    String? fullName,
    String? phone,
    MemberRole? role,
  }) {
    if (phone != null &&
        phone != member.phone &&
        membersOf(member.tontineId).any((m) => m.phone == phone)) {
      throw const PhoneAlreadyMemberException();
    }
    if (role == MemberRole.member && _isLastTreasurer(member)) {
      throw const LastTreasurerException();
    }
    if (fullName != null) member.fullName = fullName.trim();
    if (phone != null) member.phone = phone;
    if (role != null) member.role = role;
    return member;
  }

  void removeMember(Member member) {
    if (_isLastTreasurer(member)) throw const LastTreasurerException();
    _members.remove(member);
    // On referme le trou dans l'ordre de passage.
    final rest = membersOf(member.tontineId);
    for (var i = 0; i < rest.length; i++) {
      rest[i].payoutOrder = i + 1;
    }
  }

  /// À l'inscription : les fiches créées par un trésorier avec ce numéro
  /// sont rattachées au nouveau compte.
  void linkMembersTo(User user) {
    for (final m in _members) {
      if (m.userId == null && m.phone == user.phone) m.userId = user.id;
    }
  }

  bool _isLastTreasurer(Member member) =>
      member.role == MemberRole.treasurer &&
      membersOf(
            member.tontineId,
          ).where((m) => m.role == MemberRole.treasurer).length ==
          1;

  Member _addMember({
    required String tontineId,
    required String fullName,
    required String phone,
    required MemberRole role,
    String? userId,
  }) {
    final member = Member(
      id: 'mbr-${(_nextMember++).toString().padLeft(3, '0')}',
      tontineId: tontineId,
      fullName: fullName,
      phone: phone,
      payoutOrder: membersOf(tontineId).length + 1,
      role: role,
      userId: userId,
    );
    _members.add(member);
    return member;
  }

  /// Données de démonstration. Grâce (usr-001) est TRÉSORIÈRE de la première
  /// tontine et simple MEMBRE de la seconde : c'est tout l'objet de la
  /// leçon 7 sur le rôle.
  void _seed() {
    final start = DateTime.utc(2026, 9);
    _tontines['tnt-001'] = Tontine(
      id: 'tnt-001',
      name: 'Mamans du marché Gambela',
      contributionAmount: 25000,
      frequency: ContributionFrequency.monthly,
      startDate: start,
      createdAt: start,
    );
    _tontines['tnt-002'] = Tontine(
      id: 'tnt-002',
      name: 'Enseignants de Lemba',
      contributionAmount: 10000,
      frequency: ContributionFrequency.weekly,
      startDate: start,
      createdAt: start,
    );
    _nextTontine = 3;
    final seeds = [
      ('tnt-001', 'Grâce Mbuyi', '0812345678', MemberRole.treasurer, 'usr-001'),
      ('tnt-001', 'Esther Lukusa', '0823456789', MemberRole.member, 'usr-003'),
      ('tnt-001', 'Junior Bokele', '0834567890', MemberRole.member, null),
      ('tnt-001', 'Ruth Nzuzi', '0854321098', MemberRole.member, null),
      (
        'tnt-002',
        'Patrick Kabongo',
        '0998765432',
        MemberRole.treasurer,
        'usr-002',
      ),
      ('tnt-002', 'Grâce Mbuyi', '0812345678', MemberRole.member, 'usr-001'),
      ('tnt-002', 'Daniel Mputu', '0811112222', MemberRole.member, null),
    ];
    for (final (tontineId, name, phone, role, userId) in seeds) {
      _addMember(
        tontineId: tontineId,
        fullName: name,
        phone: phone,
        role: role,
        userId: userId,
      );
    }
  }
}

import 'package:likelemba_backend/likelemba_backend.dart';
import 'package:test/test.dart';

void main() {
  late TontineRepository repository;

  setUp(() => repository = TontineRepository());

  group('le rôle appartient à l’appartenance, pas à la personne', () {
    test('Grâce est trésorière de tnt-001 et membre de tnt-002', () {
      expect(
        repository.membershipOf('tnt-001', 'usr-001')?.role,
        MemberRole.treasurer,
      );
      expect(
        repository.membershipOf('tnt-002', 'usr-001')?.role,
        MemberRole.member,
      );
    });

    test('listFor renvoie chaque tontine avec SON rôle', () {
      final roles = {
        for (final e in repository.listFor('usr-001'))
          e.tontine.id: e.membership.role,
      };
      expect(roles, {
        'tnt-001': MemberRole.treasurer,
        'tnt-002': MemberRole.member,
      });
    });
  });

  test('le créateur devient le premier trésorier', () {
    final grace = UserRepository().findById('usr-001')!;
    final created = repository.create(
      creator: grace,
      name: 'Famille Mbuyi',
      contributionAmount: 5000,
      frequency: ContributionFrequency.weekly,
      startDate: DateTime.utc(2026, 12),
    );
    expect(created.membership.role, MemberRole.treasurer);
    expect(created.membership.userId, 'usr-001');
    expect(repository.membersOf(created.tontine.id), hasLength(1));
  });

  group('membres', () {
    test('ajout en fin d’ordre de passage, sans compte', () {
      final member = repository.addMember(
        tontineId: 'tnt-001',
        fullName: 'Sarah Kalala',
        phone: '0899990000',
      );
      expect(member.payoutOrder, 5);
      expect(member.toJson()['has_account'], isFalse);
    });

    test('un même numéro ne peut pas être membre deux fois', () {
      expect(
        () => repository.addMember(
          tontineId: 'tnt-001',
          fullName: 'Autre',
          phone: '0834567890',
        ),
        throwsA(isA<PhoneAlreadyMemberException>()),
      );
    });

    test('retirer un membre referme l’ordre de passage', () {
      repository.removeMember(repository.findMember('tnt-001', 'mbr-002')!);
      expect(
        repository.membersOf('tnt-001').map((m) => m.payoutOrder),
        [1, 2, 3],
      );
    });

    test('on ne peut ni retirer ni rétrograder le dernier trésorier', () {
      final grace = repository.findMember('tnt-001', 'mbr-001')!;
      expect(
        () => repository.removeMember(grace),
        throwsA(isA<LastTreasurerException>()),
      );
      expect(
        () => repository.updateMember(grace, role: MemberRole.member),
        throwsA(isA<LastTreasurerException>()),
      );
    });

    test('à l’inscription, la fiche de membre est rattachée au compte', () {
      final users = UserRepository();
      final junior = users.create(
        fullName: 'Junior Bokele',
        email: 'junior@likelemba.test',
        phone: '0834567890',
        password: 'motdepasse',
      );
      repository.linkMembersTo(junior);
      expect(repository.membershipOf('tnt-001', junior.id), isNotNull);
    });
  });
}

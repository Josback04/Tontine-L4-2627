import 'package:likelemba_app/features/tontine/domain/entities/member.dart';
import 'package:likelemba_app/features/tontine/domain/entities/tontine.dart';

/// Les deux tontines de démonstration, vues par Grâce (usr-001).
final tMarket = Tontine(
  id: 'tnt-001',
  name: 'Mamans du marché Gambela',
  contributionAmount: 25000,
  frequency: ContributionFrequency.monthly,
  startDate: DateTime.utc(2026, 9),
  memberCount: 4,
  myRole: MemberRole.treasurer,
);

final tTeachers = Tontine(
  id: 'tnt-002',
  name: 'Enseignants de Lemba',
  contributionAmount: 10000,
  frequency: ContributionFrequency.weekly,
  startDate: DateTime.utc(2026, 9),
  memberCount: 3,
  myRole: MemberRole.member,
);

const tGrace = Member(
  id: 'mbr-001',
  fullName: 'Grâce Mbuyi',
  phone: '0812345678',
  payoutOrder: 1,
  role: MemberRole.treasurer,
  hasAccount: true,
);

const tJunior = Member(
  id: 'mbr-003',
  fullName: 'Junior Bokele',
  phone: '0834567890',
  payoutOrder: 2,
  role: MemberRole.member,
  hasAccount: false,
);

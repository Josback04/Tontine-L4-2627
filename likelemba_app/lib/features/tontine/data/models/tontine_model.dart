import 'package:likelemba_app/features/tontine/domain/entities/member.dart';
import 'package:likelemba_app/features/tontine/domain/entities/tontine.dart';

class TontineModel extends Tontine {
  const new({
    required super.id,
    required super.name,
    required super.contributionAmount,
    required super.frequency,
    required super.startDate,
    required super.memberCount,
    required super.myRole,
  });

  factory fromJson(Map<String, dynamic> json) => TontineModel(
    id: json['id'] as String,
    name: json['name'] as String,
    contributionAmount: json['contribution_amount'] as int,
    frequency:
        ContributionFrequency.values.asNameMap()[json['frequency']] ??
        ContributionFrequency.monthly,
    startDate: DateTime.parse(json['start_date'] as String),
    memberCount: json['member_count'] as int? ?? 0,
    // Le rôle arrive avec la tontine : c'est MON rôle dans CETTE tontine.
    myRole: MemberRole.values.asNameMap()[json['my_role']] ?? MemberRole.member,
  );
}

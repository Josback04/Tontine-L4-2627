import 'package:likelemba_app/features/tontine/domain/entities/member.dart';

class MemberModel extends Member {
  const new({
    required super.id,
    required super.fullName,
    required super.phone,
    required super.payoutOrder,
    required super.role,
    required super.hasAccount,
  });

  factory fromJson(Map<String, dynamic> json) => MemberModel(
    id: json['id'] as String,
    fullName: json['full_name'] as String,
    phone: json['phone'] as String? ?? '',
    payoutOrder: json['payout_order'] as int,
    role: MemberRole.values.asNameMap()[json['role']] ?? MemberRole.member,
    hasAccount: json['has_account'] as bool? ?? false,
  );
}

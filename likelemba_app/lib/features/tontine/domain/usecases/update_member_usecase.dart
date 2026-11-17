import 'package:equatable/equatable.dart';
import 'package:likelemba_app/core/usecase/usecase.dart';
import 'package:likelemba_app/features/tontine/domain/entities/member.dart';
import 'package:likelemba_app/features/tontine/domain/repositories/tontine_repository.dart';

class UpdateMemberParams extends Equatable {
  const new({
    required this.tontineId,
    required this.memberId,
    this.fullName,
    this.phone,
    this.role,
  });

  final String tontineId;
  final String memberId;
  final String? fullName;
  final String? phone;
  final MemberRole? role;

  @override
  List<Object?> get props => [tontineId, memberId, fullName, phone, role];
}

/// Modifie un membre : nom, téléphone, ou rôle dans la tontine.
class UpdateMemberUseCase implements UseCase<Member, UpdateMemberParams> {
  const new(this._repository);

  final TontineRepository _repository;

  @override
  Future<Member> call(UpdateMemberParams params) => _repository.updateMember(
    tontineId: params.tontineId,
    memberId: params.memberId,
    fullName: params.fullName?.trim(),
    phone: params.phone?.replaceAll(' ', ''),
    role: params.role,
  );
}

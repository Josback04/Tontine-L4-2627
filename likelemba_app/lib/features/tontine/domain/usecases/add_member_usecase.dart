import 'package:equatable/equatable.dart';
import 'package:likelemba_app/core/usecase/usecase.dart';
import 'package:likelemba_app/features/tontine/domain/entities/member.dart';
import 'package:likelemba_app/features/tontine/domain/repositories/tontine_repository.dart';

class AddMemberParams extends Equatable {
  const new({
    required this.tontineId,
    required this.fullName,
    required this.phone,
  });

  final String tontineId;
  final String fullName;
  final String phone;

  @override
  List<Object?> get props => [tontineId, fullName, phone];
}

/// Ajoute un membre, avec ou sans compte Likelemba.
class AddMemberUseCase implements UseCase<Member, AddMemberParams> {
  const new(this._repository);

  final TontineRepository _repository;

  @override
  Future<Member> call(AddMemberParams params) => _repository.addMember(
    tontineId: params.tontineId,
    fullName: params.fullName.trim(),
    // « 081 234 5678 » et « 0812345678 » sont le même numéro.
    phone: params.phone.replaceAll(' ', ''),
  );
}

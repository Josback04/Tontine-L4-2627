import 'package:equatable/equatable.dart';
import 'package:likelemba_app/core/usecase/usecase.dart';
import 'package:likelemba_app/features/tontine/domain/repositories/tontine_repository.dart';

class RemoveMemberParams extends Equatable {
  const new({required this.tontineId, required this.memberId});

  final String tontineId;
  final String memberId;

  @override
  List<Object?> get props => [tontineId, memberId];
}

class RemoveMemberUseCase implements UseCase<void, RemoveMemberParams> {
  const new(this._repository);

  final TontineRepository _repository;

  @override
  Future<void> call(RemoveMemberParams params) => _repository.removeMember(
    tontineId: params.tontineId,
    memberId: params.memberId,
  );
}

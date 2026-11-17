import 'package:likelemba_app/core/usecase/usecase.dart';
import 'package:likelemba_app/features/tontine/domain/entities/member.dart';
import 'package:likelemba_app/features/tontine/domain/repositories/tontine_repository.dart';

class GetMembersUseCase implements UseCase<List<Member>, String> {
  const new(this._repository);

  final TontineRepository _repository;

  @override
  Future<List<Member>> call(String tontineId) =>
      _repository.getMembers(tontineId);
}

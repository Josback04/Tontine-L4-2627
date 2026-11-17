import 'package:likelemba_app/core/usecase/usecase.dart';
import 'package:likelemba_app/features/tontine/domain/entities/tontine.dart';
import 'package:likelemba_app/features/tontine/domain/repositories/tontine_repository.dart';

class GetTontineUseCase implements UseCase<Tontine, String> {
  const new(this._repository);

  final TontineRepository _repository;

  @override
  Future<Tontine> call(String tontineId) => _repository.getTontine(tontineId);
}

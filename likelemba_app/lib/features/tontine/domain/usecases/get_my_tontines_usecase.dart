import 'package:likelemba_app/core/usecase/usecase.dart';
import 'package:likelemba_app/features/tontine/domain/entities/tontine.dart';
import 'package:likelemba_app/features/tontine/domain/repositories/tontine_repository.dart';

/// Mes tontines : d'abord celles que je gère, puis par nom.
class GetMyTontinesUseCase implements UseCase<List<Tontine>, NoParams> {
  const new(this._repository);

  final TontineRepository _repository;

  @override
  Future<List<Tontine>> call(NoParams params) async {
    final tontines = await _repository.getMyTontines();
    return [...tontines]..sort((a, b) {
      if (a.canManage != b.canManage) return a.canManage ? -1 : 1;
      return a.name.compareTo(b.name);
    });
  }
}

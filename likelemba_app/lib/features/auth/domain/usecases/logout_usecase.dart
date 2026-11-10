import 'package:likelemba_app/core/usecase/usecase.dart';
import 'package:likelemba_app/features/auth/domain/repositories/auth_repository.dart';

/// Ferme la session.
class LogoutUseCase implements UseCase<void, NoParams> {
  const new(this._repository);

  final AuthRepository _repository;

  @override
  Future<void> call(NoParams params) => _repository.logout();
}

import 'package:likelemba_app/core/usecase/usecase.dart';
import 'package:likelemba_app/features/auth/domain/entities/user.dart';
import 'package:likelemba_app/features/auth/domain/repositories/auth_repository.dart';

/// Restaure la session au démarrage de l'application.
class GetCurrentUserUseCase implements UseCase<User?, NoParams> {
  const new(this._repository);

  final AuthRepository _repository;

  @override
  Future<User?> call(NoParams params) => _repository.getCurrentUser();
}

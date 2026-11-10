import 'package:equatable/equatable.dart';
import 'package:likelemba_app/core/usecase/usecase.dart';
import 'package:likelemba_app/features/auth/domain/entities/user.dart';
import 'package:likelemba_app/features/auth/domain/repositories/auth_repository.dart';

class LoginParams extends Equatable {
  const new({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

/// Connecte un utilisateur existant.
class LoginUseCase implements UseCase<User, LoginParams> {
  const new(this._repository);

  final AuthRepository _repository;

  @override
  Future<User> call(LoginParams params) => _repository.login(
    // Règle métier : l'e-mail ne dépend ni de la casse ni des espaces.
    email: params.email.trim().toLowerCase(),
    password: params.password,
  );
}

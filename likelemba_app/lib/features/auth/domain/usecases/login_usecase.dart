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

/// CAS D'USAGE : « se connecter ».
///
/// Une classe = une action de l'utilisateur. Il porte la règle métier
/// (ici : l'e-mail est comparé sans espaces ni majuscules) et délègue le
/// reste au contrat AuthRepository, dont il ne connaît pas l'implémentation.
class LoginUseCase implements UseCase<User, LoginParams> {
  const new(this._repository);

  final AuthRepository _repository;

  @override
  Future<User> call(LoginParams params) => _repository.login(
    email: params.email.trim().toLowerCase(),
    password: params.password,
  );
}

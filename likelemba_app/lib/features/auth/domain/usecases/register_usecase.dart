import 'package:equatable/equatable.dart';
import 'package:likelemba_app/core/usecase/usecase.dart';
import 'package:likelemba_app/features/auth/domain/entities/user.dart';
import 'package:likelemba_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterParams extends Equatable {
  const new({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
  });

  final String fullName;
  final String email;
  final String phone;
  final String password;

  @override
  List<Object?> get props => [fullName, email, phone, password];
}

/// Crée un compte de trésorier, puis ouvre sa session.
class RegisterUseCase implements UseCase<User, RegisterParams> {
  const new(this._repository);

  final AuthRepository _repository;

  @override
  Future<User> call(RegisterParams params) => _repository.register(
    fullName: params.fullName.trim(),
    email: params.email.trim().toLowerCase(),
    phone: params.phone.replaceAll(' ', ''),
    password: params.password,
  );
}

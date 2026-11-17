part of 'auth_bloc.dart';

/// Ce que l'utilisateur (ou le système) FAIT.
///
sealed class AuthEvent extends Equatable {
  const new();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  const new({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

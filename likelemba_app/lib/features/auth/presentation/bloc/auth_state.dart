part of 'auth_bloc.dart';

@CopyWith()
class AuthState extends Equatable {
  const new({
    this.loginState = AuthenticationState.unauthenticated,
    this.user,
    this.message,
  });

  final AuthenticationState loginState;
  final User? user;

  /// Message d'erreur ou d'information, déjà traduit.
  final String? message;

  @override
  List<Object?> get props => [loginState, user, message];
}

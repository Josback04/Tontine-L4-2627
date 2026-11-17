part of 'auth_bloc.dart';

/// L'état UNIQUE et immuable de la feature.
///
/// Un statut par action + les données + un message. `@CopyWith()` génère
/// `state.copyWith(...)` dans auth_bloc.g.dart :
/// `dart run build_runner build -d` après chaque changement de champ.
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

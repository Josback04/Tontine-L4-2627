part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

final class AuthState extends Equatable {
  const new _({required this.status, this.user, this.sessionExpired = false});

  /// Avant la lecture de la session : l'écran de démarrage.
  const new unknown() : this._(status: AuthStatus.unknown);

  const new authenticated(User user)
    : this._(status: AuthStatus.authenticated, user: user);

  const new unauthenticated({bool sessionExpired = false})
    : this._(
        status: AuthStatus.unauthenticated,
        sessionExpired: sessionExpired,
      );

  final AuthStatus status;
  final User? user;

  /// Vrai si la déconnexion vient d'un jeton expiré, pas de l'utilisateur.
  final bool sessionExpired;

  @override
  List<Object?> get props => [status, user, sessionExpired];
}

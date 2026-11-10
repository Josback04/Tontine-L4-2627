part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const new();

  @override
  List<Object?> get props => [];
}

/// Au démarrage : restaurer la session enregistrée, s'il y en a une.
final class AuthStarted extends AuthEvent {
  const new();
}

/// Après une connexion ou une inscription réussie.
final class AuthUserAuthenticated extends AuthEvent {
  const new(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

final class AuthLogoutRequested extends AuthEvent {
  const new();
}

/// L'API a répondu 401 sur une route protégée.
final class AuthSessionExpired extends AuthEvent {
  const new();
}

part of 'auth_bloc.dart';

/// Ce que l'utilisateur (ou le système) FAIT.
///
/// `sealed` : tous les événements du BLoC sont déclarés dans ce fichier.
/// `Equatable` : deux événements aux mêmes valeurs sont égaux (tests).
sealed class AuthEvent extends Equatable {
  const new();

  @override
  List<Object?> get props => [];
}

/// Clic sur « Se connecter ».
class LoginEvent extends AuthEvent {
  const new({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

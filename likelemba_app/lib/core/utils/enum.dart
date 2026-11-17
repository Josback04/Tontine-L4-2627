/// Les statuts partagés par les BLoC de toute l'application.
///
/// Chaque State garde UN statut par action (loginState, deleteState…) :
/// une action qui charge ou échoue n'efface pas les données déjà à l'écran.
library;

/// Statut générique d'une action : chargement, envoi d'un formulaire…
enum BlocState { initial, loading, success, failed }

/// Statut de la connexion de l'utilisateur.
enum AuthenticationState { unauthenticated, loading, authenticated, failed }

extension BlocStateX on BlocState {
  bool get isInitial => this == BlocState.initial;
  bool get isInProgress => this == BlocState.loading;
  bool get isSuccess => this == BlocState.success;
  bool get isFailed => this == BlocState.failed;
}

extension AuthenticationStateX on AuthenticationState {
  bool get isUnauthenticated => this == AuthenticationState.unauthenticated;
  bool get isInProgress => this == AuthenticationState.loading;
  bool get isAuthenticated => this == AuthenticationState.authenticated;
  bool get isFailed => this == AuthenticationState.failed;
}

import 'package:equatable/equatable.dart';

/// Échec métier, compris par le domaine et l'interface.

/// Les dépôts (data/) traduisent les exceptions techniques en Failure ;
/// les blocs (presentation/) transforment une Failure en message à l'écran.
/// Chaque feature peut déclarer ses propres Failure (voir
/// features/auth/domain/failures/).
abstract class Failure extends Equatable implements Exception {
  const new();

  @override
  List<Object?> get props => [];
}

/// L'API est injoignable.
class NetworkFailure extends Failure {
  const new();
}

/// L'API a répondu par une erreur inattendue.
class ServerFailure extends Failure {
  const new();
}

/// La session a expiré : il faut se reconnecter.
class SessionExpiredFailure extends Failure {
  const new();
}

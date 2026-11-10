import 'package:equatable/equatable.dart';

/// Contrat commun à tous les cas d'usage du domaine.
///
/// Un cas d'usage = une action métier = une classe, appelée comme une
/// fonction : `await login(LoginParams(...))`.
/// En cas d'échec, il lève une Failure (voir core/errors/failures.dart).
abstract interface class UseCase<Result, Params> {
  Future<Result> call(Params params);
}

/// Pour les cas d'usage sans paramètre.
class NoParams extends Equatable {
  const new();

  @override
  List<Object?> get props => [];
}

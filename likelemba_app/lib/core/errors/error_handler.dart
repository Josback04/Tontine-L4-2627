import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:likelemba_app/core/errors/exceptions.dart';
import 'package:likelemba_app/core/errors/failures.dart';

export 'package:either_dart/either.dart';

/// Exécute [action] et range le résultat dans un Either :
/// - `Right(résultat)` si tout s'est bien passé ;
/// - `Left(Failure)` si une erreur a été levée, quelle qu'elle soit.
///
/// Les BLoC n'écrivent donc plus de try / catch : ils enchaînent
/// `errorHandler(() async { … }).either((left) => …, (right) => …)`.
Future<Either<Failure, T>> errorHandler<T>(Future<T> Function() action) async {
  try {
    return Right(await action());
  } on Failure catch (failure) {
    // Déjà une erreur métier (levée par le dépôt) : on la garde telle quelle.
    return Left(failure);
  } on NetworkException {
    return const Left(NetworkFailure());
  } on DioException catch (error) {
    // Pas de réponse = pas de réseau, serveur arrêté ou délai dépassé.
    return Left(
      error.response == null ? const NetworkFailure() : const ServerFailure(),
    );
  } on Object {
    // Toute autre erreur imprévue : jamais de plantage à l'écran.
    return const Left(ServerFailure());
  }
}

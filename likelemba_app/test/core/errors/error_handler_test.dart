import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/core/errors/error_handler.dart';
import 'package:likelemba_app/core/errors/failures.dart';

void main() {
  group('errorHandler', () {
    test('succès : Right(résultat)', () async {
      final result = await errorHandler(() async => 42);
      expect(result, const Right<Failure, int>(42));
    });

    test('Failure levée : Left(la même Failure)', () async {
      final result = await errorHandler<int>(
        () async => throw const ServerFailure(),
      );
      expect(result.left, const ServerFailure());
    });

    test('DioException sans réponse : Left(NetworkFailure)', () async {
      final result = await errorHandler<int>(
        () async => throw DioException(requestOptions: RequestOptions()),
      );
      expect(result.left, const NetworkFailure());
    });

    test('erreur imprévue : Left(ServerFailure)', () async {
      final result = await errorHandler<int>(
        () async => throw StateError('bug'),
      );
      expect(result.left, const ServerFailure());
    });
  });
}

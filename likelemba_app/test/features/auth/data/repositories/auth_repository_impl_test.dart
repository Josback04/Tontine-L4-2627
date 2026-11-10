import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/core/errors/exceptions.dart';
import 'package:likelemba_app/core/errors/failures.dart';
import 'package:likelemba_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:likelemba_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:likelemba_app/features/auth/data/models/auth_response_model.dart';
import 'package:likelemba_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:likelemba_app/features/auth/domain/failures/auth_failures.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource;

class _MockLocal extends Mock implements AuthLocalDataSource;

void main() {
  late AuthRemoteDataSource remote;
  late AuthLocalDataSource local;
  late AuthRepositoryImpl repository;

  const response = AuthResponseModel(token: 'jeton', user: tUserModel);

  setUpAll(() => registerFallbackValue(tUserModel));

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repository = AuthRepositoryImpl(remote: remote, local: local);
    when(
      () => local.saveSession(
        token: any(named: 'token'),
        user: any(named: 'user'),
      ),
    ).thenAnswer((_) async {});
    when(() => local.clearSession()).thenAnswer((_) async {});
  });

  When<Future<AuthResponseModel>> whenLogin() => when(
    () => remote.login(
      email: any(named: 'email'),
      password: any(named: 'password'),
    ),
  );

  group('login', () {
    test("enregistre la session et renvoie l'utilisateur", () async {
      whenLogin().thenAnswer((_) async => response);

      final user = await repository.login(email: 'e', password: 'p');

      expect(user, tUser);
      verify(() => local.saveSession(token: 'jeton', user: tUserModel))
          .called(1);
    });

    test('invalid_credentials devient InvalidCredentialsFailure', () {
      whenLogin().thenThrow(
        const ServerException(statusCode: 401, code: 'invalid_credentials'),
      );
      expect(
        () => repository.login(email: 'e', password: 'p'),
        throwsA(isA<InvalidCredentialsFailure>()),
      );
    });

    test('NetworkException devient NetworkFailure', () {
      whenLogin().thenThrow(const NetworkException());
      expect(
        () => repository.login(email: 'e', password: 'p'),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('un code inconnu devient ServerFailure', () {
      whenLogin().thenThrow(const ServerException(statusCode: 500));
      expect(
        () => repository.login(email: 'e', password: 'p'),
        throwsA(isA<ServerFailure>()),
      );
    });
  });

  group('getCurrentUser', () {
    test('null sans jeton, sans appeler l’API', () async {
      when(() => local.getToken()).thenReturn(null);
      expect(await repository.getCurrentUser(), isNull);
      verifyNever(() => remote.me());
    });

    test('demande /users/me quand un jeton existe', () async {
      when(() => local.getToken()).thenReturn('jeton');
      when(() => remote.me()).thenAnswer((_) async => tUserModel);
      expect(await repository.getCurrentUser(), tUser);
    });

    test('hors ligne : renvoie l’utilisateur en cache', () async {
      when(() => local.getToken()).thenReturn('jeton');
      when(() => remote.me()).thenThrow(const NetworkException());
      when(() => local.getCachedUser()).thenReturn(tUserModel);
      expect(await repository.getCurrentUser(), tUser);
    });

    test('jeton refusé (401) : vide la session et renvoie null', () async {
      when(() => local.getToken()).thenReturn('jeton');
      when(() => remote.me()).thenThrow(const ServerException(statusCode: 401));
      expect(await repository.getCurrentUser(), isNull);
      verify(() => local.clearSession()).called(1);
    });
  });
}

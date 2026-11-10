import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/core/errors/exceptions.dart';
import 'package:likelemba_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

class _MockDio extends Mock implements Dio;

void main() {
  late Dio dio;
  late AuthRemoteDataSourceImpl source;

  setUp(() {
    dio = _MockDio();
    source = AuthRemoteDataSourceImpl(dio);
  });

  Response<Map<String, dynamic>> ok(Map<String, dynamic> data) =>
      Response(data: data, statusCode: 200, requestOptions: RequestOptions());

  DioException httpError(int status, Object? body) => DioException(
    requestOptions: RequestOptions(),
    response: Response(
      statusCode: status,
      data: body,
      requestOptions: RequestOptions(),
    ),
  );

  When<Future<Response<Map<String, dynamic>>>> whenPost(String path) => when(
    () => dio.post<Map<String, dynamic>>(path, data: any(named: 'data')),
  );

  group('login', () {
    test('POST /auth/login et lit token + user', () async {
      whenPost('/auth/login')
          .thenAnswer((_) async => ok({'token': 'jeton', 'user': tUserJson}));

      final response = await source.login(email: 'e', password: 'p');

      expect(response.token, 'jeton');
      expect(response.user, tUserModel);
      verify(
        () => dio.post<Map<String, dynamic>>(
          '/auth/login',
          data: {'email': 'e', 'password': 'p'},
        ),
      ).called(1);
    });

    test("une réponse d'erreur devient ServerException avec son code", () {
      whenPost('/auth/login').thenThrow(
        httpError(401, {'code': 'invalid_credentials', 'message': '...'}),
      );
      expect(
        () => source.login(email: 'e', password: 'p'),
        throwsA(
          isA<ServerException>()
              .having((e) => e.statusCode, 'statusCode', 401)
              .having((e) => e.code, 'code', 'invalid_credentials'),
        ),
      );
    });

    test('sans réponse (serveur injoignable) : NetworkException', () {
      whenPost('/auth/login')
          .thenThrow(DioException(requestOptions: RequestOptions()));
      expect(
        () => source.login(email: 'e', password: 'p'),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  test('register envoie les champs en snake_case', () async {
    whenPost('/auth/register')
        .thenAnswer((_) async => ok({'token': 'jeton', 'user': tUserJson}));

    await source.register(
      fullName: 'Grâce Mbuyi',
      email: 'e',
      phone: '0812345678',
      password: 'p',
    );

    verify(
      () => dio.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'full_name': 'Grâce Mbuyi',
          'email': 'e',
          'phone': '0812345678',
          'password': 'p',
        },
      ),
    ).called(1);
  });

  group('me', () {
    test('GET /users/me', () async {
      when(() => dio.get<Map<String, dynamic>>('/users/me'))
          .thenAnswer((_) async => ok({'user': tUserJson}));
      expect(await source.me(), tUserModel);
    });

    test('401 : ServerException(401) même sans corps JSON', () {
      when(() => dio.get<Map<String, dynamic>>('/users/me'))
          .thenThrow(httpError(401, 'Unauthorized'));
      expect(
        source.me,
        throwsA(
          isA<ServerException>()
              .having((e) => e.statusCode, 'statusCode', 401)
              .having((e) => e.code, 'code', 'unknown'),
        ),
      );
    });
  });
}

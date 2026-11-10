import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/core/network/auth_interceptor.dart';
import 'package:mocktail/mocktail.dart';

class _MockRequestHandler extends Mock implements RequestInterceptorHandler;

class _MockErrorHandler extends Mock implements ErrorInterceptorHandler;

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions());
    registerFallbackValue(DioException(requestOptions: RequestOptions()));
  });

  late String? token;
  late int clears;
  late Completer<void> expired;
  late AuthInterceptor interceptor;

  setUp(() {
    token = null;
    clears = 0;
    expired = Completer<void>();
    interceptor = AuthInterceptor(
      readToken: () => token,
      clearSession: () async => clears++,
      onSessionExpired: expired.complete,
    );
  });

  DioException error(String path, int status) => DioException(
    requestOptions: RequestOptions(path: path),
    response: Response(
      statusCode: status,
      requestOptions: RequestOptions(path: path),
    ),
  );

  group(AuthInterceptor, () {
    test('ajoute Authorization quand un jeton existe', () {
      token = 'jeton';
      final options = RequestOptions(path: '/users/me');
      interceptor.onRequest(options, _MockRequestHandler());
      expect(options.headers['Authorization'], 'Bearer jeton');
    });

    test("n'ajoute rien sans jeton", () {
      final options = RequestOptions(path: '/auth/login');
      interceptor.onRequest(options, _MockRequestHandler());
      expect(options.headers.containsKey('Authorization'), isFalse);
    });

    test(
      '401 sur une route protégée : vide la session puis prévient',
      () async {
        interceptor.onError(error('/users/me', 401), _MockErrorHandler());
        await expired.future;
        expect(clears, 1);
      },
    );

    test("401 sur /auth/login (mauvais mot de passe) : rien d'autre", () async {
      interceptor.onError(error('/auth/login', 401), _MockErrorHandler());
      await Future<void>.delayed(Duration.zero);
      expect(clears, 0);
      expect(expired.isCompleted, isFalse);
    });
  });
}

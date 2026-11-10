import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:likelemba_backend/likelemba_backend.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../routes/auth/login.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  group('POST /auth/login', () {
    late RequestContext context;

    setUp(() {
      context = _MockRequestContext();
      when(() => context.read<UserRepository>()).thenReturn(UserRepository());
      when(() => context.read<TokenService>()).thenReturn(
        const TokenService(secret: 'test', ttl: Duration(minutes: 5)),
      );
    });

    void withBody(Object body, {HttpMethod method = HttpMethod.post}) {
      when(() => context.request).thenReturn(
        Request(
          method.value,
          Uri.parse('http://localhost/auth/login'),
          body: jsonEncode(body),
        ),
      );
    }

    test('200 avec un jeton et l’utilisateur', () async {
      withBody({
        'email': 'tresorier1@likelemba.test',
        'password': UserRepository.demoPassword,
      });
      final response = await route.onRequest(context);
      expect(response.statusCode, HttpStatus.ok);
      final json = await response.json() as Map<String, dynamic>;
      expect(json['token'], isA<String>());
      expect((json['user'] as Map)['email'], 'tresorier1@likelemba.test');
    });

    test('401 invalid_credentials', () async {
      withBody({'email': 'tresorier1@likelemba.test', 'password': 'non'});
      final response = await route.onRequest(context);
      expect(response.statusCode, HttpStatus.unauthorized);
      expect(
        await response.json(),
        containsPair('code', 'invalid_credentials'),
      );
    });

    test('400 si le corps est incomplet', () async {
      withBody({'email': 'tresorier1@likelemba.test'});
      final response = await route.onRequest(context);
      expect(response.statusCode, HttpStatus.badRequest);
    });

    test('405 pour un GET', () async {
      withBody({}, method: HttpMethod.get);
      final response = await route.onRequest(context);
      expect(response.statusCode, HttpStatus.methodNotAllowed);
    });
  });
}

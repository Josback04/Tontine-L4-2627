import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:likelemba_backend/likelemba_backend.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../../../../../routes/tontines/[id]/members/index.dart' as route;

class _MockRequestContext extends Mock implements RequestContext {}

void main() {
  late RequestContext context;
  late TontineRepository tontines;
  final users = UserRepository();

  setUp(() {
    context = _MockRequestContext();
    tontines = TontineRepository();
    when(() => context.read<TontineRepository>()).thenReturn(tontines);
    when(() => context.read<UserRepository>()).thenReturn(users);
  });

  void as(String userId, HttpMethod method, [Object? body]) {
    when(() => context.read<User>()).thenReturn(users.findById(userId)!);
    when(() => context.request).thenReturn(
      Request(
        method.value,
        Uri.parse('http://localhost/tontines/x/members'),
        body: body == null ? null : jsonEncode(body),
      ),
    );
  }

  const newMember = {'full_name': 'Sarah Kalala', 'phone': '0899990000'};

  group('POST /tontines/:id/members', () {
    test('201 pour Grâce dans tnt-001, où elle est trésorière', () async {
      as('usr-001', HttpMethod.post, newMember);
      final response = await route.onRequest(context, 'tnt-001');
      expect(response.statusCode, HttpStatus.created);
    });

    test('403 pour Grâce dans tnt-002, où elle est simple membre', () async {
      as('usr-001', HttpMethod.post, newMember);
      final response = await route.onRequest(context, 'tnt-002');
      expect(response.statusCode, HttpStatus.forbidden);
      expect(await response.json(), containsPair('code', 'not_treasurer'));
    });

    test('404 pour une tontine dont on n’est pas membre', () async {
      as('usr-003', HttpMethod.post, newMember);
      final response = await route.onRequest(context, 'tnt-002');
      expect(response.statusCode, HttpStatus.notFound);
    });

    test('422 pour un téléphone invalide', () async {
      as('usr-001', HttpMethod.post, {'full_name': 'Sarah', 'phone': '123'});
      final response = await route.onRequest(context, 'tnt-001');
      expect(response.statusCode, HttpStatus.unprocessableEntity);
    });
  });

  test('GET : un simple membre voit la liste', () async {
    as('usr-001', HttpMethod.get);
    final response = await route.onRequest(context, 'tnt-002');
    expect(response.statusCode, HttpStatus.ok);
    final json = await response.json() as Map<String, dynamic>;
    expect(json['members'], hasLength(3));
  });
}

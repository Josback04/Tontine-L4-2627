// API de test de Likelemba
//
//   dart run bin/server.dart
//   AUTH=on dart run bin/server.dart
//   AUTH=on DEFI=on dart run bin/server.dart
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

final bool authEnabled = Platform.environment['AUTH'] == 'on';
final bool defiEnabled = Platform.environment['DEFI'] == 'on';
const Duration tokenTtl = Duration(minutes: 2);
const String demoPassword = 'likelemba2026';

/// Un trésorier par groupe : l'adresse e-mail donne l'identifiant du groupe.
const Map<String, String> treasurers = {
  'tresorier1@likelemba.test': 'grp-001',
  'tresorier2@likelemba.test': 'grp-002',
};

final Map<String, DateTime> tokens = {};
final DateTime now = DateTime.now().toUtc();

Map<String, Object?> contribution(
  String id,
  String groupId,
  String member,
  int amount,
  int inDays, {
  bool paid = false,
  bool paidAtKnown = true,
  String phone = '',
  int round = 3,
  bool beneficiary = false,
  int partial = 0,
  int reminders = 0,
}) {
  final due = now.add(Duration(days: inDays));
  return {
    'id': id,
    'group_id': groupId,
    'member_name': member,
    'amount': amount,
    'due_date': due.toIso8601String(),
    'is_paid': paid,
    'member_phone': phone, // toujours présent : variante d'entraînement
    if (defiEnabled) ...{
      'is_beneficiary': beneficiary,
      'amount_paid': paid ? amount : partial,
      'penalty_per_day': 500,
      'reminder_count': reminders,
      'round_number': round,
      'paid_at': paid && paidAtKnown
          ? due.subtract(const Duration(days: 1)).toIso8601String()
          : null,
    },
  };
}

final Map<String, Map<String, Object?>> db = {
  for (final c in [
    contribution(
      'c-101',
      'grp-001',
      'Grâce Mbuyi',
      25000,
      3,
      phone: '0812345678',
    ),
    contribution(
      'c-102',
      'grp-001',
      'Patrick Kabongo',
      25000,
      -2,
      partial: 10000,
      reminders: 2,
    ),
    contribution(
      'c-103',
      'grp-001',
      'Esther Lukusa',
      25000,
      -5,
      phone: '0998765432',
      reminders: 1,
    ),
    contribution(
      'c-104',
      'grp-001',
      'Junior Bokele',
      25000,
      3,
      paid: true,
      paidAtKnown: false,
      phone: '0823456789',
    ),
    contribution(
      'c-105',
      'grp-001',
      'Ruth Nzuzi',
      25000,
      3,
      beneficiary: true,
      phone: '0854321098',
    ),
    contribution(
      'c-106',
      'grp-001',
      'Daniel Mputu',
      25000,
      -30,
      paid: true,
      round: 2,
      phone: '0811112222',
    ),
    contribution(
      'c-201',
      'grp-002',
      'Sarah Kalala',
      10000,
      7,
      phone: '0899990000',
    ),
  ])
    c['id']! as String: c,
};

Response jsonResponse(Object? body, {int status = 200}) => Response(
  status,
  body: jsonEncode(body),
  headers: {'content-type': 'application/json'},
);

String b64(Map<String, Object?> part) =>
    base64Url.encode(utf8.encode(jsonEncode(part))).replaceAll('=', '');

Middleware checkAuth() =>
    (Handler inner) => (Request request) {
      if (!authEnabled || request.url.path == 'auth/login') {
        return inner(request);
      }
      final header = request.headers['authorization'] ?? '';
      final token = header.startsWith('Bearer ') ? header.substring(7) : '';
      final expiresAt = tokens[token];
      if (expiresAt == null || expiresAt.isBefore(DateTime.now())) {
        return jsonResponse({'error': 'unauthorized'}, status: 401);
      }
      return inner(request);
    };

Future<Response> login(Request request) async {
  final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
  final groupId = treasurers[body['email']];
  if (groupId == null || body['password'] != demoPassword) {
    return jsonResponse({'error': 'invalid_credentials'}, status: 401);
  }
  final expiresAt = DateTime.now().add(tokenTtl);
  // Format JWT pour que l'application puisse lire sub, mais NON signé.
  final token = [
    b64({'alg': 'none', 'typ': 'JWT'}),
    b64({'sub': groupId, 'exp': expiresAt.millisecondsSinceEpoch ~/ 1000}),
    'demo',
  ].join('.');
  tokens[token] = expiresAt;
  return jsonResponse({'token': token, 'group_id': groupId});
}

Response listContributions(Request request, String groupId) =>
    jsonResponse(db.values.where((c) => c['group_id'] == groupId).toList());

Future<Response> updatePayment(Request request, String id) async {
  final current = db[id];
  if (current == null) return jsonResponse({'error': 'not_found'}, status: 404);
  final body = jsonDecode(await request.readAsString()) as Map<String, dynamic>;
  current['is_paid'] = body['is_paid'] == true;
  return jsonResponse(current);
}

Future<void> main() async {
  final app = Router()
    ..post('/auth/login', login)
    ..get('/groups/<groupId>/contributions', listContributions)
    ..patch('/contributions/<id>', updatePayment);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(checkAuth())
      .addHandler(app.call);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await io.serve(handler, InternetAddress.anyIPv4, port);
  print(
    'API Likelemba sur le port ${server.port} '
    '(auth : $authEnabled, défi : $defiEnabled)',
  );
}

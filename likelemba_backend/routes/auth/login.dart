import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:likelemba_backend/likelemba_backend.dart';

/// POST /auth/login
/// Corps : `{"email": "...", "password": "..."}`
/// 200 : `{"token": "...", "user": {...}}`
/// 401 : code `invalid_credentials`
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) return methodNotAllowed();

  final body = await readJsonObject(context);
  final email = body?['email'];
  final password = body?['password'];
  if (email is! String || password is! String) {
    return apiError(
      HttpStatus.badRequest,
      'invalid_body',
      'email et password sont obligatoires',
    );
  }

  final user = context.read<UserRepository>().authenticate(email, password);
  if (user == null) {
    return apiError(
      HttpStatus.unauthorized,
      'invalid_credentials',
      'E-mail ou mot de passe incorrect',
    );
  }

  final token = context.read<TokenService>().issue(user);
  return Response.json(body: {'token': token, 'user': user.toJson()});
}

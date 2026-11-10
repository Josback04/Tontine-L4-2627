import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:likelemba_backend/likelemba_backend.dart';

/// POST /auth/register
/// Corps : `{"full_name", "email", "phone", "password"}`
/// 201 : `{"token": "...", "user": {...}}`
/// 409 : code `email_already_used` ; 422 : code `validation_error`
Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) return methodNotAllowed();

  final body = await readJsonObject(context);
  final fullName = body?['full_name'];
  final email = body?['email'];
  final phone = body?['phone'];
  final password = body?['password'];
  if (fullName is! String ||
      email is! String ||
      phone is! String ||
      password is! String) {
    return apiError(
      HttpStatus.badRequest,
      'invalid_body',
      'full_name, email, phone et password sont obligatoires',
    );
  }
  if (fullName.trim().length < 2 ||
      !email.contains('@') ||
      password.length < 8) {
    return apiError(
      HttpStatus.unprocessableEntity,
      'validation_error',
      'Nom trop court, e-mail invalide ou mot de passe trop court (8 min.)',
    );
  }

  try {
    final user = context.read<UserRepository>().create(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
    );
    final token = context.read<TokenService>().issue(user);
    return Response.json(
      statusCode: HttpStatus.created,
      body: {'token': token, 'user': user.toJson()},
    );
  } on EmailAlreadyUsedException {
    return apiError(
      HttpStatus.conflict,
      'email_already_used',
      'Un compte existe déjà avec cet e-mail',
    );
  }
}

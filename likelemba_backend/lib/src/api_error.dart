import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

/// Toutes les erreurs de l'API ont la même forme :
/// `{"code": "invalid_credentials", "message": "..."}`.
/// L'application lit `code`, jamais `message` (destiné aux développeurs).
Response apiError(int statusCode, String code, String message) => Response.json(
  statusCode: statusCode,
  body: {'code': code, 'message': message},
);

Response methodNotAllowed() => apiError(
  HttpStatus.methodNotAllowed,
  'method_not_allowed',
  'Méthode non autorisée',
);

/// Lit un corps JSON objet, ou null s'il est absent ou mal formé.
Future<Map<String, dynamic>?> readJsonObject(RequestContext context) async {
  try {
    final body = await context.request.json();
    return body is Map<String, dynamic> ? body : null;
  } on FormatException {
    return null;
  }
}

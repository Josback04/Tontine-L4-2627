import 'package:dart_frog/dart_frog.dart';
import 'package:likelemba_backend/likelemba_backend.dart';

/// GET /users/me : l'utilisateur du jeton.
/// 200 : `{"user": {...}}` ; 401 si le jeton est absent, invalide ou expiré.
Response onRequest(RequestContext context) {
  if (context.request.method != HttpMethod.get) return methodNotAllowed();
  final user = context.read<User>();
  return Response.json(body: {'user': user.toJson()});
}

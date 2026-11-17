import 'package:dart_frog/dart_frog.dart';
import 'package:likelemba_backend/likelemba_backend.dart';

/// GET /tontines/:id : la tontine et mon rôle dedans.
Response onRequest(RequestContext context, String id) {
  if (context.request.method != HttpMethod.get) return methodNotAllowed();
  final access = accessTo(context, id);
  if (access == null) return tontineNotFound();
  final count = context.read<TontineRepository>().membersOf(id).length;
  return Response.json(body: {'tontine': tontineJson(access, count)});
}

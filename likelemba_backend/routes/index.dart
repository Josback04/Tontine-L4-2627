import 'package:dart_frog/dart_frog.dart';

/// GET / : l'API répond-elle ?
Response onRequest(RequestContext context) =>
    Response.json(body: {'name': 'likelemba_api', 'status': 'ok'});

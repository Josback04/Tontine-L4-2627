import 'package:dart_frog/dart_frog.dart';
import 'package:likelemba_backend/likelemba_backend.dart';

/// Toutes les routes de /users exigent un jeton valide.
Handler middleware(Handler handler) => handler.use(requireUser());

import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:likelemba_backend/likelemba_backend.dart';

/// Toutes les routes de /users exigent `Authorization: Bearer <jeton>`.
/// Sans jeton valide, dart_frog_auth répond 401 avant d'atteindre la route.
Handler middleware(Handler handler) => handler.use(
  bearerAuthentication<User>(
    authenticator: (context, token) async {
      final userId = context.read<TokenService>().verify(token);
      if (userId == null) return null;
      return context.read<UserRepository>().findById(userId);
    },
  ),
);

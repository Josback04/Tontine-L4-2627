import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_auth/dart_frog_auth.dart';
import 'package:likelemba_backend/src/token_service.dart';
import 'package:likelemba_backend/src/user.dart';
import 'package:likelemba_backend/src/user_repository.dart';

/// Exige `Authorization: Bearer <jeton>` et fournit le [User] aux routes
/// (`context.read<User>()`). Sans jeton valide : 401 avant la route.
Middleware requireUser() => bearerAuthentication<User>(
  authenticator: (context, token) async {
    final userId = context.read<TokenService>().verify(token);
    if (userId == null) return null;
    return context.read<UserRepository>().findById(userId);
  },
);

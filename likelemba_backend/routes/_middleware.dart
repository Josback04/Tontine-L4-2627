import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:likelemba_backend/likelemba_backend.dart';

final _ttlMinutes = Platform.environment['TOKEN_TTL_MINUTES'];

// Créés une seule fois au démarrage : les comptes vivent en mémoire.
final _userRepository = UserRepository();
final _tontineRepository = TontineRepository();
final _tokenService = TokenService(
  secret: Platform.environment['JWT_SECRET'] ?? 'likelemba-dev-secret',
  // TOKEN_TTL_MINUTES=2 pour provoquer le scénario « session expirée ».
  ttl: Duration(minutes: int.tryParse(_ttlMinutes ?? '') ?? 60),
);

/// Point d'injection de l'API : chaque route lit ses dépendances avec
/// `context.read<T>()`, sans jamais les construire elle-même.
Handler middleware(Handler handler) => handler
    .use(provider<TokenService>((_) => _tokenService))
    .use(provider<UserRepository>((_) => _userRepository))
    .use(provider<TontineRepository>((_) => _tontineRepository))
    .use(requestLogger());

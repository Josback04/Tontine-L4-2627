import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:likelemba_backend/src/user.dart';

/// Émet et vérifie les jetons JWT signés (HS256).
class TokenService {
  const TokenService({required this.secret, required this.ttl});

  final String secret;
  final Duration ttl;

  /// Le jeton porte l'identifiant de l'utilisateur dans `sub`.
  String issue(User user) => JWT(
    <String, Object?>{},
    subject: user.id,
    issuer: 'likelemba',
  ).sign(SecretKey(secret), expiresIn: ttl);

  /// Renvoie l'identifiant de l'utilisateur, ou null si le jeton est
  /// invalide ou expiré.
  String? verify(String token) {
    try {
      return JWT.verify(token, SecretKey(secret)).subject;
    } on JWTException {
      return null;
    }
  }
}

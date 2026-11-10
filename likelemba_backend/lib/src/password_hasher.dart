import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Hache les mots de passe avec un sel fixe.
///
/// Suffisant pour une API d'enseignement. En production : bcrypt ou argon2,
/// avec un sel aléatoire par utilisateur.
class PasswordHasher {
  const PasswordHasher({this.salt = 'likelemba-salt'});

  final String salt;

  String hash(String password) =>
      sha256.convert(utf8.encode('$salt:$password')).toString();

  bool verify(String password, String hash) => this.hash(password) == hash;
}

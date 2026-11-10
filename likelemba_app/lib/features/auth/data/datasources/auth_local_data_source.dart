import 'dart:convert';

import 'package:likelemba_app/core/errors/exceptions.dart';
import 'package:likelemba_app/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Garde la session sur le téléphone : le jeton et le dernier utilisateur.
abstract interface class AuthLocalDataSource {
  /// Lecture synchrone : AuthInterceptor l'appelle à chaque requête.
  String? getToken();

  /// Lève [CacheException] si aucun utilisateur n'est enregistré.
  UserModel getCachedUser();

  Future<void> saveSession({required String token, required UserModel user});

  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const new(this._preferences);

  final SharedPreferences _preferences;

  static const _tokenKey = 'auth.token';
  static const _userKey = 'auth.user';

  @override
  String? getToken() => _preferences.getString(_tokenKey);

  @override
  UserModel getCachedUser() {
    final raw = _preferences.getString(_userKey);
    if (raw == null) throw const CacheException();
    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      throw const CacheException();
    }
  }

  @override
  Future<void> saveSession({
    required String token,
    required UserModel user,
  }) async {
    await _preferences.setString(_tokenKey, token);
    await _preferences.setString(_userKey, jsonEncode(user.toJson()));
  }

  @override
  Future<void> clearSession() async {
    await _preferences.remove(_tokenKey);
    await _preferences.remove(_userKey);
  }
}

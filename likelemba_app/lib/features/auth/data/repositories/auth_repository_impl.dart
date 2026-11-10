import 'package:likelemba_app/core/errors/exceptions.dart';
import 'package:likelemba_app/core/errors/failures.dart';
import 'package:likelemba_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:likelemba_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:likelemba_app/features/auth/data/models/auth_response_model.dart';
import 'package:likelemba_app/features/auth/domain/entities/user.dart';
import 'package:likelemba_app/features/auth/domain/failures/auth_failures.dart';
import 'package:likelemba_app/features/auth/domain/repositories/auth_repository.dart';

/// Réalise le contrat du domaine avec deux sources : l'API et le téléphone.
/// C'est ici, et seulement ici, que les exceptions deviennent des Failure.
class AuthRepositoryImpl implements AuthRepository {
  const new({required this._remote, required this._local});

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<User> login({required String email, required String password}) =>
      _openSession(() => _remote.login(email: email, password: password));

  @override
  Future<User> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) => _openSession(
    () => _remote.register(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
    ),
  );

  @override
  Future<User?> getCurrentUser() async {
    if (_local.getToken() == null) return null;
    try {
      final user = await _remote.me();
      await _local.saveSession(token: _local.getToken()!, user: user);
      return user;
    } on NetworkException {
      // Hors ligne : on garde la dernière session connue.
      try {
        return _local.getCachedUser();
      } on CacheException {
        return null;
      }
    } on ServerException catch (error) {
      if (error.statusCode == 401) {
        await _local.clearSession();
        return null;
      }
      throw const ServerFailure();
    }
  }

  @override
  Future<void> logout() => _local.clearSession();

  Future<User> _openSession(Future<AuthResponseModel> Function() call) async {
    try {
      final response = await call();
      await _local.saveSession(token: response.token, user: response.user);
      return response.user;
    } on NetworkException {
      throw const NetworkFailure();
    } on ServerException catch (error) {
      throw switch (error.code) {
        'invalid_credentials' => const InvalidCredentialsFailure(),
        'email_already_used' => const EmailAlreadyUsedFailure(),
        'validation_error' => const InvalidRegistrationFailure(),
        _ => const ServerFailure(),
      };
    }
  }
}

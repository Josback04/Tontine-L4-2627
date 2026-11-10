import 'package:dio/dio.dart';
import 'package:likelemba_app/core/errors/exceptions.dart';
import 'package:likelemba_app/features/auth/data/models/auth_response_model.dart';
import 'package:likelemba_app/features/auth/data/models/user_model.dart';

/// Parle à l'API d'authentification (likelemba_backend).
abstract interface class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  Future<AuthResponseModel> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  });

  /// GET /users/me : le jeton est ajouté par AuthInterceptor.
  Future<UserModel> me();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const new(this._dio);

  final Dio _dio;

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final json = await _post('/auth/login', {
      'email': email,
      'password': password,
    });
    return AuthResponseModel.fromJson(json);
  }

  @override
  Future<AuthResponseModel> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final json = await _post('/auth/register', {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'password': password,
    });
    return AuthResponseModel.fromJson(json);
  }

  @override
  Future<UserModel> me() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/users/me');
      return UserModel.fromJson(response.data!['user'] as Map<String, dynamic>);
    } on DioException catch (error) {
      throw _toException(error);
    }
  }

  Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: body);
      return response.data!;
    } on DioException catch (error) {
      throw _toException(error);
    }
  }

  /// Traduit l'erreur de l'outil (dio) en exception de l'application.
  Exception _toException(DioException error) {
    final response = error.response;
    if (response == null) return const NetworkException();
    final data = response.data;
    final code = data is Map && data['code'] is String
        ? data['code'] as String
        : 'unknown';
    return ServerException(statusCode: response.statusCode ?? 0, code: code);
  }
}

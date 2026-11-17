import 'package:dio/dio.dart';
import 'package:likelemba_app/core/errors/exceptions.dart';
import 'package:likelemba_app/features/tontine/data/models/member_model.dart';
import 'package:likelemba_app/features/tontine/data/models/tontine_model.dart';

/// Parle aux routes /tontines de likelemba_backend.
/// Le jeton est ajouté par AuthInterceptor.
abstract interface class TontineRemoteDataSource {
  Future<List<TontineModel>> getMyTontines();

  Future<TontineModel> getTontine(String tontineId);

  Future<TontineModel> createTontine(Map<String, dynamic> body);

  Future<List<MemberModel>> getMembers(String tontineId);

  Future<MemberModel> addMember(String tontineId, Map<String, dynamic> body);

  Future<MemberModel> updateMember(
    String tontineId,
    String memberId,
    Map<String, dynamic> body,
  );

  Future<void> removeMember(String tontineId, String memberId);
}

class TontineRemoteDataSourceImpl implements TontineRemoteDataSource {
  const new(this._dio);

  final Dio _dio;

  @override
  Future<List<TontineModel>> getMyTontines() async {
    final json = await _send(() => _dio.get('/tontines'));
    return [
      for (final item in json['tontines'] as List<dynamic>)
        TontineModel.fromJson(item as Map<String, dynamic>),
    ];
  }

  @override
  Future<TontineModel> getTontine(String tontineId) async {
    final json = await _send(() => _dio.get('/tontines/$tontineId'));
    return TontineModel.fromJson(json['tontine'] as Map<String, dynamic>);
  }

  @override
  Future<TontineModel> createTontine(Map<String, dynamic> body) async {
    final json = await _send(() => _dio.post('/tontines', data: body));
    return TontineModel.fromJson(json['tontine'] as Map<String, dynamic>);
  }

  @override
  Future<List<MemberModel>> getMembers(String tontineId) async {
    final json = await _send(() => _dio.get('/tontines/$tontineId/members'));
    return [
      for (final item in json['members'] as List<dynamic>)
        MemberModel.fromJson(item as Map<String, dynamic>),
    ];
  }

  @override
  Future<MemberModel> addMember(
    String tontineId,
    Map<String, dynamic> body,
  ) async {
    final json = await _send(
      () => _dio.post('/tontines/$tontineId/members', data: body),
    );
    return MemberModel.fromJson(json['member'] as Map<String, dynamic>);
  }

  @override
  Future<MemberModel> updateMember(
    String tontineId,
    String memberId,
    Map<String, dynamic> body,
  ) async {
    final json = await _send(
      () => _dio.patch('/tontines/$tontineId/members/$memberId', data: body),
    );
    return MemberModel.fromJson(json['member'] as Map<String, dynamic>);
  }

  @override
  Future<void> removeMember(String tontineId, String memberId) =>
      _send(() => _dio.delete('/tontines/$tontineId/members/$memberId'));

  /// Exécute la requête et traduit les erreurs de dio en exceptions de
  /// l'application. Renvoie le corps JSON (vide pour un 204).
  Future<Map<String, dynamic>> _send(
    Future<Response<dynamic>> Function() request,
  ) async {
    try {
      final response = await request();
      final data = response.data;
      return data is Map<String, dynamic> ? data : const {};
    } on DioException catch (error) {
      final response = error.response;
      if (response == null) throw const NetworkException();
      final data = response.data;
      throw ServerException(
        statusCode: response.statusCode ?? 0,
        code: data is Map && data['code'] is String
            ? data['code'] as String
            : 'unknown',
      );
    }
  }
}

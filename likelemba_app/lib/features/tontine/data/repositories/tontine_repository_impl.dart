import 'package:likelemba_app/core/errors/exceptions.dart';
import 'package:likelemba_app/core/errors/failures.dart';
import 'package:likelemba_app/features/tontine/data/datasources/tontine_remote_data_source.dart';
import 'package:likelemba_app/features/tontine/domain/entities/member.dart';
import 'package:likelemba_app/features/tontine/domain/entities/tontine.dart';
import 'package:likelemba_app/features/tontine/domain/failures/tontine_failures.dart';
import 'package:likelemba_app/features/tontine/domain/repositories/tontine_repository.dart';

class TontineRepositoryImpl implements TontineRepository {
  const new(this._remote);

  final TontineRemoteDataSource _remote;

  @override
  Future<List<Tontine>> getMyTontines() => _guard(_remote.getMyTontines);

  @override
  Future<Tontine> getTontine(String tontineId) =>
      _guard(() => _remote.getTontine(tontineId));

  @override
  Future<Tontine> createTontine({
    required String name,
    required int contributionAmount,
    required ContributionFrequency frequency,
    required DateTime startDate,
  }) => _guard(
    () => _remote.createTontine({
      'name': name,
      'contribution_amount': contributionAmount,
      'frequency': frequency.name,
      'start_date': startDate.toUtc().toIso8601String(),
    }),
  );

  @override
  Future<List<Member>> getMembers(String tontineId) =>
      _guard(() => _remote.getMembers(tontineId));

  @override
  Future<Member> addMember({
    required String tontineId,
    required String fullName,
    required String phone,
  }) => _guard(
    () => _remote.addMember(tontineId, {'full_name': fullName, 'phone': phone}),
  );

  @override
  Future<Member> updateMember({
    required String tontineId,
    required String memberId,
    String? fullName,
    String? phone,
    MemberRole? role,
  }) => _guard(
    () => _remote.updateMember(tontineId, memberId, {
      'full_name': ?fullName,
      'phone': ?phone,
      'role': ?role?.name,
    }),
  );

  @override
  Future<void> removeMember({
    required String tontineId,
    required String memberId,
  }) => _guard(() => _remote.removeMember(tontineId, memberId));

  /// Les exceptions de data/ deviennent des Failure du domaine.
  /// Le 401 (session expirée) est déjà traité par AuthInterceptor.
  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on NetworkException {
      throw const NetworkFailure();
    } on ServerException catch (error) {
      throw switch (error.code) {
        'tontine_not_found' ||
        'member_not_found' => const TontineNotFoundFailure(),
        'not_treasurer' => const NotTreasurerFailure(),
        'phone_already_member' => const PhoneAlreadyMemberFailure(),
        'last_treasurer' => const LastTreasurerFailure(),
        'validation_error' => const InvalidTontineDataFailure(),
        _ when error.statusCode == 401 => const SessionExpiredFailure(),
        _ => const ServerFailure(),
      };
    }
  }
}

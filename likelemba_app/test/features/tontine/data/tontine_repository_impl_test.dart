import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/core/errors/exceptions.dart';
import 'package:likelemba_app/core/errors/failures.dart';
import 'package:likelemba_app/features/tontine/data/datasources/tontine_remote_data_source.dart';
import 'package:likelemba_app/features/tontine/data/models/member_model.dart';
import 'package:likelemba_app/features/tontine/data/models/tontine_model.dart';
import 'package:likelemba_app/features/tontine/data/repositories/tontine_repository_impl.dart';
import 'package:likelemba_app/features/tontine/domain/entities/member.dart';
import 'package:likelemba_app/features/tontine/domain/failures/tontine_failures.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemote extends Mock implements TontineRemoteDataSource;

void main() {
  late TontineRemoteDataSource remote;
  late TontineRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    repository = TontineRepositoryImpl(remote);
  });

  group('modèles', () {
    test('TontineModel lit my_role : MON rôle dans CETTE tontine', () {
      final tontine = TontineModel.fromJson(const {
        'id': 'tnt-002',
        'name': 'Enseignants de Lemba',
        'contribution_amount': 10000,
        'frequency': 'weekly',
        'start_date': '2026-09-01T00:00:00.000Z',
        'member_count': 3,
        'my_role': 'member',
      });
      expect(tontine.myRole, MemberRole.member);
      expect(tontine.canManage, isFalse);
    });

    test('MemberModel lit has_account', () {
      final member = MemberModel.fromJson(const {
        'id': 'mbr-003',
        'full_name': 'Junior Bokele',
        'phone': '0834567890',
        'payout_order': 3,
        'role': 'member',
        'has_account': false,
      });
      expect(member.hasAccount, isFalse);
      expect(member.payoutOrder, 3);
    });
  });

  group('exceptions → Failure', () {
    Future<void> expectFailure(String code, Matcher matcher) async {
      when(() => remote.addMember(any(), any()))
          .thenThrow(ServerException(statusCode: 400, code: code));
      await expectLater(
        repository.addMember(
          tontineId: 'tnt-002',
          fullName: 'X',
          phone: '0899990000',
        ),
        throwsA(matcher),
      );
    }

    test('not_treasurer', () async {
      await expectFailure('not_treasurer', isA<NotTreasurerFailure>());
    });

    test('phone_already_member', () async {
      await expectFailure(
        'phone_already_member',
        isA<PhoneAlreadyMemberFailure>(),
      );
    });

    test('last_treasurer', () async {
      await expectFailure('last_treasurer', isA<LastTreasurerFailure>());
    });

    test('réseau coupé', () async {
      when(() => remote.getMyTontines()).thenThrow(const NetworkException());
      await expectLater(
        repository.getMyTontines(),
        throwsA(isA<NetworkFailure>()),
      );
    });
  });

  test('updateMember n’envoie que les champs modifiés', () async {
    when(() => remote.updateMember(any(), any(), any())).thenAnswer(
      (_) async => const MemberModel(
        id: 'mbr-003',
        fullName: 'Junior Bokele',
        phone: '0834567890',
        payoutOrder: 3,
        role: MemberRole.treasurer,
        hasAccount: false,
      ),
    );
    await repository.updateMember(
      tontineId: 'tnt-001',
      memberId: 'mbr-003',
      role: MemberRole.treasurer,
    );
    verify(
      () => remote.updateMember('tnt-001', 'mbr-003', {'role': 'treasurer'}),
    ).called(1);
  });
}

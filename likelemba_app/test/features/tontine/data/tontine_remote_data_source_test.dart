import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/core/errors/exceptions.dart';
import 'package:likelemba_app/features/tontine/data/datasources/tontine_remote_data_source.dart';
import 'package:likelemba_app/features/tontine/domain/entities/member.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio;

const Map<String, Object> _tontineJson = {
  'id': 'tnt-001',
  'name': 'Mamans du marché Gambela',
  'contribution_amount': 25000,
  'frequency': 'monthly',
  'start_date': '2026-09-01T00:00:00.000Z',
  'member_count': 4,
  'my_role': 'treasurer',
};

const Map<String, Object> _memberJson = {
  'id': 'mbr-003',
  'full_name': 'Junior Bokele',
  'phone': '0834567890',
  'payout_order': 3,
  'role': 'member',
  'has_account': false,
};

void main() {
  late Dio dio;
  late TontineRemoteDataSourceImpl source;

  setUp(() {
    dio = _MockDio();
    source = TontineRemoteDataSourceImpl(dio);
  });

  Response<dynamic> ok(Object? data, {int status = 200}) => Response(
    data: data,
    statusCode: status,
    requestOptions: RequestOptions(),
  );

  test('GET /tontines', () async {
    when(() => dio.get<dynamic>('/tontines')).thenAnswer(
      (_) async => ok({
        'tontines': [_tontineJson],
      }),
    );
    final tontines = await source.getMyTontines();
    expect(tontines.single.myRole, MemberRole.treasurer);
  });

  test('GET /tontines/:id et ses membres', () async {
    when(() => dio.get<dynamic>('/tontines/tnt-001'))
        .thenAnswer((_) async => ok({'tontine': _tontineJson}));
    when(() => dio.get<dynamic>('/tontines/tnt-001/members')).thenAnswer(
      (_) async => ok({
        'members': [_memberJson],
      }),
    );
    expect((await source.getTontine('tnt-001')).name, contains('Gambela'));
    expect((await source.getMembers('tnt-001')).single.hasAccount, isFalse);
  });

  test('POST /tontines et POST /members', () async {
    when(() => dio.post<dynamic>('/tontines', data: any(named: 'data')))
        .thenAnswer((_) async => ok({'tontine': _tontineJson}, status: 201));
    when(
      () => dio.post<dynamic>(
        '/tontines/tnt-001/members',
        data: any(named: 'data'),
      ),
    ).thenAnswer((_) async => ok({'member': _memberJson}, status: 201));
    expect((await source.createTontine({'name': 'x'})).id, 'tnt-001');
    expect((await source.addMember('tnt-001', {})).id, 'mbr-003');
  });

  test('PATCH puis DELETE (204 sans corps)', () async {
    when(
      () => dio.patch<dynamic>(
        '/tontines/tnt-001/members/mbr-003',
        data: any(named: 'data'),
      ),
    ).thenAnswer((_) async => ok({'member': _memberJson}));
    when(() => dio.delete<dynamic>('/tontines/tnt-001/members/mbr-003'))
        .thenAnswer((_) async => ok(null, status: 204));
    expect(
      (await source.updateMember('tnt-001', 'mbr-003', {})).fullName,
      'Junior Bokele',
    );
    await source.removeMember('tnt-001', 'mbr-003');
  });

  test("le code d'erreur de l'API devient ServerException", () {
    when(() => dio.get<dynamic>('/tontines/tnt-009')).thenThrow(
      DioException(
        requestOptions: RequestOptions(),
        response: Response(
          statusCode: 404,
          data: {'code': 'tontine_not_found'},
          requestOptions: RequestOptions(),
        ),
      ),
    );
    expect(
      () => source.getTontine('tnt-009'),
      throwsA(
        isA<ServerException>().having(
          (e) => e.code,
          'code',
          'tontine_not_found',
        ),
      ),
    );
  });

  test('serveur injoignable : NetworkException', () {
    when(() => dio.get<dynamic>('/tontines'))
        .thenThrow(DioException(requestOptions: RequestOptions()));
    expect(source.getMyTontines, throwsA(isA<NetworkException>()));
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/core/usecase/usecase.dart';
import 'package:likelemba_app/features/tontine/domain/entities/tontine.dart';
import 'package:likelemba_app/features/tontine/domain/failures/tontine_failures.dart';
import 'package:likelemba_app/features/tontine/domain/repositories/tontine_repository.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/add_member_usecase.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/create_tontine_usecase.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/get_my_tontines_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/helpers.dart';

class _MockTontineRepository extends Mock implements TontineRepository;

void main() {
  late TontineRepository repository;

  setUpAll(() => registerFallbackValue(ContributionFrequency.monthly));
  setUp(() => repository = _MockTontineRepository());

  test('GetMyTontines : d’abord celles que je gère', () async {
    when(() => repository.getMyTontines())
        .thenAnswer((_) async => [tTeachers, tMarket]);
    final tontines = await GetMyTontinesUseCase(repository)(const NoParams());
    expect(tontines, [tMarket, tTeachers]);
  });

  group(CreateTontineUseCase, () {
    CreateTontineParams params({String name = 'Famille', int amount = 5000}) =>
        CreateTontineParams(
          name: name,
          contributionAmount: amount,
          frequency: ContributionFrequency.weekly,
          startDate: DateTime.utc(2026, 12),
        );

    test('refuse un montant nul, sans appeler le dépôt', () {
      expect(
        () => CreateTontineUseCase(repository)(params(amount: 0)),
        throwsA(isA<InvalidTontineDataFailure>()),
      );
      verifyZeroInteractions(repository);
    });

    test('refuse un nom trop court', () {
      expect(
        () => CreateTontineUseCase(repository)(params(name: ' ab ')),
        throwsA(isA<InvalidTontineDataFailure>()),
      );
    });

    test('transmet un nom nettoyé', () async {
      when(
        () => repository.createTontine(
          name: any(named: 'name'),
          contributionAmount: any(named: 'contributionAmount'),
          frequency: any(named: 'frequency'),
          startDate: any(named: 'startDate'),
        ),
      ).thenAnswer((_) async => tMarket);
      await CreateTontineUseCase(repository)(params(name: '  Famille  '));
      verify(
        () => repository.createTontine(
          name: 'Famille',
          contributionAmount: 5000,
          frequency: ContributionFrequency.weekly,
          startDate: DateTime.utc(2026, 12),
        ),
      ).called(1);
    });
  });

  test('AddMember : le téléphone est envoyé sans espaces', () async {
    when(
      () => repository.addMember(
        tontineId: any(named: 'tontineId'),
        fullName: any(named: 'fullName'),
        phone: any(named: 'phone'),
      ),
    ).thenAnswer((_) async => tJunior);
    await AddMemberUseCase(repository)(
      const AddMemberParams(
        tontineId: 'tnt-001',
        fullName: ' Junior Bokele ',
        phone: '083 456 7890',
      ),
    );
    verify(
      () => repository.addMember(
        tontineId: 'tnt-001',
        fullName: 'Junior Bokele',
        phone: '0834567890',
      ),
    ).called(1);
  });
}

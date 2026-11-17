import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/core/errors/failures.dart';
import 'package:likelemba_app/features/tontine/domain/entities/tontine.dart';
import 'package:likelemba_app/features/tontine/domain/failures/tontine_failures.dart';
import 'package:likelemba_app/features/tontine/domain/repositories/tontine_repository.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/create_tontine_usecase.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/get_my_tontines_usecase.dart';
import 'package:likelemba_app/features/tontine/presentation/cubit/create_tontine_cubit.dart';
import 'package:likelemba_app/features/tontine/presentation/cubit/tontines_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/helpers.dart';

class _MockTontineRepository extends Mock implements TontineRepository;

void main() {
  late TontineRepository repository;

  setUpAll(() => registerFallbackValue(ContributionFrequency.monthly));
  setUp(() => repository = _MockTontineRepository());

  group(TontinesCubit, () {
    TontinesCubit build() =>
        TontinesCubit(getMyTontines: GetMyTontinesUseCase(repository));

    blocTest<TontinesCubit, TontinesState>(
      'charge mes tontines',
      setUp: () =>
          when(() => repository.getMyTontines())
              .thenAnswer((_) async => [tMarket, tTeachers]),
      build: build,
      act: (cubit) => cubit.load(),
      expect: () => [
        const TontinesState(),
        TontinesState(
          status: LoadStatus.success,
          tontines: [tMarket, tTeachers],
        ),
      ],
    );

    blocTest<TontinesCubit, TontinesState>(
      'garde la liste affichée si le rafraîchissement échoue',
      setUp: () =>
          when(() => repository.getMyTontines())
              .thenThrow(const NetworkFailure()),
      build: build,
      seed: () =>
          TontinesState(status: LoadStatus.success, tontines: [tMarket]),
      act: (cubit) => cubit.load(),
      expect: () => [
        TontinesState(tontines: [tMarket]),
        TontinesState(
          status: LoadStatus.failure,
          tontines: [tMarket],
          failure: const NetworkFailure(),
        ),
      ],
    );
  });

  group(CreateTontineCubit, () {
    CreateTontineCubit build() =>
        CreateTontineCubit(createTontine: CreateTontineUseCase(repository));

    Future<void> submit(CreateTontineCubit cubit, {int amount = 25000}) =>
        cubit.submit(
          name: 'Mamans du marché Gambela',
          contributionAmount: amount,
          frequency: ContributionFrequency.monthly,
          startDate: DateTime.utc(2026, 9),
        );

    blocTest<CreateTontineCubit, CreateTontineState>(
      'success : renvoie la tontine créée',
      setUp: () => when(
        () => repository.createTontine(
          name: any(named: 'name'),
          contributionAmount: any(named: 'contributionAmount'),
          frequency: any(named: 'frequency'),
          startDate: any(named: 'startDate'),
        ),
      ).thenAnswer((_) async => tMarket),
      build: build,
      act: submit,
      expect: () => [
        const CreateTontineState(status: FormStatus.submitting),
        CreateTontineState(status: FormStatus.success, tontine: tMarket),
      ],
    );

    blocTest<CreateTontineCubit, CreateTontineState>(
      'montant invalide : failure sans appel réseau',
      build: build,
      act: (cubit) => submit(cubit, amount: 0),
      expect: () => const [
        CreateTontineState(status: FormStatus.submitting),
        CreateTontineState(
          status: FormStatus.failure,
          failure: InvalidTontineDataFailure(),
        ),
      ],
    );
  });
}

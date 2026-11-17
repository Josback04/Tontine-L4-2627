import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/features/tontine/domain/failures/tontine_failures.dart';
import 'package:likelemba_app/features/tontine/domain/repositories/tontine_repository.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/add_member_usecase.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/get_members_usecase.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/get_tontine_usecase.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/remove_member_usecase.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/update_member_usecase.dart';
import 'package:likelemba_app/features/tontine/presentation/cubit/tontine_detail_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/helpers.dart';

class _MockTontineRepository extends Mock implements TontineRepository;

void main() {
  late TontineRepository repository;

  setUp(() {
    repository = _MockTontineRepository();
    when(() => repository.getTontine('tnt-001'))
        .thenAnswer((_) async => tMarket);
    when(() => repository.getMembers('tnt-001'))
        .thenAnswer((_) async => [tGrace, tJunior]);
  });

  // Vrais cas d'usage, faux dépôt.
  TontineDetailCubit build() => TontineDetailCubit(
    getTontine: GetTontineUseCase(repository),
    getMembers: GetMembersUseCase(repository),
    addMember: AddMemberUseCase(repository),
    updateMember: UpdateMemberUseCase(repository),
    removeMember: RemoveMemberUseCase(repository),
  );

  final loaded = TontineDetailState(
    tontineId: 'tnt-001',
    status: LoadStatus.success,
    tontine: tMarket,
    members: const [tGrace, tJunior],
  );

  blocTest<TontineDetailCubit, TontineDetailState>(
    'load : la tontine et ses membres',
    build: build,
    act: (cubit) => cubit.load('tnt-001'),
    expect: () => [const TontineDetailState(tontineId: 'tnt-001'), loaded],
  );

  blocTest<TontineDetailCubit, TontineDetailState>(
    'un échec d’action garde la liste et expose actionFailure',
    setUp: () => when(
      () => repository.removeMember(tontineId: 'tnt-001', memberId: 'mbr-001'),
    ).thenThrow(const LastTreasurerFailure()),
    build: build,
    seed: () => loaded,
    act: (cubit) => cubit.removeMember(tGrace),
    expect: () => [
      loaded.copyWith(isActing: true),
      loaded.copyWith(actionFailure: const LastTreasurerFailure()),
    ],
  );

  blocTest<TontineDetailCubit, TontineDetailState>(
    'ajouter un membre recharge la liste',
    setUp: () => when(
      () => repository.addMember(
        tontineId: 'tnt-001',
        fullName: 'Junior Bokele',
        phone: '0834567890',
      ),
    ).thenAnswer((_) async => tJunior),
    build: build,
    seed: () => loaded.copyWith(members: const [tGrace]),
    act: (cubit) =>
        cubit.addMember(fullName: 'Junior Bokele', phone: '0834567890'),
    expect: () => [
      loaded.copyWith(members: const [tGrace], isActing: true),
      loaded,
    ],
  );
}

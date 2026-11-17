import 'package:get_it/get_it.dart';
import 'package:likelemba_app/features/tontine/data/datasources/tontine_remote_data_source.dart';
import 'package:likelemba_app/features/tontine/data/repositories/tontine_repository_impl.dart';
import 'package:likelemba_app/features/tontine/domain/repositories/tontine_repository.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/add_member_usecase.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/create_tontine_usecase.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/get_members_usecase.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/get_my_tontines_usecase.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/get_tontine_usecase.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/remove_member_usecase.dart';
import 'package:likelemba_app/features/tontine/domain/usecases/update_member_usecase.dart';
import 'package:likelemba_app/features/tontine/presentation/cubit/create_tontine_cubit.dart';
import 'package:likelemba_app/features/tontine/presentation/cubit/tontine_detail_cubit.dart';
import 'package:likelemba_app/features/tontine/presentation/cubit/tontines_cubit.dart';

/// Point d'injection de la feature tontine. Même ordre que auth_injection :
/// data, puis domaine, puis presentation.
void initTontineFeature(GetIt sl) {
  sl
    // ── data/ ────────────────────────────────────────────────────────────
    // Le Dio partagé (core/) porte déjà l'AuthInterceptor : les routes
    // /tontines reçoivent le jeton sans que cette feature s'en occupe.
    ..registerLazySingleton<TontineRemoteDataSource>(
      () => TontineRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<TontineRepository>(
      () => TontineRepositoryImpl(sl()),
    )
    // ── domain/ ──────────────────────────────────────────────────────────
    ..registerLazySingleton(() => GetMyTontinesUseCase(sl()))
    ..registerLazySingleton(() => GetTontineUseCase(sl()))
    ..registerLazySingleton(() => CreateTontineUseCase(sl()))
    ..registerLazySingleton(() => GetMembersUseCase(sl()))
    ..registerLazySingleton(() => AddMemberUseCase(sl()))
    ..registerLazySingleton(() => UpdateMemberUseCase(sl()))
    ..registerLazySingleton(() => RemoveMemberUseCase(sl()))
    // ── presentation/ : un cubit neuf par écran ──────────────────────────
    ..registerFactory(() => TontinesCubit(getMyTontines: sl()))
    ..registerFactory(() => CreateTontineCubit(createTontine: sl()))
    ..registerFactory(
      () => TontineDetailCubit(
        getTontine: sl(),
        getMembers: sl(),
        addMember: sl(),
        updateMember: sl(),
        removeMember: sl(),
      ),
    );
}

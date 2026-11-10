import 'package:get_it/get_it.dart';
import 'package:likelemba_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:likelemba_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:likelemba_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:likelemba_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:likelemba_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:likelemba_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:likelemba_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:likelemba_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:likelemba_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:likelemba_app/features/auth/presentation/cubit/login_cubit.dart';
import 'package:likelemba_app/features/auth/presentation/cubit/register_cubit.dart';

/// Point d'injection de la feature auth : le seul fichier de la feature qui
/// connaît ses trois couches. Appelé par core/di/injection_container.dart.
///
/// Lecture de bas en haut : chaque couche reçoit celle du dessous par son
/// constructeur, et `sl()` trouve l'instance enregistrée pour le type attendu.
void initAuthFeature(GetIt sl) {
  sl
    // ── data/ : sources de données ───────────────────────────────────────
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(sl()),
    )
    // ── data/ : implémentation du contrat du domaine ─────────────────────
    // On enregistre l'IMPLÉMENTATION sous le type du CONTRAT : le reste de
    // l'application ne voit que AuthRepository.
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remote: sl(), local: sl()),
    )
    // ── domain/ : cas d'usage ────────────────────────────────────────────
    ..registerLazySingleton(() => LoginUseCase(sl()))
    ..registerLazySingleton(() => RegisterUseCase(sl()))
    ..registerLazySingleton(() => GetCurrentUserUseCase(sl()))
    ..registerLazySingleton(() => LogoutUseCase(sl()))
    // ── presentation/ ────────────────────────────────────────────────────
    // AuthBloc : singleton, la session est globale.
    ..registerLazySingleton(() => AuthBloc(getCurrentUser: sl(), logout: sl()))
    // Cubits de formulaire : factory, un neuf par page, fermé avec elle.
    ..registerFactory(() => LoginCubit(login: sl()))
    ..registerFactory(() => RegisterCubit(register: sl()));
}

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:likelemba_app/core/config/app_environment.dart';
import 'package:likelemba_app/core/network/auth_interceptor.dart';
import 'package:likelemba_app/core/network/dio_factory.dart';
import 'package:likelemba_app/features/auth/auth_injection.dart';
import 'package:likelemba_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:likelemba_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Le localisateur de services (service locator).
final GetIt sl = GetIt.instance;

/// Le point d'assemblage (composition root), appelé une seule fois par
/// bootstrap.dart, avant runApp.
///
/// 1. core/ enregistre les outils partagés (stockage, client HTTP) ;
/// 2. chaque feature enregistre ses propres couches
///    (`features/<feature>/<feature>_injection.dart`).
///
/// Partout ailleurs, une classe reçoit ses dépendances par son constructeur.
Future<void> initDependencies(AppEnvironment environment) async {
  // ── core/ : outils partagés ──────────────────────────────────────────────
  sl
    ..registerSingleton<AppEnvironment>(environment)
    ..registerSingleton<SharedPreferences>(
      await SharedPreferences.getInstance(),
    )
    ..registerLazySingleton<Dio>(
      () => createDio(
        environment,
        interceptors: [
          // L'intercepteur reçoit des fonctions, pas des classes de features :
          // core/network reste indépendant de features/.
          AuthInterceptor(
            readToken: () => sl<AuthLocalDataSource>().getToken(),
            clearSession: () => sl<AuthLocalDataSource>().clearSession(),
            onSessionExpired: () =>
                sl<AuthBloc>().add(const AuthSessionExpired()),
          ),
        ],
      ),
    );

  // ── features/ ────────────────────────────────────────────────────────────
  initAuthFeature(sl);
}

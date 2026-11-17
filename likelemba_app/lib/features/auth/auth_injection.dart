import 'package:get_it/get_it.dart';
import 'package:likelemba_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:likelemba_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:likelemba_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:likelemba_app/features/auth/presentation/bloc/auth_bloc.dart';

/// Point d'injection de la feature auth : le seul fichier de la feature qui
/// connaît ses trois couches. Appelé par core/di/injection_container.dart.
///
/// Lecture de bas en haut : chaque couche reçoit celle du dessous par son
/// constructeur, et `sl()` trouve l'instance enregistrée pour le type attendu.
void initAuthFeature(GetIt sl) {
  sl
    // ── data/ : implémentation du contrat du domaine ─────────────────────
    // On enregistre l'IMPLÉMENTATION sous le type du CONTRAT : le reste de
    // l'application ne voit que AuthRepository.
    // Séance « couche data » : remplacer FakeAuthRepository par la vraie.
    ..registerLazySingleton<AuthRepository>(FakeAuthRepository.new)
    // ── domain/ : cas d'usage ────────────────────────────────────────────
    ..registerLazySingleton(() => LoginUseCase(sl()))
    // ── presentation/ ────────────────────────────────────────────────────
    // Factory : App en crée UN, fourni à tout l'arbre par BlocProvider
    // (la session est globale).
    ..registerFactory(() => AuthBloc(login: sl()));
}

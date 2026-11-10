import 'package:go_router/go_router.dart';
import 'package:likelemba_app/core/router/app_routes.dart';
import 'package:likelemba_app/core/router/go_router_refresh_stream.dart';
import 'package:likelemba_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:likelemba_app/features/auth/presentation/pages/login_page.dart';
import 'package:likelemba_app/features/auth/presentation/pages/register_page.dart';
import 'package:likelemba_app/features/auth/presentation/pages/splash_page.dart';
import 'package:likelemba_app/features/home/presentation/pages/home_page.dart';

/// Point d'assemblage de la navigation : le seul fichier de core/ (avec di/)
/// qui connaît les pages des features.
GoRouter createRouter(AuthBloc authBloc) {
  const publicRoutes = {AppRoutes.login, AppRoutes.register};

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final location = state.matchedLocation;
      return switch (authBloc.state.status) {
        AuthStatus.unknown =>
          location == AppRoutes.splash ? null : AppRoutes.splash,
        AuthStatus.unauthenticated =>
          publicRoutes.contains(location) ? null : AppRoutes.login,
        AuthStatus.authenticated =>
          location == AppRoutes.splash || publicRoutes.contains(location)
              ? AppRoutes.home
              : null,
      };
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
  );
}

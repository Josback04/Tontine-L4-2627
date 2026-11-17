import 'package:go_router/go_router.dart';
import 'package:likelemba_app/core/router/app_routes.dart';
import 'package:likelemba_app/features/auth/presentation/pages/login_page.dart';

/// Séance 1 : une seule route. La redirection selon la session (splash,
/// connexion, accueil) arrivera avec la séance sur la session.
GoRouter createRouter() {
  return GoRouter(
    initialLocation: AppRoutes.login,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
    ],
  );
}

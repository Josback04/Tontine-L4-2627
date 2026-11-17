import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:likelemba_app/core/l10n/l10n.dart';
import 'package:likelemba_app/core/router/app_router.dart';
import 'package:likelemba_app/core/theme/theme.dart';
import 'package:likelemba_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:material_ui/material_ui.dart';

/// La racine de l'application : thème, traductions, routeur et session.
///
/// AuthBloc est reçu par le constructeur (injecté par `main_<saveur>.dart`),
/// ce qui permet aux tests de passer un faux bloc.
class App extends StatefulWidget {
  const new({required this.authBloc, super.key});

  final AuthBloc authBloc;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = createRouter(widget.authBloc);
    widget.authBloc.add(const AuthStarted());
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      value: widget.authBloc,
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (_, current) => current.sessionExpired,
        listener: (context, state) => _showSessionExpired(),
        child: MaterialApp.router(
          onGenerateTitle: (context) => context.l10n.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          localizationsDelegates: appLocalizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: _router,
        ),
      ),
    );
  }

  void _showSessionExpired() {
    final context = _router.routerDelegate.navigatorKey.currentContext;
    if (context == null) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.l10n.errorSessionExpired)));
  }
}

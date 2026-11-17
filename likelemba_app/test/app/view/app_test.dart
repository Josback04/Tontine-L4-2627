import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/app/app.dart';
import 'package:likelemba_app/core/di/injection_container.dart';
import 'package:likelemba_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:likelemba_app/features/auth/presentation/cubit/login_cubit.dart';
import 'package:likelemba_app/features/auth/presentation/pages/login_page.dart';
import 'package:likelemba_app/features/auth/presentation/pages/splash_page.dart';
import 'package:likelemba_app/features/home/presentation/pages/home_page.dart';
import 'package:likelemba_app/features/tontine/presentation/cubit/tontines_cubit.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc;

class _MockLoginCubit extends MockCubit<LoginState> implements LoginCubit;

class _MockTontinesCubit extends MockCubit<TontinesState>
    implements TontinesCubit;

void main() {
  late AuthBloc authBloc;

  setUp(() {
    authBloc = _MockAuthBloc();
    final loginCubit = _MockLoginCubit();
    when(() => loginCubit.state).thenReturn(const LoginState());
    // Dans les tests, on remplace l'injection réelle par des faux.
    sl.registerFactory<LoginCubit>(() => loginCubit);
    final tontinesCubit = _MockTontinesCubit();
    when(() => tontinesCubit.state)
        .thenReturn(const TontinesState(status: LoadStatus.success));
    when(tontinesCubit.load).thenAnswer((_) async {});
    sl.registerFactory<TontinesCubit>(() => tontinesCubit);
  });

  tearDown(sl.reset);

  group(App, () {
    testWidgets('unknown : écran de démarrage', (tester) async {
      when(() => authBloc.state).thenReturn(const AuthState.unknown());
      await tester.pumpWidget(App(authBloc: authBloc));
      expect(find.byType(SplashPage), findsOneWidget);
      verify(() => authBloc.add(const AuthStarted())).called(1);
    });

    testWidgets('unauthenticated : redirige vers la connexion', (tester) async {
      whenListen(
        authBloc,
        Stream.value(const AuthState.unauthenticated()),
        initialState: const AuthState.unknown(),
      );
      await tester.pumpWidget(App(authBloc: authBloc));
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('téléphone en français : connexion sans erreur', (
      tester,
    ) async {
      // Régression : avec les délégués de flutter_localizations, les champs
      // de texte plantaient (« No MaterialLocalizations found »).
      tester.platformDispatcher.localesTestValue = const [Locale('fr')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      whenListen(
        authBloc,
        Stream.value(const AuthState.unauthenticated()),
        initialState: const AuthState.unknown(),
      );
      await tester.pumpWidget(App(authBloc: authBloc));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Bon retour !'), findsOneWidget);
      expect(find.text('Mot de passe'), findsOneWidget);
    });

    testWidgets("authenticated : ouvre l'accueil", (tester) async {
      whenListen(
        authBloc,
        Stream.value(const AuthState.authenticated(tUser)),
        initialState: const AuthState.unknown(),
      );
      await tester.pumpWidget(App(authBloc: authBloc));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text('Hello, Grâce'), findsOneWidget);
    });
  });
}

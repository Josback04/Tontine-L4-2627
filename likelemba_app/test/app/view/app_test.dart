import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/app/app.dart';
import 'package:likelemba_app/core/di/injection_container.dart';
import 'package:likelemba_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:likelemba_app/features/auth/presentation/cubit/login_cubit.dart';
import 'package:likelemba_app/features/auth/presentation/pages/login_page.dart';
import 'package:likelemba_app/features/auth/presentation/pages/splash_page.dart';
import 'package:likelemba_app/features/home/presentation/pages/home_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc;

class _MockLoginCubit extends MockCubit<LoginState> implements LoginCubit;

void main() {
  late AuthBloc authBloc;

  setUp(() {
    authBloc = _MockAuthBloc();
    final loginCubit = _MockLoginCubit();
    when(() => loginCubit.state).thenReturn(const LoginState());
    // Dans les tests, on remplace l'injection réelle par des faux.
    sl.registerFactory<LoginCubit>(() => loginCubit);
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

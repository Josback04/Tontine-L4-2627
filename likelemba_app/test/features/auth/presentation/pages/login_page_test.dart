import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:likelemba_app/features/auth/presentation/pages/login_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc;

void main() {
  late AuthBloc authBloc;

  setUpAll(
    () => registerFallbackValue(const LoginEvent(email: '', password: '')),
  );

  setUp(() {
    authBloc = _MockAuthBloc();
    when(() => authBloc.state).thenReturn(const AuthState());
  });

  Future<void> pumpLoginView(WidgetTester tester) => tester.pumpApp(
    BlocProvider.value(value: authBloc, child: const LoginView()),
  );

  group(LoginView, () {
    testWidgets("n'envoie rien si l'e-mail est invalide", (tester) async {
      await pumpLoginView(tester);
      await tester.enterText(
        find.byKey(const Key('emailField')),
        'pas-un-email',
      );
      await tester.enterText(find.byKey(const Key('passwordField')), 'secret');
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pump();

      expect(find.text('Enter a valid email address.'), findsOneWidget);
      verifyNever(() => authBloc.add(any()));
    });

    testWidgets('ajoute un LoginEvent quand le formulaire est valide', (
      tester,
    ) async {
      await pumpLoginView(tester);
      await tester.enterText(
        find.byKey(const Key('emailField')),
        'tresorier1@likelemba.test',
      );
      await tester.enterText(
        find.byKey(const Key('passwordField')),
        'likelemba2026',
      );
      await tester.tap(find.byKey(const Key('loginButton')));

      verify(
        () => authBloc.add(
          const LoginEvent(
            email: 'tresorier1@likelemba.test',
            password: 'likelemba2026',
          ),
        ),
      ).called(1);
    });

    testWidgets('success : souhaite la bienvenue', (tester) async {
      whenListen(
        authBloc,
        Stream.value(
          const AuthState(
            loginState: AuthenticationState.authenticated,
            user: tUser,
          ),
        ),
        initialState: const AuthState(),
      );
      await pumpLoginView(tester);
      await tester.pump();

      expect(find.text('Hello, Grâce!'), findsOneWidget);
    });

    testWidgets('failed : affiche state.message', (tester) async {
      whenListen(
        authBloc,
        Stream.value(
          const AuthState(
            loginState: AuthenticationState.failed,
            message: 'Incorrect email or password.',
          ),
        ),
        initialState: const AuthState(),
      );
      await pumpLoginView(tester);
      await tester.pump();

      expect(find.text('Incorrect email or password.'), findsOneWidget);
    });
  });
}

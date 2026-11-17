import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/features/auth/domain/failures/auth_failures.dart';
import 'package:likelemba_app/features/auth/presentation/cubit/login_cubit.dart';
import 'package:likelemba_app/features/auth/presentation/pages/login_page.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

class _MockLoginCubit extends MockCubit<LoginState> implements LoginCubit;

void main() {
  late LoginCubit loginCubit;

  setUp(() {
    loginCubit = _MockLoginCubit();
    when(() => loginCubit.state).thenReturn(const LoginState());
    when(
      () => loginCubit.submit(
        email: any(named: 'email'),
        password: any(named: 'password'),
      ),
    ).thenAnswer((_) async {});
  });

  Future<void> pumpLoginView(WidgetTester tester) => tester.pumpApp(
    BlocProvider.value(value: loginCubit, child: const LoginView()),
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
      verifyNever(
        () => loginCubit.submit(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      );
    });

    testWidgets('envoie le formulaire valide au cubit', (tester) async {
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
        () => loginCubit.submit(
          email: 'tresorier1@likelemba.test',
          password: 'likelemba2026',
        ),
      ).called(1);
    });

    testWidgets('success : souhaite la bienvenue', (tester) async {
      whenListen(
        loginCubit,
        Stream.value(const LoginState(status: FormStatus.success, user: tUser)),
        initialState: const LoginState(),
      );
      await pumpLoginView(tester);
      await tester.pump();

      expect(find.text('Hello, Grâce!'), findsOneWidget);
    });

    testWidgets('failure : affiche le message traduit', (tester) async {
      whenListen(
        loginCubit,
        Stream.value(
          const LoginState(
            status: FormStatus.failure,
            failure: InvalidCredentialsFailure(),
          ),
        ),
        initialState: const LoginState(),
      );
      await pumpLoginView(tester);
      await tester.pump();

      expect(find.text('Incorrect email or password.'), findsOneWidget);
    });
  });
}

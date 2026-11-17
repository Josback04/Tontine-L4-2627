import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/core/errors/failures.dart';
import 'package:likelemba_app/features/auth/domain/failures/auth_failures.dart';
import 'package:likelemba_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:likelemba_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

class _MockLoginUseCase extends Mock implements LoginUseCase;

void main() {
  late LoginUseCase login;

  setUpAll(
    () => registerFallbackValue(const LoginParams(email: '', password: '')),
  );

  setUp(() => login = _MockLoginUseCase());

  const event = LoginEvent(email: 'e', password: 'p');

  group(AuthBloc, () {
    test('état initial : non connecté', () {
      expect(AuthBloc(login: login).state, const AuthState());
    });

    blocTest<AuthBloc, AuthState>(
      'LoginEvent : loading puis authenticated',
      setUp: () => when(() => login(any())).thenAnswer((_) async => tUser),
      build: () => AuthBloc(login: login),
      act: (bloc) => bloc.add(event),
      expect: () => const [
        AuthState(loginState: AuthenticationState.loading),
        AuthState(loginState: AuthenticationState.authenticated, user: tUser),
      ],
      verify: (_) =>
          verify(() => login(const LoginParams(email: 'e', password: 'p')))
              .called(1),
    );

    blocTest<AuthBloc, AuthState>(
      'LoginEvent : loading puis failed avec le message traduit',
      setUp: () =>
          when(() => login(any())).thenThrow(const InvalidCredentialsFailure()),
      build: () => AuthBloc(login: login),
      act: (bloc) => bloc.add(event),
      expect: () => const [
        AuthState(loginState: AuthenticationState.loading),
        AuthState(
          loginState: AuthenticationState.failed,
          message: 'Incorrect email or password.',
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'un nouvel essai efface le message précédent (copyWith(message: null))',
      setUp: () => when(() => login(any())).thenThrow(const NetworkFailure()),
      build: () => AuthBloc(login: login),
      seed: () => const AuthState(
        loginState: AuthenticationState.failed,
        message: 'ancien message',
      ),
      act: (bloc) => bloc.add(event),
      expect: () => const [
        AuthState(loginState: AuthenticationState.loading),
        AuthState(
          loginState: AuthenticationState.failed,
          message: 'Server unreachable. Check your connection.',
        ),
      ],
    );
  });
}

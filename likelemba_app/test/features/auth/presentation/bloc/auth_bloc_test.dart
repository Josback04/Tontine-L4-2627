import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/core/usecase/usecase.dart';
import 'package:likelemba_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:likelemba_app/features/auth/domain/usecases/logout_usecase.dart';
import 'package:likelemba_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

class _MockGetCurrentUser extends Mock implements GetCurrentUserUseCase;

class _MockLogout extends Mock implements LogoutUseCase;

void main() {
  late GetCurrentUserUseCase getCurrentUser;
  late LogoutUseCase logout;

  setUpAll(() => registerFallbackValue(const NoParams()));

  setUp(() {
    getCurrentUser = _MockGetCurrentUser();
    logout = _MockLogout();
    when(() => logout(any())).thenAnswer((_) async {});
  });

  AuthBloc build() => AuthBloc(getCurrentUser: getCurrentUser, logout: logout);

  group(AuthBloc, () {
    test('état initial : unknown', () {
      expect(build().state, const AuthState.unknown());
    });

    blocTest<AuthBloc, AuthState>(
      'AuthStarted avec une session : authenticated',
      setUp: () =>
          when(() => getCurrentUser(any())).thenAnswer((_) async => tUser),
      build: build,
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => [const AuthState.authenticated(tUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'AuthStarted sans session : unauthenticated',
      setUp: () =>
          when(() => getCurrentUser(any())).thenAnswer((_) async => null),
      build: build,
      act: (bloc) => bloc.add(const AuthStarted()),
      expect: () => [const AuthState.unauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'AuthLogoutRequested appelle le cas d’usage',
      build: build,
      seed: () => const AuthState.authenticated(tUser),
      act: (bloc) => bloc.add(const AuthLogoutRequested()),
      expect: () => [const AuthState.unauthenticated()],
      verify: (_) => verify(() => logout(const NoParams())).called(1),
    );

    blocTest<AuthBloc, AuthState>(
      'AuthSessionExpired signale la session expirée',
      build: build,
      seed: () => const AuthState.authenticated(tUser),
      act: (bloc) => bloc.add(const AuthSessionExpired()),
      expect: () => [const AuthState.unauthenticated(sessionExpired: true)],
    );
  });
}

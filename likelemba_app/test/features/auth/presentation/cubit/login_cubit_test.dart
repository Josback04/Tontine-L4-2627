import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/features/auth/domain/failures/auth_failures.dart';
import 'package:likelemba_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:likelemba_app/features/auth/presentation/cubit/login_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

class _MockLoginUseCase extends Mock implements LoginUseCase;

void main() {
  late LoginUseCase login;

  setUpAll(
    () => registerFallbackValue(const LoginParams(email: '', password: '')),
  );

  setUp(() => login = _MockLoginUseCase());

  group(LoginCubit, () {
    blocTest<LoginCubit, LoginState>(
      'submitting puis success',
      setUp: () => when(() => login(any())).thenAnswer((_) async => tUser),
      build: () => LoginCubit(login: login),
      act: (cubit) => cubit.submit(email: 'e', password: 'p'),
      expect: () => const [
        LoginState(status: FormStatus.submitting),
        LoginState(status: FormStatus.success, user: tUser),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'submitting puis failure',
      setUp: () =>
          when(() => login(any())).thenThrow(const InvalidCredentialsFailure()),
      build: () => LoginCubit(login: login),
      act: (cubit) => cubit.submit(email: 'e', password: 'p'),
      expect: () => const [
        LoginState(status: FormStatus.submitting),
        LoginState(
          status: FormStatus.failure,
          failure: InvalidCredentialsFailure(),
        ),
      ],
    );
  });
}

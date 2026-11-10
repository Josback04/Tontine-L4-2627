import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/features/auth/domain/failures/auth_failures.dart';
import 'package:likelemba_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:likelemba_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:likelemba_app/features/auth/presentation/cubit/register_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

class _MockAuthRepository extends Mock implements AuthRepository;

void main() {
  late AuthRepository repository;

  setUp(() => repository = _MockAuthRepository());

  When<Future<dynamic>> whenRegister() => when(
    () => repository.register(
      fullName: any(named: 'fullName'),
      email: any(named: 'email'),
      phone: any(named: 'phone'),
      password: any(named: 'password'),
    ),
  );

  // On branche le vrai cas d'usage sur un faux dépôt : le test couvre
  // aussi la normalisation faite par RegisterUseCase.
  RegisterCubit build() => RegisterCubit(register: RegisterUseCase(repository));

  Future<void> submit(RegisterCubit cubit) => cubit.submit(
    fullName: ' Grâce Mbuyi ',
    email: ' Tresorier1@Likelemba.test',
    phone: '081 234 5678',
    password: 'likelemba2026',
  );

  group(RegisterCubit, () {
    blocTest<RegisterCubit, RegisterState>(
      'submitting puis success, avec des champs normalisés',
      setUp: () => whenRegister().thenAnswer((_) async => tUser),
      build: build,
      act: submit,
      expect: () => const [
        RegisterState(status: FormStatus.submitting),
        RegisterState(status: FormStatus.success, user: tUser),
      ],
      verify: (_) => verify(
        () => repository.register(
          fullName: 'Grâce Mbuyi',
          email: 'tresorier1@likelemba.test',
          phone: '0812345678',
          password: 'likelemba2026',
        ),
      ).called(1),
    );

    blocTest<RegisterCubit, RegisterState>(
      'e-mail déjà utilisé : failure',
      setUp: () => whenRegister().thenThrow(const EmailAlreadyUsedFailure()),
      build: build,
      act: submit,
      expect: () => const [
        RegisterState(status: FormStatus.submitting),
        RegisterState(
          status: FormStatus.failure,
          failure: EmailAlreadyUsedFailure(),
        ),
      ],
    );
  });
}

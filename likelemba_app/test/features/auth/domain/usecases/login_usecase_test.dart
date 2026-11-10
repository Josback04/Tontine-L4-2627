import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/features/auth/domain/failures/auth_failures.dart';
import 'package:likelemba_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:likelemba_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

class _MockAuthRepository extends Mock implements AuthRepository;

void main() {
  late AuthRepository repository;
  late LoginUseCase login;

  setUp(() {
    repository = _MockAuthRepository();
    login = LoginUseCase(repository);
  });

  group(LoginUseCase, () {
    test("normalise l'e-mail avant d'appeler le dépôt", () async {
      when(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => tUser);

      final user = await login(
        const LoginParams(
          email: '  Tresorier1@Likelemba.test ',
          password: 'likelemba2026',
        ),
      );

      expect(user, tUser);
      verify(
        () => repository.login(
          email: 'tresorier1@likelemba.test',
          password: 'likelemba2026',
        ),
      ).called(1);
    });

    test('laisse remonter la Failure du dépôt', () {
      when(
        () => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(const InvalidCredentialsFailure());

      expect(
        () => login(const LoginParams(email: 'a@b.cd', password: 'x')),
        throwsA(isA<InvalidCredentialsFailure>()),
      );
    });
  });
}

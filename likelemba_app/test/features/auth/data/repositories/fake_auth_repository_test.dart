import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/features/auth/data/repositories/fake_auth_repository.dart';
import 'package:likelemba_app/features/auth/domain/failures/auth_failures.dart';

import '../../../../helpers/helpers.dart';

void main() {
  const repository = FakeAuthRepository();

  group(FakeAuthRepository, () {
    test('bon mot de passe : renvoie le compte de démonstration', () async {
      final user = await repository.login(
        email: 'tresorier1@likelemba.test',
        password: FakeAuthRepository.demoPassword,
      );
      expect(user, tUser);
    });

    test('mauvais mot de passe : InvalidCredentialsFailure', () {
      expect(
        () => repository.login(
          email: 'tresorier1@likelemba.test',
          password: 'faux',
        ),
        throwsA(isA<InvalidCredentialsFailure>()),
      );
    });
  });
}

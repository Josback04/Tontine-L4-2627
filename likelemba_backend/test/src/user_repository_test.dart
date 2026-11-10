import 'package:likelemba_backend/likelemba_backend.dart';
import 'package:test/test.dart';

void main() {
  group(UserRepository, () {
    late UserRepository repository;

    setUp(() => repository = UserRepository());

    test('authentifie un compte de démonstration', () {
      final user = repository.authenticate(
        'TRESORIER1@likelemba.test ',
        UserRepository.demoPassword,
      );
      expect(user?.id, 'usr-001');
      expect(user?.role, UserRole.treasurer);
    });

    test('refuse un mauvais mot de passe', () {
      expect(
        repository.authenticate('tresorier1@likelemba.test', 'mauvais'),
        isNull,
      );
    });

    test('crée un compte puis refuse le même e-mail', () {
      final user = repository.create(
        fullName: 'Ruth Nzuzi',
        email: 'ruth@likelemba.test',
        phone: '0854321098',
        password: 'motdepasse',
      );
      expect(repository.findById(user.id), same(user));
      expect(
        () => repository.create(
          fullName: 'Autre',
          email: 'RUTH@likelemba.test',
          phone: '',
          password: 'motdepasse',
        ),
        throwsA(isA<EmailAlreadyUsedException>()),
      );
    });

    test("toJson n'expose jamais le hachage du mot de passe", () {
      final user = repository.findById('usr-001')!;
      expect(user.toJson().containsKey('password_hash'), isFalse);
      expect(user.toJson()['full_name'], 'Grâce Mbuyi');
    });
  });

  group(TokenService, () {
    const service = TokenService(secret: 'test', ttl: Duration(minutes: 5));

    test('le jeton émis redonne l’identifiant', () {
      final user = UserRepository().findById('usr-002')!;
      expect(service.verify(service.issue(user)), 'usr-002');
    });

    test('un jeton signé avec un autre secret est refusé', () {
      final user = UserRepository().findById('usr-002')!;
      const other = TokenService(secret: 'autre', ttl: Duration(minutes: 5));
      expect(service.verify(other.issue(user)), isNull);
      expect(service.verify('pas.un.jeton'), isNull);
    });
  });
}

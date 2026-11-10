import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/core/utils/validators.dart';

void main() {
  group(Validators, () {
    test('isEmail', () {
      expect(Validators.isEmail(' tresorier1@likelemba.test '), isTrue);
      expect(Validators.isEmail('tresorier1@'), isFalse);
      expect(Validators.isEmail(null), isFalse);
    });

    test('isPhone : 10 chiffres commençant par 0', () {
      expect(Validators.isPhone('081 234 5678'), isTrue);
      expect(Validators.isPhone('812345678'), isFalse);
      expect(Validators.isPhone('08123456789'), isFalse);
    });

    test('isPassword : au moins 8 caractères', () {
      expect(Validators.isPassword('12345678'), isTrue);
      expect(Validators.isPassword('1234567'), isFalse);
    });

    test('isFullName', () {
      expect(Validators.isFullName('Ruth Nzuzi'), isTrue);
      expect(Validators.isFullName(' R '), isFalse);
    });
  });
}

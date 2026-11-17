import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/features/auth/domain/entities/user.dart';

void main() {
  const grace = User(
    id: 'usr-001',
    fullName: '  Grâce   Mbuyi ',
    email: 'tresorier1@likelemba.test',
    phone: '0812345678',
  );

  group(User, () {
    test('firstName et initials', () {
      expect(grace.firstName, 'Grâce');
      expect(grace.initials, 'GM');
    });

    test('deux utilisateurs aux mêmes valeurs sont égaux (equatable)', () {
      const copy = User(
        id: 'usr-001',
        fullName: '  Grâce   Mbuyi ',
        email: 'tresorier1@likelemba.test',
        phone: '0812345678',
      );
      expect(copy, grace);
    });
  });
}

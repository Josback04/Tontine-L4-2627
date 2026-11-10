import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/features/auth/domain/entities/user.dart';

void main() {
  const treasurer = User(
    id: 'usr-001',
    fullName: '  Grâce   Mbuyi ',
    email: 'tresorier1@likelemba.test',
    phone: '0812345678',
    role: UserRole.treasurer,
  );

  group(User, () {
    test('firstName et initials', () {
      expect(treasurer.firstName, 'Grâce');
      expect(treasurer.initials, 'GM');
    });

    test('seul le trésorier gère les cotisations', () {
      expect(treasurer.canManageContributions, isTrue);
      const member = User(
        id: 'usr-003',
        fullName: 'Esther Lukusa',
        email: 'membre1@likelemba.test',
        phone: '',
        role: UserRole.member,
      );
      expect(member.canManageContributions, isFalse);
    });

    test('deux utilisateurs aux mêmes valeurs sont égaux (equatable)', () {
      const copy = User(
        id: 'usr-001',
        fullName: '  Grâce   Mbuyi ',
        email: 'tresorier1@likelemba.test',
        phone: '0812345678',
        role: UserRole.treasurer,
      );
      expect(copy, treasurer);
    });
  });
}

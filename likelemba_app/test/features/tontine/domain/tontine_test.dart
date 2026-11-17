import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/features/tontine/domain/entities/member.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('le rôle appartient à l’appartenance, pas à la personne', () {
    test('la même personne gère une tontine et pas l’autre', () {
      // Grâce, un seul compte, deux rôles : impossible à exprimer avec un
      // rôle posé sur User.
      expect(tMarket.canManage, isTrue);
      expect(tTeachers.canManage, isFalse);
    });

    test('Member porte le rôle', () {
      expect(tGrace.isTreasurer, isTrue);
      expect(tJunior.isTreasurer, isFalse);
      expect(tJunior.role, MemberRole.member);
    });
  });

  test('la cagnotte d’un tour = cotisation × nombre de membres', () {
    expect(tMarket.potAmount, 100000);
  });

  test('initiales d’un membre', () => expect(tJunior.initials, 'JB'));
}

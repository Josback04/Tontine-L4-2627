import 'package:flutter_test/flutter_test.dart';
import 'package:likelemba_app/features/auth/data/models/user_model.dart';
import 'package:likelemba_app/features/auth/domain/entities/user.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group(UserModel, () {
    test('est un User', () => expect(tUserModel, isA<User>()));

    test('fromJson lit le JSON de l’API', () {
      expect(UserModel.fromJson(tUserJson), tUserModel);
    });

    test('toJson redonne le même JSON (aller-retour)', () {
      expect(tUserModel.toJson(), tUserJson);
    });

    test('un rôle inconnu devient member', () {
      final json = {...tUserJson, 'role': 'admin'};
      expect(UserModel.fromJson(json).role, UserRole.member);
    });
  });
}

import 'package:likelemba_app/features/auth/data/models/user_model.dart';
import 'package:likelemba_app/features/auth/domain/entities/user.dart';

/// Données de test partagées : les mêmes que les comptes de démonstration
/// de likelemba_backend.
const tUserJson = <String, dynamic>{
  'id': 'usr-001',
  'full_name': 'Grâce Mbuyi',
  'email': 'tresorier1@likelemba.test',
  'phone': '0812345678',
};

const tUserModel = UserModel(
  id: 'usr-001',
  fullName: 'Grâce Mbuyi',
  email: 'tresorier1@likelemba.test',
  phone: '0812345678',
);

const User tUser = tUserModel;

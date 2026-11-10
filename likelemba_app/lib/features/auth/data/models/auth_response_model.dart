import 'package:likelemba_app/features/auth/data/models/user_model.dart';

/// Réponse de POST /auth/login et POST /auth/register.
class AuthResponseModel {
  const new({required this.token, required this.user});

  factory fromJson(Map<String, dynamic> json) => AuthResponseModel(
    token: json['token'] as String,
    user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
  );

  final String token;
  final UserModel user;
}

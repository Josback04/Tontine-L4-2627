import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:likelemba_backend/src/api_error.dart';
import 'package:likelemba_backend/src/member.dart';
import 'package:likelemba_backend/src/tontine.dart';
import 'package:likelemba_backend/src/tontine_repository.dart';
import 'package:likelemba_backend/src/user.dart';

/// Ce que l'utilisateur connecté peut voir d'une tontine.
typedef TontineAccess = ({Tontine tontine, Member membership});

/// L'accès de l'utilisateur à la tontine, ou null s'il n'en est pas membre.
///
/// Une tontine dont on n'est pas membre répond 404, pas 403 : on ne révèle
/// même pas qu'elle existe.
TontineAccess? accessTo(RequestContext context, String tontineId) {
  final repository = context.read<TontineRepository>();
  final tontine = repository.findById(tontineId);
  if (tontine == null) return null;
  final membership = repository.membershipOf(
    tontineId,
    context.read<User>().id,
  );
  if (membership == null) return null;
  return (tontine: tontine, membership: membership);
}

Response tontineNotFound() => apiError(
  HttpStatus.notFound,
  'tontine_not_found',
  'Tontine introuvable',
);

/// Le droit de modifier vient du rôle DANS cette tontine.
Response notTreasurer() => apiError(
  HttpStatus.forbidden,
  'not_treasurer',
  'Seul un trésorier de cette tontine peut faire cette action',
);

/// Numéro congolais : 10 chiffres commençant par 0.
bool isValidPhone(Object? phone) =>
    phone is String && RegExp(r'^0\d{9}$').hasMatch(phone);

Map<String, Object?> tontineJson(TontineAccess access, int memberCount) => {
  ...access.tontine.toJson(),
  'member_count': memberCount,
  'my_role': access.membership.role.name,
};

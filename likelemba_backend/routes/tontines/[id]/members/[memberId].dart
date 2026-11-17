import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:likelemba_backend/likelemba_backend.dart';

/// PATCH /tontines/:id/members/:memberId : nom, téléphone ou rôle.
/// DELETE /tontines/:id/members/:memberId : retirer un membre.
/// Réservé aux trésoriers de CETTE tontine.
Future<Response> onRequest(
  RequestContext context,
  String id,
  String memberId,
) async {
  final access = accessTo(context, id);
  if (access == null) return tontineNotFound();
  if (access.membership.role != MemberRole.treasurer) return notTreasurer();

  final repository = context.read<TontineRepository>();
  final member = repository.findMember(id, memberId);
  if (member == null) {
    return apiError(
      HttpStatus.notFound,
      'member_not_found',
      'Membre introuvable',
    );
  }

  try {
    final method = context.request.method;
    if (method == HttpMethod.delete) {
      repository.removeMember(member);
      return Response(statusCode: HttpStatus.noContent);
    }
    if (method != HttpMethod.patch) return methodNotAllowed();

    final body = await readJsonObject(context) ?? {};
    final fullName = body['full_name'];
    final phone = body['phone'];
    final role = MemberRole.values.asNameMap()[body['role']];
    if ((fullName != null &&
            (fullName is! String || fullName.trim().length < 2)) ||
        (phone != null && !isValidPhone(phone)) ||
        (body['role'] != null && role == null)) {
      return apiError(
        HttpStatus.unprocessableEntity,
        'validation_error',
        'Nom, téléphone ou rôle invalide',
      );
    }
    final updated = repository.updateMember(
      member,
      fullName: fullName as String?,
      phone: phone as String?,
      role: role,
    );
    return Response.json(body: {'member': updated.toJson()});
  } on PhoneAlreadyMemberException {
    return apiError(
      HttpStatus.conflict,
      'phone_already_member',
      'Ce numéro est déjà membre de la tontine',
    );
  } on LastTreasurerException {
    return apiError(
      HttpStatus.conflict,
      'last_treasurer',
      'La tontine doit garder au moins un trésorier',
    );
  }
}

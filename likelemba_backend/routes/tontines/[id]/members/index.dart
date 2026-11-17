import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:likelemba_backend/likelemba_backend.dart';

/// GET /tontines/:id/members : tout membre peut voir la liste.
/// POST /tontines/:id/members : seul un trésorier de CETTE tontine ajoute.
Future<Response> onRequest(RequestContext context, String id) async {
  final access = accessTo(context, id);
  if (access == null) return tontineNotFound();

  final repository = context.read<TontineRepository>();
  final method = context.request.method;
  if (method == HttpMethod.get) {
    return Response.json(
      body: {
        'members': [for (final m in repository.membersOf(id)) m.toJson()],
      },
    );
  }
  if (method != HttpMethod.post) return methodNotAllowed();

  if (access.membership.role != MemberRole.treasurer) {
    return notTreasurer();
  }
  final body = await readJsonObject(context);
  final fullName = body?['full_name'];
  final phone = body?['phone'];
  if (fullName is! String ||
      fullName.trim().length < 2 ||
      !isValidPhone(phone)) {
    return apiError(
      HttpStatus.unprocessableEntity,
      'validation_error',
      'full_name (2 car. min.) et phone (10 chiffres) sont obligatoires',
    );
  }
  try {
    final member = repository.addMember(
      tontineId: id,
      fullName: fullName,
      phone: phone! as String,
      existingUser: context.read<UserRepository>().findByPhone(
        phone as String,
      ),
    );
    return Response.json(
      statusCode: HttpStatus.created,
      body: {'member': member.toJson()},
    );
  } on PhoneAlreadyMemberException {
    return _phoneAlreadyMember();
  }
}

Response _phoneAlreadyMember() => apiError(
  HttpStatus.conflict,
  'phone_already_member',
  'Ce numéro est déjà membre de la tontine',
);

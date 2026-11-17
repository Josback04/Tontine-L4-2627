import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:likelemba_backend/likelemba_backend.dart';

/// GET /tontines : mes tontines, avec MON rôle dans chacune.
/// POST /tontines : créer une tontine ; j'en deviens le trésorier.
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _list(context),
    HttpMethod.post => _create(context),
    _ => methodNotAllowed(),
  };
}

Response _list(RequestContext context) {
  final user = context.read<User>();
  final entries = context.read<TontineRepository>().listFor(user.id);
  return Response.json(
    body: {
      'tontines': [
        for (final e in entries)
          tontineJson(
            (tontine: e.tontine, membership: e.membership),
            e.memberCount,
          ),
      ],
    },
  );
}

Future<Response> _create(RequestContext context) async {
  final body = await readJsonObject(context);
  final name = body?['name'];
  final amount = body?['contribution_amount'];
  final frequency = ContributionFrequency.values
      .asNameMap()[body?['frequency']];
  final startDate = DateTime.tryParse(body?['start_date'] as String? ?? '');

  if (name is! String ||
      name.trim().length < 3 ||
      amount is! int ||
      amount <= 0 ||
      frequency == null) {
    return apiError(
      HttpStatus.unprocessableEntity,
      'validation_error',
      'name (3 car. min.), contribution_amount (> 0) et frequency '
          '(weekly | monthly) sont obligatoires',
    );
  }

  final created = context.read<TontineRepository>().create(
    creator: context.read<User>(),
    name: name,
    contributionAmount: amount,
    frequency: frequency,
    startDate: startDate ?? DateTime.now().toUtc(),
  );
  return Response.json(
    statusCode: HttpStatus.created,
    body: {'tontine': tontineJson(created, 1)},
  );
}

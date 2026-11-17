import 'package:likelemba_app/core/errors/failures.dart';

/// La tontine n'existe pas, ou je n'en suis pas membre.
class TontineNotFoundFailure extends Failure {
  const new();
}

/// L'action est réservée aux trésoriers de cette tontine.
class NotTreasurerFailure extends Failure {
  const new();
}

/// Ce numéro est déjà membre de la tontine.
class PhoneAlreadyMemberFailure extends Failure {
  const new();
}

/// La tontine doit garder au moins un trésorier.
class LastTreasurerFailure extends Failure {
  const new();
}

/// Nom, montant ou téléphone invalide.
class InvalidTontineDataFailure extends Failure {
  const new();
}

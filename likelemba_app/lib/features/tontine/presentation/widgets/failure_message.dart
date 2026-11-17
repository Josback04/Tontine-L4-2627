import 'package:likelemba_app/core/errors/failures.dart';
import 'package:likelemba_app/core/l10n/failure_l10n.dart';
import 'package:likelemba_app/core/l10n/l10n.dart';
import 'package:likelemba_app/features/tontine/domain/failures/tontine_failures.dart';

extension TontineFailureMessage on Failure {
  String message(AppLocalizations l10n) => switch (this) {
    TontineNotFoundFailure() => l10n.errorTontineNotFound,
    NotTreasurerFailure() => l10n.errorNotTreasurer,
    PhoneAlreadyMemberFailure() => l10n.errorPhoneAlreadyMember,
    LastTreasurerFailure() => l10n.errorLastTreasurer,
    InvalidTontineDataFailure() => l10n.errorInvalidTontineData,
    _ => commonFailureMessage(this, l10n),
  };
}

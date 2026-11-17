import 'package:likelemba_app/core/l10n/gen/app_localizations.dart';
import 'package:material_ui/material_ui.dart';

export 'package:likelemba_app/core/l10n/gen/app_localizations.dart';

/// Délégués de traduction de l'application.
///
/// Ne pas utiliser `AppLocalizations.localizationsDelegates` : le code généré
/// y met les délégués de `flutter_localizations`, qui traduisent l'ancien
/// `package:flutter/material.dart`. Nos widgets viennent de `material_ui`,
/// qui a ses propres `GlobalMaterialLocalizations` : sans elles, tout champ
/// de texte plante dès que le téléphone n'est pas en anglais.
const appLocalizationsDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  ...GlobalMaterialLocalizations.delegates,
];

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

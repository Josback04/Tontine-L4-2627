// dart format off
// coverage:ignore-file

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Likelemba';

  @override
  String get loginTitle => 'Bon retour !';

  @override
  String get loginSubtitle => 'Connectez-vous pour gérer votre tontine.';

  @override
  String get emailLabel => 'Adresse e-mail';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get invalidEmail => 'Saisissez une adresse e-mail valide.';

  @override
  String invalidPassword(int min) {
    return 'Au moins $min caractères.';
  }

  @override
  String get errorInvalidCredentials => 'E-mail ou mot de passe incorrect.';

  @override
  String get errorNetwork => 'Serveur injoignable. Vérifiez votre connexion.';

  @override
  String get errorServer => 'Une erreur est survenue. Réessayez plus tard.';

  @override
  String get errorSessionExpired => 'Votre session a expiré. Reconnectez-vous.';

  @override
  String welcomeMessage(String name) {
    return 'Bonjour, $name !';
  }
}

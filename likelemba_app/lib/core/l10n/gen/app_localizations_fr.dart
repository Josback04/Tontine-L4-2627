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
  String get splashLoading => 'Ouverture de votre session…';

  @override
  String get loginTitle => 'Bon retour !';

  @override
  String get loginSubtitle => 'Connectez-vous pour gérer votre tontine.';

  @override
  String get registerTitle => 'Créer un compte';

  @override
  String get registerSubtitle => 'Devenez le trésorier de votre tontine.';

  @override
  String get fullNameLabel => 'Nom complet';

  @override
  String get emailLabel => 'Adresse e-mail';

  @override
  String get phoneLabel => 'Téléphone';

  @override
  String get phoneHint => '0812345678';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get registerButton => 'Créer mon compte';

  @override
  String get noAccountPrompt => 'Pas encore de compte ?';

  @override
  String get createAccountLink => 'Créer un compte';

  @override
  String get haveAccountPrompt => 'Déjà un compte ?';

  @override
  String get loginLink => 'Se connecter';

  @override
  String get invalidFullName => 'Saisissez votre nom complet.';

  @override
  String get invalidEmail => 'Saisissez une adresse e-mail valide.';

  @override
  String get invalidPhone => '10 chiffres, commençant par 0.';

  @override
  String invalidPassword(int min) {
    return 'Au moins $min caractères.';
  }

  @override
  String get errorInvalidCredentials => 'E-mail ou mot de passe incorrect.';

  @override
  String get errorEmailAlreadyUsed => 'Un compte existe déjà avec cet e-mail.';

  @override
  String get errorInvalidRegistration => 'Vérifiez les informations saisies.';

  @override
  String get errorNetwork => 'Serveur injoignable. Vérifiez votre connexion.';

  @override
  String get errorServer => 'Une erreur est survenue. Réessayez plus tard.';

  @override
  String get errorSessionExpired => 'Votre session a expiré. Reconnectez-vous.';

  @override
  String homeGreeting(String name) {
    return 'Bonjour, $name';
  }

  @override
  String get roleTreasurer => 'Trésorier';

  @override
  String get roleMember => 'Membre';

  @override
  String get homeEmptyTitle => 'Aucune tontine pour l\'instant';

  @override
  String get homeEmptyBody => 'Vos tontines et leurs cotisations apparaîtront ici.';

  @override
  String get logoutButton => 'Se déconnecter';
}

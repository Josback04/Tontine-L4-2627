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
  String get logoutButton => 'Se déconnecter';

  @override
  String get myTontinesTitle => 'Mes tontines';

  @override
  String get createTontineButton => 'Créer une tontine';

  @override
  String get tontinesEmptyBody => 'Créez votre première tontine, ou demandez à un trésorier de vous ajouter avec votre numéro de téléphone.';

  @override
  String get retryButton => 'Réessayer';

  @override
  String get frequencyWeekly => 'Hebdomadaire';

  @override
  String get frequencyMonthly => 'Mensuelle';

  @override
  String perRound(String amount) {
    return '$amount par tour';
  }

  @override
  String membersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membres',
      one: '1 membre',
      zero: 'Aucun membre',
    );
    return '$_temp0';
  }

  @override
  String get potLabel => 'Cagnotte par tour';

  @override
  String get startDateLabel => 'Début';

  @override
  String get contributionLabel => 'Cotisation';

  @override
  String get createTontineTitle => 'Nouvelle tontine';

  @override
  String get createTontineHint => 'Vous en serez le trésorier : vous pourrez ensuite ajouter les membres.';

  @override
  String get tontineNameLabel => 'Nom de la tontine';

  @override
  String get contributionAmountLabel => 'Cotisation par membre (FC)';

  @override
  String get frequencyLabel => 'Fréquence';

  @override
  String get startDateField => 'Date de début';

  @override
  String get createTontineSubmit => 'Créer la tontine';

  @override
  String get invalidTontineName => 'Au moins 3 caractères.';

  @override
  String get invalidAmount => 'Saisissez un montant supérieur à 0.';

  @override
  String get membersTitle => 'Membres';

  @override
  String get addMemberButton => 'Ajouter un membre';

  @override
  String get addMemberTitle => 'Nouveau membre';

  @override
  String get editMemberTitle => 'Modifier le membre';

  @override
  String get memberFormHint => 'Pas besoin de l\'application : le nom et le téléphone suffisent. Si la personne s\'inscrit un jour avec ce numéro, sa fiche sera reliée à son compte.';

  @override
  String get saveButton => 'Enregistrer';

  @override
  String get cancelButton => 'Annuler';

  @override
  String payoutOrder(int order) {
    return 'Tour n°$order';
  }

  @override
  String get noAccount => 'Sans compte';

  @override
  String get memberReadOnlyNotice => 'Vous êtes membre de cette tontine : seul un trésorier peut modifier la liste.';

  @override
  String get editMemberAction => 'Modifier';

  @override
  String get makeTreasurerAction => 'Nommer trésorier';

  @override
  String get removeTreasurerAction => 'Retirer le rôle de trésorier';

  @override
  String get removeMemberAction => 'Retirer de la tontine';

  @override
  String removeMemberConfirm(String name) {
    return 'Retirer $name de la tontine ?';
  }

  @override
  String get removeButton => 'Retirer';

  @override
  String get errorTontineNotFound => 'Cette tontine est introuvable.';

  @override
  String get errorNotTreasurer => 'Seul un trésorier de cette tontine peut faire cela.';

  @override
  String get errorPhoneAlreadyMember => 'Ce numéro est déjà membre de la tontine.';

  @override
  String get errorLastTreasurer => 'La tontine doit garder au moins un trésorier.';

  @override
  String get errorInvalidTontineData => 'Vérifiez les informations saisies.';

  @override
  String get myRoleLabel => 'Mon rôle dans cette tontine';
}

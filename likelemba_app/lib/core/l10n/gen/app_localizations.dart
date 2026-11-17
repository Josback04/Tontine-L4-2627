// dart format off
// coverage:ignore-file
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'Likelemba'**
  String get appTitle;

  /// No description provided for @splashLoading.
  ///
  /// In fr, this message translates to:
  /// **'Ouverture de votre session…'**
  String get splashLoading;

  /// No description provided for @loginTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bon retour !'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour gérer votre tontine.'**
  String get loginSubtitle;

  /// No description provided for @registerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Devenez le trésorier de votre tontine.'**
  String get registerSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet'**
  String get fullNameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail'**
  String get emailLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get phoneLabel;

  /// No description provided for @phoneHint.
  ///
  /// In fr, this message translates to:
  /// **'0812345678'**
  String get phoneHint;

  /// No description provided for @passwordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get passwordLabel;

  /// No description provided for @showPassword.
  ///
  /// In fr, this message translates to:
  /// **'Afficher le mot de passe'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In fr, this message translates to:
  /// **'Masquer le mot de passe'**
  String get hidePassword;

  /// No description provided for @loginButton.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer mon compte'**
  String get registerButton;

  /// No description provided for @noAccountPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ?'**
  String get noAccountPrompt;

  /// No description provided for @createAccountLink.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get createAccountLink;

  /// No description provided for @haveAccountPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ?'**
  String get haveAccountPrompt;

  /// No description provided for @loginLink.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginLink;

  /// No description provided for @invalidFullName.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez votre nom complet.'**
  String get invalidFullName;

  /// No description provided for @invalidEmail.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez une adresse e-mail valide.'**
  String get invalidEmail;

  /// No description provided for @invalidPhone.
  ///
  /// In fr, this message translates to:
  /// **'10 chiffres, commençant par 0.'**
  String get invalidPhone;

  /// No description provided for @invalidPassword.
  ///
  /// In fr, this message translates to:
  /// **'Au moins {min} caractères.'**
  String invalidPassword(int min);

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In fr, this message translates to:
  /// **'E-mail ou mot de passe incorrect.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailAlreadyUsed.
  ///
  /// In fr, this message translates to:
  /// **'Un compte existe déjà avec cet e-mail.'**
  String get errorEmailAlreadyUsed;

  /// No description provided for @errorInvalidRegistration.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez les informations saisies.'**
  String get errorInvalidRegistration;

  /// No description provided for @errorNetwork.
  ///
  /// In fr, this message translates to:
  /// **'Serveur injoignable. Vérifiez votre connexion.'**
  String get errorNetwork;

  /// No description provided for @errorServer.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue. Réessayez plus tard.'**
  String get errorServer;

  /// No description provided for @errorSessionExpired.
  ///
  /// In fr, this message translates to:
  /// **'Votre session a expiré. Reconnectez-vous.'**
  String get errorSessionExpired;

  /// No description provided for @homeGreeting.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour, {name}'**
  String homeGreeting(String name);

  /// No description provided for @roleTreasurer.
  ///
  /// In fr, this message translates to:
  /// **'Trésorier'**
  String get roleTreasurer;

  /// No description provided for @roleMember.
  ///
  /// In fr, this message translates to:
  /// **'Membre'**
  String get roleMember;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune tontine pour l\'instant'**
  String get homeEmptyTitle;

  /// No description provided for @logoutButton.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get logoutButton;

  /// No description provided for @myTontinesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes tontines'**
  String get myTontinesTitle;

  /// No description provided for @createTontineButton.
  ///
  /// In fr, this message translates to:
  /// **'Créer une tontine'**
  String get createTontineButton;

  /// No description provided for @tontinesEmptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Créez votre première tontine, ou demandez à un trésorier de vous ajouter avec votre numéro de téléphone.'**
  String get tontinesEmptyBody;

  /// No description provided for @retryButton.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retryButton;

  /// No description provided for @frequencyWeekly.
  ///
  /// In fr, this message translates to:
  /// **'Hebdomadaire'**
  String get frequencyWeekly;

  /// No description provided for @frequencyMonthly.
  ///
  /// In fr, this message translates to:
  /// **'Mensuelle'**
  String get frequencyMonthly;

  /// No description provided for @perRound.
  ///
  /// In fr, this message translates to:
  /// **'{amount} par tour'**
  String perRound(String amount);

  /// No description provided for @membersCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun membre} =1{1 membre} other{{count} membres}}'**
  String membersCount(int count);

  /// No description provided for @potLabel.
  ///
  /// In fr, this message translates to:
  /// **'Cagnotte par tour'**
  String get potLabel;

  /// No description provided for @startDateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Début'**
  String get startDateLabel;

  /// No description provided for @contributionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Cotisation'**
  String get contributionLabel;

  /// No description provided for @createTontineTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle tontine'**
  String get createTontineTitle;

  /// No description provided for @createTontineHint.
  ///
  /// In fr, this message translates to:
  /// **'Vous en serez le trésorier : vous pourrez ensuite ajouter les membres.'**
  String get createTontineHint;

  /// No description provided for @tontineNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom de la tontine'**
  String get tontineNameLabel;

  /// No description provided for @contributionAmountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Cotisation par membre (FC)'**
  String get contributionAmountLabel;

  /// No description provided for @frequencyLabel.
  ///
  /// In fr, this message translates to:
  /// **'Fréquence'**
  String get frequencyLabel;

  /// No description provided for @startDateField.
  ///
  /// In fr, this message translates to:
  /// **'Date de début'**
  String get startDateField;

  /// No description provided for @createTontineSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Créer la tontine'**
  String get createTontineSubmit;

  /// No description provided for @invalidTontineName.
  ///
  /// In fr, this message translates to:
  /// **'Au moins 3 caractères.'**
  String get invalidTontineName;

  /// No description provided for @invalidAmount.
  ///
  /// In fr, this message translates to:
  /// **'Saisissez un montant supérieur à 0.'**
  String get invalidAmount;

  /// No description provided for @membersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Membres'**
  String get membersTitle;

  /// No description provided for @addMemberButton.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un membre'**
  String get addMemberButton;

  /// No description provided for @addMemberTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau membre'**
  String get addMemberTitle;

  /// No description provided for @editMemberTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le membre'**
  String get editMemberTitle;

  /// No description provided for @memberFormHint.
  ///
  /// In fr, this message translates to:
  /// **'Pas besoin de l\'application : le nom et le téléphone suffisent. Si la personne s\'inscrit un jour avec ce numéro, sa fiche sera reliée à son compte.'**
  String get memberFormHint;

  /// No description provided for @saveButton.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get saveButton;

  /// No description provided for @cancelButton.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancelButton;

  /// No description provided for @payoutOrder.
  ///
  /// In fr, this message translates to:
  /// **'Tour n°{order}'**
  String payoutOrder(int order);

  /// No description provided for @noAccount.
  ///
  /// In fr, this message translates to:
  /// **'Sans compte'**
  String get noAccount;

  /// No description provided for @memberReadOnlyNotice.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes membre de cette tontine : seul un trésorier peut modifier la liste.'**
  String get memberReadOnlyNotice;

  /// No description provided for @editMemberAction.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get editMemberAction;

  /// No description provided for @makeTreasurerAction.
  ///
  /// In fr, this message translates to:
  /// **'Nommer trésorier'**
  String get makeTreasurerAction;

  /// No description provided for @removeTreasurerAction.
  ///
  /// In fr, this message translates to:
  /// **'Retirer le rôle de trésorier'**
  String get removeTreasurerAction;

  /// No description provided for @removeMemberAction.
  ///
  /// In fr, this message translates to:
  /// **'Retirer de la tontine'**
  String get removeMemberAction;

  /// No description provided for @removeMemberConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Retirer {name} de la tontine ?'**
  String removeMemberConfirm(String name);

  /// No description provided for @removeButton.
  ///
  /// In fr, this message translates to:
  /// **'Retirer'**
  String get removeButton;

  /// No description provided for @errorTontineNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Cette tontine est introuvable.'**
  String get errorTontineNotFound;

  /// No description provided for @errorNotTreasurer.
  ///
  /// In fr, this message translates to:
  /// **'Seul un trésorier de cette tontine peut faire cela.'**
  String get errorNotTreasurer;

  /// No description provided for @errorPhoneAlreadyMember.
  ///
  /// In fr, this message translates to:
  /// **'Ce numéro est déjà membre de la tontine.'**
  String get errorPhoneAlreadyMember;

  /// No description provided for @errorLastTreasurer.
  ///
  /// In fr, this message translates to:
  /// **'La tontine doit garder au moins un trésorier.'**
  String get errorLastTreasurer;

  /// No description provided for @errorInvalidTontineData.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez les informations saisies.'**
  String get errorInvalidTontineData;

  /// No description provided for @myRoleLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mon rôle dans cette tontine'**
  String get myRoleLabel;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

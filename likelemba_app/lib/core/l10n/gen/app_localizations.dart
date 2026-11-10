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

  /// No description provided for @homeEmptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Vos tontines et leurs cotisations apparaîtront ici.'**
  String get homeEmptyBody;

  /// No description provided for @logoutButton.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get logoutButton;
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

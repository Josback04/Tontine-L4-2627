// dart format off
// coverage:ignore-file

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Likelemba';

  @override
  String get splashLoading => 'Opening your session…';

  @override
  String get loginTitle => 'Welcome back!';

  @override
  String get loginSubtitle => 'Sign in to manage your savings group.';

  @override
  String get registerTitle => 'Create an account';

  @override
  String get registerSubtitle => 'Become the treasurer of your savings group.';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get emailLabel => 'Email address';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get phoneHint => '0812345678';

  @override
  String get passwordLabel => 'Password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get registerButton => 'Create my account';

  @override
  String get noAccountPrompt => 'No account yet?';

  @override
  String get createAccountLink => 'Create an account';

  @override
  String get haveAccountPrompt => 'Already have an account?';

  @override
  String get loginLink => 'Sign in';

  @override
  String get invalidFullName => 'Enter your full name.';

  @override
  String get invalidEmail => 'Enter a valid email address.';

  @override
  String get invalidPhone => '10 digits, starting with 0.';

  @override
  String invalidPassword(int min) {
    return 'At least $min characters.';
  }

  @override
  String get errorInvalidCredentials => 'Incorrect email or password.';

  @override
  String get errorEmailAlreadyUsed => 'An account already exists with this email.';

  @override
  String get errorInvalidRegistration => 'Please check the information you entered.';

  @override
  String get errorNetwork => 'Server unreachable. Check your connection.';

  @override
  String get errorServer => 'Something went wrong. Please try again later.';

  @override
  String get errorSessionExpired => 'Your session has expired. Please sign in again.';

  @override
  String homeGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get roleTreasurer => 'Treasurer';

  @override
  String get roleMember => 'Member';

  @override
  String get homeEmptyTitle => 'No savings group yet';

  @override
  String get homeEmptyBody => 'Your savings groups and their contributions will appear here.';

  @override
  String get logoutButton => 'Sign out';
}

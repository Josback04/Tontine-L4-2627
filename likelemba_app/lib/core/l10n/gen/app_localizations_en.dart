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
  String get loginTitle => 'Welcome back!';

  @override
  String get loginSubtitle => 'Sign in to manage your savings group.';

  @override
  String get emailLabel => 'Email address';

  @override
  String get passwordLabel => 'Password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get invalidEmail => 'Enter a valid email address.';

  @override
  String invalidPassword(int min) {
    return 'At least $min characters.';
  }

  @override
  String get errorInvalidCredentials => 'Incorrect email or password.';

  @override
  String get errorNetwork => 'Server unreachable. Check your connection.';

  @override
  String get errorServer => 'Something went wrong. Please try again later.';

  @override
  String get errorSessionExpired => 'Your session has expired. Please sign in again.';

  @override
  String welcomeMessage(String name) {
    return 'Hello, $name!';
  }
}

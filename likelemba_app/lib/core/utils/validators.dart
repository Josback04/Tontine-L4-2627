/// Règles de saisie partagées par les formulaires.
/// Dart pur : testables sans widget, réutilisables dans toutes les features.
abstract final class Validators {
  static final _email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  /// Numéro congolais : 10 chiffres commençant par 0 (ex. 0812345678).
  static final _phone = RegExp(r'^0\d{9}$');

  static const minPasswordLength = 8;

  static bool isEmail(String? value) => _email.hasMatch(value?.trim() ?? '');

  static bool isPhone(String? value) =>
      _phone.hasMatch((value ?? '').replaceAll(' ', ''));

  static bool isPassword(String? value) =>
      (value ?? '').length >= minPasswordLength;

  static bool isFullName(String? value) => (value ?? '').trim().length >= 2;
}

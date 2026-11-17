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
  String get logoutButton => 'Sign out';

  @override
  String get myTontinesTitle => 'My savings groups';

  @override
  String get createTontineButton => 'Create a group';

  @override
  String get tontinesEmptyBody => 'Create your first savings group, or ask a treasurer to add you with your phone number.';

  @override
  String get retryButton => 'Retry';

  @override
  String get frequencyWeekly => 'Weekly';

  @override
  String get frequencyMonthly => 'Monthly';

  @override
  String perRound(String amount) {
    return '$amount per round';
  }

  @override
  String membersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
      zero: 'No members',
    );
    return '$_temp0';
  }

  @override
  String get potLabel => 'Pot per round';

  @override
  String get startDateLabel => 'Start';

  @override
  String get contributionLabel => 'Contribution';

  @override
  String get createTontineTitle => 'New savings group';

  @override
  String get createTontineHint => 'You will be its treasurer and can then add the members.';

  @override
  String get tontineNameLabel => 'Group name';

  @override
  String get contributionAmountLabel => 'Contribution per member (FC)';

  @override
  String get frequencyLabel => 'Frequency';

  @override
  String get startDateField => 'Start date';

  @override
  String get createTontineSubmit => 'Create the group';

  @override
  String get invalidTontineName => 'At least 3 characters.';

  @override
  String get invalidAmount => 'Enter an amount greater than 0.';

  @override
  String get membersTitle => 'Members';

  @override
  String get addMemberButton => 'Add a member';

  @override
  String get addMemberTitle => 'New member';

  @override
  String get editMemberTitle => 'Edit member';

  @override
  String get memberFormHint => 'No app needed: a name and a phone number are enough. If this person signs up with this number one day, their record will be linked to their account.';

  @override
  String get saveButton => 'Save';

  @override
  String get cancelButton => 'Cancel';

  @override
  String payoutOrder(int order) {
    return 'Round $order';
  }

  @override
  String get noAccount => 'No account';

  @override
  String get memberReadOnlyNotice => 'You are a member of this group: only a treasurer can edit the list.';

  @override
  String get editMemberAction => 'Edit';

  @override
  String get makeTreasurerAction => 'Make treasurer';

  @override
  String get removeTreasurerAction => 'Remove treasurer role';

  @override
  String get removeMemberAction => 'Remove from the group';

  @override
  String removeMemberConfirm(String name) {
    return 'Remove $name from the group?';
  }

  @override
  String get removeButton => 'Remove';

  @override
  String get errorTontineNotFound => 'This group could not be found.';

  @override
  String get errorNotTreasurer => 'Only a treasurer of this group can do that.';

  @override
  String get errorPhoneAlreadyMember => 'This number is already a member of the group.';

  @override
  String get errorLastTreasurer => 'The group must keep at least one treasurer.';

  @override
  String get errorInvalidTontineData => 'Please check the information you entered.';

  @override
  String get myRoleLabel => 'My role in this group';
}

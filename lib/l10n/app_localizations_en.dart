// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Cruch';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get nickname => 'Nickname';

  @override
  String get nicknameOrEmail => 'Nickname/Email';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signOut => 'Sign Out';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get userAlreadyExists => 'User with this email already exists';

  @override
  String get checkYourEmail => 'Check your email for confirmation';

  @override
  String get successfulLogin => 'Successful login';

  @override
  String get invalidEmailOrPassword => 'Invalid email or password';

  @override
  String get emailNotConfirmed => 'Email not confirmed. Check your email';

  @override
  String get invalidToken => 'Invalid confirmation code';

  @override
  String get tokenExpired => 'Confirmation code has expired. Request a new one';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get registrationDataNotFound =>
      'Registration data not found. Please register again';

  @override
  String get registrationDataExpired =>
      'Registration data has expired. Please register again';

  @override
  String get emailSuccessfullyConfirmed =>
      'Email successfully confirmed. Registration completed';

  @override
  String get failedToCompleteRegistration => 'Failed to complete registration';

  @override
  String get verificationCodeSent => 'Verification code sent to your email';

  @override
  String registrationError(String error) {
    return 'Registration error: $error';
  }

  @override
  String loginError(String error) {
    return 'Login error: $error';
  }

  @override
  String verificationError(String error) {
    return 'Verification error: $error';
  }

  @override
  String resendCodeError(String error) {
    return 'Error sending code: $error';
  }

  @override
  String get createAccountToContinue => 'Create an account to continue';

  @override
  String get registration => 'Registration';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get enterNickname => 'Enter nickname';

  @override
  String get nicknameMinLength => 'Nickname must be at least 3 characters';

  @override
  String get nicknameMaxLength => 'Nickname must be no more than 50 characters';

  @override
  String get enterEmail => 'Enter email';

  @override
  String get enterValidEmail => 'Enter a valid email';

  @override
  String get enterPassword => 'Enter password';

  @override
  String get confirmPasswordValidation => 'Confirm password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';
}

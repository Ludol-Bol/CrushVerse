import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru')
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Cruch'**
  String get appTitle;

  /// Email label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Nickname label
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickname;

  /// Nickname or Email label for login field
  ///
  /// In en, this message translates to:
  /// **'Nickname/Email'**
  String get nicknameOrEmail;

  /// Sign in button
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Sign up button
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Sign out button
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Remember me checkbox label
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// Forgot password link
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// Error message when user already exists
  ///
  /// In en, this message translates to:
  /// **'User with this email already exists'**
  String get userAlreadyExists;

  /// Message to check email for confirmation
  ///
  /// In en, this message translates to:
  /// **'Check your email for confirmation'**
  String get checkYourEmail;

  /// Success message after login
  ///
  /// In en, this message translates to:
  /// **'Successful login'**
  String get successfulLogin;

  /// Error message for invalid credentials
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidEmailOrPassword;

  /// Error message when email is not confirmed
  ///
  /// In en, this message translates to:
  /// **'Email not confirmed. Check your email'**
  String get emailNotConfirmed;

  /// Error message for invalid token
  ///
  /// In en, this message translates to:
  /// **'Invalid confirmation code'**
  String get invalidToken;

  /// Error message when token expired
  ///
  /// In en, this message translates to:
  /// **'Confirmation code has expired. Request a new one'**
  String get tokenExpired;

  /// Error message for short password
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// Error message when registration data is not found
  ///
  /// In en, this message translates to:
  /// **'Registration data not found. Please register again'**
  String get registrationDataNotFound;

  /// Error message when registration data expired
  ///
  /// In en, this message translates to:
  /// **'Registration data has expired. Please register again'**
  String get registrationDataExpired;

  /// Success message after email confirmation
  ///
  /// In en, this message translates to:
  /// **'Email successfully confirmed. Registration completed'**
  String get emailSuccessfullyConfirmed;

  /// Error message when registration fails
  ///
  /// In en, this message translates to:
  /// **'Failed to complete registration'**
  String get failedToCompleteRegistration;

  /// Message when verification code is sent
  ///
  /// In en, this message translates to:
  /// **'Verification code sent to your email'**
  String get verificationCodeSent;

  /// General registration error
  ///
  /// In en, this message translates to:
  /// **'Registration error: {error}'**
  String registrationError(String error);

  /// General login error
  ///
  /// In en, this message translates to:
  /// **'Login error: {error}'**
  String loginError(String error);

  /// General verification error
  ///
  /// In en, this message translates to:
  /// **'Verification error: {error}'**
  String verificationError(String error);

  /// Error when resending code
  ///
  /// In en, this message translates to:
  /// **'Error sending code: {error}'**
  String resendCodeError(String error);

  /// Subtitle text on registration screen
  ///
  /// In en, this message translates to:
  /// **'Create an account to continue'**
  String get createAccountToContinue;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

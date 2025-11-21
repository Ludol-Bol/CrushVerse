// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Cruch';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get nickname => 'Никнейм';

  @override
  String get nicknameOrEmail => 'Никнейм/Email';

  @override
  String get signIn => 'Войти';

  @override
  String get signUp => 'Регистрация';

  @override
  String get signOut => 'Выйти';

  @override
  String get rememberMe => 'Запомнить меня';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get userAlreadyExists => 'Пользователь с таким email уже существует';

  @override
  String get checkYourEmail => 'Проверьте вашу почту для подтверждения';

  @override
  String get successfulLogin => 'Успешный вход';

  @override
  String get invalidEmailOrPassword => 'Неверный email или пароль';

  @override
  String get emailNotConfirmed => 'Email не подтвержден. Проверьте почту';

  @override
  String get invalidToken => 'Неверный код подтверждения';

  @override
  String get tokenExpired => 'Код подтверждения истек. Запросите новый';

  @override
  String get passwordTooShort => 'Пароль должен быть не менее 6 символов';

  @override
  String get registrationDataNotFound =>
      'Данные регистрации не найдены. Пожалуйста, зарегистрируйтесь снова';

  @override
  String get registrationDataExpired =>
      'Срок действия данных регистрации истек. Пожалуйста, зарегистрируйтесь снова';

  @override
  String get emailSuccessfullyConfirmed =>
      'Email успешно подтвержден. Регистрация завершена';

  @override
  String get failedToCompleteRegistration => 'Не удалось завершить регистрацию';

  @override
  String get verificationCodeSent =>
      'Код подтверждения отправлен на вашу почту';

  @override
  String registrationError(String error) {
    return 'Ошибка регистрации: $error';
  }

  @override
  String loginError(String error) {
    return 'Ошибка входа: $error';
  }

  @override
  String verificationError(String error) {
    return 'Ошибка подтверждения: $error';
  }

  @override
  String resendCodeError(String error) {
    return 'Ошибка отправки кода: $error';
  }
}

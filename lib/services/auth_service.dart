import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cruch/services/email_service.dart';
import 'package:cruch/repositories/user_repository.dart';
import 'package:cruch/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Сервис для аутентификации пользователей
class AuthService {
  // Временное хранилище для данных пользователей, ожидающих подтверждения
  static final Map<String, PendingUser> _pendingUsers = {};

  // Ключи для хранения данных пользователя
  static const String _currentUserIdKey = 'current_user_id';
  static const String _rememberMeKey = 'remember_me';

  /// Регистрация с подтверждением email
  static Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    required String nickname,
  }) async {
    try {
      print('AuthService: Начинаем регистрацию для $email');

      // Проверка, существует ли пользователь с таким email
      print('AuthService: Проверяем существование пользователя');
      final existingUser = await UserRepository.getUserByEmail(email);

      if (existingUser != null) {
        print('AuthService: Пользователь уже существует');
        return AuthResult(
          success: false,
          message: 'Пользователь с таким email уже существует',
        );
      }

      // Сохраняем данные пользователя для последующего создания после подтверждения
      print('AuthService: Сохраняем данные пользователя');
      _pendingUsers[email] = PendingUser(
        email: email,
        password: password,
        nickname: nickname,
        createdAt: DateTime.now(),
      );

      // Отправляем код подтверждения на email
      print('AuthService: Отправляем код подтверждения');
      final emailResult = await EmailService.sendVerificationCode(email: email);

      print('AuthService: Результат отправки email: ${emailResult.success}');
      print('AuthService: Сообщение: ${emailResult.message}');

      if (!emailResult.success) {
        _pendingUsers.remove(email);
        return AuthResult(
          success: false,
          message: emailResult.message,
        );
      }

      print('AuthService: Регистрация успешна, требуется подтверждение email');
      return AuthResult(
        success: true,
        message: 'Проверьте вашу почту для подтверждения',
        needsEmailConfirmation: true,
      );
    } catch (e) {
      print('AuthService: Общая ошибка: $e');
      return AuthResult(
        success: false,
        message: 'Ошибка регистрации: ${e.toString()}',
      );
    }
  }

  /// Вход с email и паролем
  static Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      print('AuthService: Начинаем вход для $email');

      // Ищем пользователя по email
      final user = await UserRepository.getUserByEmail(email);

      if (user == null) {
        print('AuthService: Пользователь с таким email не найден');
        return AuthResult(
          success: false,
          message: 'Неверный email или пароль',
        );
      }

      // Проверяем хеш пароля
      if (user.passwordHash == null || user.passwordHash!.isEmpty) {
        print('AuthService: ⚠️ У пользователя нет сохраненного пароля');
        print(
            'AuthService: Это может быть пользователь, созданный до добавления хеширования паролей');
        print('AuthService: Пытаемся обновить пароль...');

        // Если у пользователя нет пароля, сохраняем его
        final passwordHash = _hashPassword(password);
        final updatedUser =
            await UserRepository.updateUserPassword(user.id, passwordHash);

        if (updatedUser == null) {
          print('AuthService: ❌ Не удалось обновить пароль');
          return AuthResult(
            success: false,
            message: 'Ошибка авторизации. Попробуйте зарегистрироваться заново',
          );
        }

        print(
            'AuthService: ✅ Пароль успешно сохранен для существующего пользователя');
        // Сохраняем ID текущего пользователя и состояние "запомнить меня"
        await _saveCurrentUserId(user.id, rememberMe: rememberMe);

        return AuthResult(
          success: true,
          message: 'Вход выполнен успешно',
          userId: user.id,
        );
      }

      final inputPasswordHash = _hashPassword(password);
      if (inputPasswordHash != user.passwordHash) {
        print('AuthService: Неверный пароль');
        return AuthResult(
          success: false,
          message: 'Неверный email или пароль',
        );
      }

      // Сохраняем ID текущего пользователя и состояние "запомнить меня"
      await _saveCurrentUserId(user.id, rememberMe: rememberMe);

      print('AuthService: ✅ Вход выполнен успешно');
      return AuthResult(
        success: true,
        message: 'Вход выполнен успешно',
        userId: user.id,
      );
    } catch (e, stackTrace) {
      print('AuthService: ❌ Ошибка при входе: $e');
      print('AuthService: Stack trace: $stackTrace');
      return AuthResult(
        success: false,
        message: 'Ошибка входа: ${e.toString()}',
      );
    }
  }

  /// Хеширование пароля
  static String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Сохранение ID текущего пользователя
  static Future<void> _saveCurrentUserId(String userId,
      {bool rememberMe = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currentUserIdKey, userId);
      await prefs.setBool(_rememberMeKey, rememberMe);
      print(
          'AuthService: ID пользователя сохранен: $userId (rememberMe: $rememberMe)');
    } catch (e) {
      print('AuthService: Ошибка сохранения ID пользователя: $e');
    }
  }

  /// Получение ID текущего пользователя
  static Future<String?> getCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_currentUserIdKey);
    } catch (e) {
      print('AuthService: Ошибка получения ID пользователя: $e');
      return null;
    }
  }

  /// Подтверждение email с помощью OTP кода
  static Future<AuthResult> verifyEmailWithOTP({
    required String email,
    required String token,
  }) async {
    try {
      print('AuthService: Подтверждение email для $email');

      // Проверяем код через email service
      final emailResult = EmailService.verifyCode(
        email: email,
        code: token,
      );

      if (!emailResult.success) {
        print('AuthService: Неверный код подтверждения');
        return AuthResult(
          success: false,
          message: emailResult.message,
        );
      }

      // Получаем данные пользователя, ожидающего подтверждения
      final pendingUser = _pendingUsers[email];

      if (pendingUser == null) {
        print('AuthService: Данные регистрации не найдены');
        return AuthResult(
          success: false,
          message:
              'Данные регистрации не найдены. Пожалуйста, зарегистрируйтесь снова',
        );
      }

      // Проверяем, не истек ли срок действия данных (30 минут)
      final now = DateTime.now();
      final difference = now.difference(pendingUser.createdAt);

      if (difference.inMinutes > 30) {
        _pendingUsers.remove(email);
        print('AuthService: Срок действия данных регистрации истек');
        return AuthResult(
          success: false,
          message:
              'Срок действия данных регистрации истек. Пожалуйста, зарегистрируйтесь снова',
        );
      }

      // Создаем пользователя в базе данных после подтверждения email
      print('AuthService: Создаем пользователя после подтверждения email');

      try {
        // Генерируем уникальный ID для пользователя
        // В будущем здесь можно использовать Firebase Auth UID
        final userId = _generateUserId(email);
        print('AuthService: Сгенерирован ID пользователя: $userId');

        // Проверяем, не существует ли уже пользователь с таким email
        final existingUserByEmail =
            await UserRepository.getUserByEmail(pendingUser.email);
        if (existingUserByEmail != null) {
          _pendingUsers.remove(email);
          print('AuthService: Пользователь с таким email уже существует');
          return AuthResult(
            success: false,
            message: 'Пользователь с таким email уже существует',
          );
        }

        // Проверяем уникальность никнейма
        final existingNickname =
            await UserRepository.getUserByNickname(pendingUser.nickname);
        if (existingNickname != null) {
          _pendingUsers.remove(email);
          print('AuthService: Никнейм уже занят: ${pendingUser.nickname}');
          return AuthResult(
            success: false,
            message: 'Никнейм уже занят. Выберите другой',
          );
        }

        // Хешируем пароль перед сохранением
        final passwordHash = _hashPassword(pendingUser.password);
        print(
            'AuthService: Пароль захеширован (первые 20 символов): ${passwordHash.substring(0, 20)}...');
        print('AuthService: Длина хеша: ${passwordHash.length}');

        // Создаем модель пользователя
        final user = UserModel(
          id: userId,
          email: pendingUser.email,
          nickname: pendingUser.nickname,
          createdAt: DateTime.now(),
        );

        print(
            'AuthService: Создаем пользователя в Firestore с хешем пароля...');
        // Создаем пользователя в Firestore с хешем пароля
        // Это автоматически создаст коллекцию 'users', если её еще нет
        final createdUser =
            await UserRepository.createUser(user, passwordHash: passwordHash);

        // Проверяем, что пароль действительно сохранился
        if (createdUser != null) {
          print('AuthService: Проверяем сохранение пароля...');
          final verifyUser = await UserRepository.getUserById(userId);
          if (verifyUser != null) {
            if (verifyUser.passwordHash != null &&
                verifyUser.passwordHash!.isNotEmpty) {
              print('AuthService: ✅ Пароль успешно сохранен в базе данных');
            } else {
              print('AuthService: ❌ ПАРОЛЬ НЕ СОХРАНЕН В БАЗЕ ДАННЫХ!');
            }
          }
        }

        // Удаляем данные из временного хранилища
        _pendingUsers.remove(email);

        if (createdUser == null) {
          print(
              'AuthService: ❌ Ошибка создания пользователя в Firestore - вернулся null');
          print('AuthService: Возможные причины:');
          print(
              'AuthService: 1. Правила безопасности Firestore блокируют запись');
          print('AuthService: 2. Нет подключения к интернету');
          print('AuthService: 3. Firestore не включен в Firebase Console');
          return AuthResult(
            success: false,
            message:
                'Не удалось создать пользователя. Проверьте подключение к интернету и настройки Firestore',
          );
        }

        print('AuthService: ✅ Пользователь успешно создан в Firestore');
        print(
            'AuthService: ID: ${createdUser.id}, Email: ${createdUser.email}, Nickname: ${createdUser.nickname}');

        return AuthResult(
          success: true,
          message: 'Регистрация завершена успешно',
          userId: userId,
        );
      } catch (e, stackTrace) {
        _pendingUsers.remove(email);
        print('AuthService: ❌ Исключение при создании пользователя: $e');
        print('AuthService: Тип ошибки: ${e.runtimeType}');
        print('AuthService: Stack trace: $stackTrace');

        // Более понятные сообщения об ошибках
        String errorMessage = 'Ошибка создания пользователя';
        if (e.toString().contains('PERMISSION_DENIED')) {
          errorMessage =
              'Доступ запрещен. Проверьте правила безопасности Firestore';
        } else if (e.toString().contains('UNAVAILABLE') ||
            e.toString().contains('network')) {
          errorMessage = 'Нет подключения к интернету. Проверьте соединение';
        } else if (e.toString().contains('ALREADY_EXISTS')) {
          errorMessage = 'Пользователь уже существует';
        } else {
          errorMessage = 'Ошибка: ${e.toString()}';
        }

        return AuthResult(
          success: false,
          message: errorMessage,
        );
      }
    } catch (e) {
      print('AuthService: Ошибка подтверждения: $e');
      return AuthResult(
        success: false,
        message: 'Ошибка подтверждения: ${e.toString()}',
      );
    }
  }

  /// Повторная отправка кода подтверждения
  static Future<AuthResult> resendVerificationCode({
    required String email,
  }) async {
    try {
      print('AuthService: Повторная отправка кода для $email');

      // Отправляем новый код через email service
      final emailResult = await EmailService.sendVerificationCode(email: email);

      if (!emailResult.success) {
        print('AuthService: Ошибка отправки кода: ${emailResult.message}');
        return AuthResult(
          success: false,
          message: emailResult.message,
        );
      }

      print('AuthService: Код успешно отправлен повторно');
      return AuthResult(
        success: true,
        message: 'Код подтверждения отправлен на вашу почту',
      );
    } catch (e) {
      print('AuthService: Ошибка повторной отправки кода: $e');
      return AuthResult(
        success: false,
        message: 'Ошибка отправки кода: ${e.toString()}',
      );
    }
  }

  /// Выход из системы
  static Future<void> signOut({bool clearRememberMe = true}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberMe = prefs.getBool(_rememberMeKey) ?? false;

      // Если "запомнить меня" не выбрано или явно указано очистить - удаляем все данные
      if (!rememberMe || clearRememberMe) {
        await prefs.remove(_currentUserIdKey);
        await prefs.remove(_rememberMeKey);
        print('AuthService: Пользователь вышел из системы (данные очищены)');
      } else {
        // Если "запомнить меня" выбрано - оставляем данные для автоматического входа
        print(
            'AuthService: Пользователь вышел из системы (данные сохранены для rememberMe)');
      }
    } catch (e) {
      print('AuthService: Ошибка выхода: $e');
    }
  }

  /// Проверить, выбрано ли "запомнить меня"
  static Future<bool> isRememberMeEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_rememberMeKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Получить текущего пользователя
  static Future<String?> getCurrentUser() async {
    return await getCurrentUserId();
  }

  /// Получить текущего пользователя как UserModel
  static Future<UserModel?> getCurrentUserModel() async {
    final userId = await getCurrentUserId();
    if (userId == null) return null;

    return await UserRepository.getUserById(userId);
  }

  /// Проверка авторизации (проверяет только наличие сохраненного пользователя)
  static Future<bool> isAuthenticated() async {
    final userId = await getCurrentUserId();
    if (userId == null) return false;

    // Проверяем, что пользователь все еще существует
    final user = await UserRepository.getUserById(userId);
    if (user == null) {
      // Если пользователь не найден, очищаем сохраненные данные
      await signOut(clearRememberMe: true);
      return false;
    }

    return true;
  }

  /// Автоматический вход для пользователя с "запомнить меня"
  static Future<UserModel?> autoSignIn() async {
    try {
      final rememberMe = await isRememberMeEnabled();
      if (!rememberMe) {
        print(
            'AuthService: "Запомнить меня" не включено, автоматический вход пропущен');
        return null;
      }

      final userId = await getCurrentUserId();
      if (userId == null) {
        print('AuthService: Нет сохраненного ID пользователя');
        return null;
      }

      print(
          'AuthService: Пытаемся выполнить автоматический вход для пользователя: $userId');
      final user = await UserRepository.getUserById(userId);

      if (user == null) {
        print('AuthService: Пользователь не найден в базе, очищаем данные');
        await signOut(clearRememberMe: true);
        return null;
      }

      print('AuthService: ✅ Автоматический вход выполнен успешно');
      return user;
    } catch (e) {
      print('AuthService: Ошибка автоматического входа: $e');
      return null;
    }
  }

  /// Отправка кода восстановления пароля
  static Future<AuthResult> sendPasswordResetCode({
    required String email,
  }) async {
    try {
      print('AuthService: Запрос восстановления пароля для $email');
      // Проверяем, существует ли пользователь с таким email
      final user = await UserRepository.getUserByEmail(email);
      if (user == null) {
        print('AuthService: Пользователь с таким email не найден');
        // Не раскрываем, что пользователь не существует (безопасность)
        return AuthResult(
          success: true,
          message:
              'Если пользователь с таким email существует, код восстановления будет отправлен',
        );
      }

      // Отправляем код восстановления
      final emailResult =
          await EmailService.sendPasswordResetCode(email: email);

      if (emailResult.success) {
        print('AuthService: ✅ Код восстановления отправлен');
        return AuthResult(
          success: true,
          message: emailResult.message,
        );
      } else {
        print('AuthService: ❌ Ошибка отправки кода: ${emailResult.message}');
        return AuthResult(
          success: false,
          message: emailResult.message,
        );
      }
    } catch (e, stackTrace) {
      print('AuthService: ❌ Ошибка отправки кода восстановления: $e');
      print('AuthService: Stack trace: $stackTrace');
      return AuthResult(
        success: false,
        message: 'Ошибка отправки кода: ${_getAuthErrorMessage(e.toString())}',
      );
    }
  }

  /// Проверка кода восстановления пароля
  static Future<AuthResult> verifyPasswordResetCode({
    required String email,
    required String code,
  }) async {
    try {
      print('AuthService: Проверка кода восстановления для $email');

      final emailResult = EmailService.verifyPasswordResetCode(
        email: email,
        code: code,
      );

      if (emailResult.success) {
        print('AuthService: ✅ Код восстановления подтвержден');
        return AuthResult(
          success: true,
          message: emailResult.message,
        );
      } else {
        print('AuthService: ❌ Неверный код: ${emailResult.message}');
        return AuthResult(
          success: false,
          message: emailResult.message,
        );
      }
    } catch (e) {
      print('AuthService: ❌ Ошибка проверки кода: $e');
      return AuthResult(
        success: false,
        message: 'Ошибка проверки кода: ${_getAuthErrorMessage(e.toString())}',
      );
    }
  }

  /// Сброс пароля
  static Future<AuthResult> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      print('AuthService: Сброс пароля для $email');

      // Проверяем код еще раз
      final verifyResult =
          await verifyPasswordResetCode(email: email, code: code);
      if (!verifyResult.success) {
        return verifyResult;
      }

      // Находим пользователя
      final user = await UserRepository.getUserByEmail(email);
      if (user == null) {
        print('AuthService: Пользователь не найден');
        return AuthResult(
          success: false,
          message: 'Пользователь не найден',
        );
      }

      // Хешируем новый пароль
      final newPasswordHash = _hashPassword(newPassword);

      // Обновляем пароль
      final updatedUser =
          await UserRepository.updateUserPassword(user.id, newPasswordHash);
      if (updatedUser == null) {
        print('AuthService: ❌ Не удалось обновить пароль');
        return AuthResult(
          success: false,
          message: 'Не удалось обновить пароль. Попробуйте позже',
        );
      }

      // Удаляем код восстановления
      EmailService.removePasswordResetCode(email);

      print('AuthService: ✅ Пароль успешно изменен');
      return AuthResult(
        success: true,
        message: 'Пароль успешно изменен',
      );
    } catch (e, stackTrace) {
      print('AuthService: ❌ Ошибка сброса пароля: $e');
      print('AuthService: Stack trace: $stackTrace');
      return AuthResult(
        success: false,
        message: 'Ошибка сброса пароля: ${_getAuthErrorMessage(e.toString())}',
      );
    }
  }

  /// Генерация уникального ID для пользователя
  ///
  /// В будущем здесь можно использовать Firebase Auth UID
  /// Для временного решения используем комбинацию email и timestamp
  static String _generateUserId(String email) {
    // Нормализуем email (приводим к нижнему регистру)
    final normalizedEmail = email.toLowerCase().trim();

    // Создаем уникальный ID на основе email и текущего времени
    // Это гарантирует уникальность даже если два пользователя регистрируются одновременно
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final emailHash = normalizedEmail.hashCode.abs();

    // Комбинируем для создания уникального ID
    return 'user_${emailHash}_$timestamp';
  }

  /// Преобразование ошибок в понятные сообщения
  static String _getAuthErrorMessage(String message) {
    if (message.contains('Invalid login credentials')) {
      return 'Неверный email или пароль';
    } else if (message.contains('User already registered')) {
      return 'Пользователь с таким email уже зарегистрирован';
    } else if (message.contains('Email not confirmed')) {
      return 'Email не подтвержден. Проверьте почту';
    } else if (message.contains('Invalid token')) {
      return 'Неверный код подтверждения';
    } else if (message.contains('Token has expired')) {
      return 'Код подтверждения истек. Запросите новый';
    } else if (message.contains('Password should be at least')) {
      return 'Пароль должен быть не менее 6 символов';
    }
    return message;
  }
}

/// Результат операции аутентификации
class AuthResult {
  final bool success;
  final String message;
  final String? userId;
  final bool needsEmailConfirmation;

  AuthResult({
    required this.success,
    required this.message,
    this.userId,
    this.needsEmailConfirmation = false,
  });
}

/// Класс для хранения данных пользователя, ожидающего подтверждения
class PendingUser {
  final String email;
  final String password;
  final String nickname;
  final DateTime createdAt;

  PendingUser({
    required this.email,
    required this.password,
    required this.nickname,
    required this.createdAt,
  });
}

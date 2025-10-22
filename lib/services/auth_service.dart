import 'package:cruch/services/supabase_service.dart';
import 'package:cruch/services/email_service.dart';
import 'package:cruch/repositories/user_repository.dart';
import 'package:cruch/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Сервис для аутентификации пользователей
class AuthService {
  // Временное хранилище для данных пользователей, ожидающих подтверждения
  static final Map<String, PendingUser> _pendingUsers = {};
  
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
    } on AuthException catch (e) {
      print('AuthService: AuthException: ${e.message}');
      return AuthResult(
        success: false,
        message: _getAuthErrorMessage(e.message),
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
  }) async {
    try {
      final response = await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        return AuthResult(
          success: true,
          message: 'Успешный вход',
          user: response.user,
        );
      }

      return AuthResult(
        success: false,
        message: 'Неверный email или пароль',
      );
    } on AuthException catch (e) {
      return AuthResult(
        success: false,
        message: _getAuthErrorMessage(e.message),
      );
    } catch (e) {
      return AuthResult(
        success: false,
        message: 'Ошибка входа: ${e.toString()}',
      );
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
          message: 'Данные регистрации не найдены. Пожалуйста, зарегистрируйтесь снова',
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
          message: 'Срок действия данных регистрации истек. Пожалуйста, зарегистрируйтесь снова',
        );
      }
      
      // Создаем пользователя в Supabase после подтверждения email
      print('AuthService: Создаем пользователя в Supabase после подтверждения email');
      final response = await SupabaseService.client.auth.signUp(
        email: pendingUser.email,
        password: pendingUser.password,
        data: {
          'nickname': pendingUser.nickname,
        },
      );

      // Удаляем данные из временного хранилища
      _pendingUsers.remove(email);

      if (response.user != null) {
        print('AuthService: Пользователь успешно создан в Supabase, ID: ${response.user!.id}');
        return AuthResult(
          success: true,
          message: 'Email успешно подтвержден. Регистрация завершена',
          user: response.user,
        );
      }

      print('AuthService: Не удалось создать пользователя в Supabase');
      return AuthResult(
        success: false,
        message: 'Не удалось завершить регистрацию',
      );
    } on AuthException catch (e) {
      print('AuthService: AuthException при подтверждении: ${e.message}');
      return AuthResult(
        success: false,
        message: _getAuthErrorMessage(e.message),
      );
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
  static Future<void> signOut() async {
    await SupabaseService.client.auth.signOut();
  }

  /// Получить текущего пользователя
  static User? getCurrentUser() {
    return SupabaseService.currentUser;
  }

  /// Получить текущего пользователя как UserModel
  static Future<UserModel?> getCurrentUserModel() async {
    final user = getCurrentUser();
    if (user == null) return null;
    
    return await UserRepository.getUserById(user.id);
  }

  /// Проверка авторизации
  static bool isAuthenticated() {
    return SupabaseService.isAuthenticated;
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
  final User? user;
  final bool needsEmailConfirmation;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
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


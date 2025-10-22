import 'dart:math';
import 'package:cruch/config/email_config.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

/// Сервис для отправки email
class EmailService {
  // Хранилище кодов верификации (в реальном приложении лучше использовать базу данных)
  static final Map<String, VerificationCode> _verificationCodes = {};
  
  /// Генерация случайного 6-значного кода
  static String _generateCode() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }
  
  /// Отправка кода подтверждения на email
  static Future<EmailResult> sendVerificationCode({
    required String email,
  }) async {
    try {
      print('EmailService: Начинаем отправку кода на $email');
      
      // Генерируем новый код
      final code = _generateCode();
      print('EmailService: Сгенерирован код: $code');
      
      // Сохраняем код с временем создания
      _verificationCodes[email] = VerificationCode(
        code: code,
        createdAt: DateTime.now(),
      );
      
      // Настройка SMTP сервера
      print('EmailService: Настраиваем SMTP сервер');
      print('EmailService: Host: ${EmailConfig.smtpHost}, Port: ${EmailConfig.smtpPort}');
      print('EmailService: SSL: ${EmailConfig.useSsl}, Username: ${EmailConfig.senderEmail}');
      
      final smtpServer = SmtpServer(
        EmailConfig.smtpHost,
        port: EmailConfig.smtpPort,
        ssl: EmailConfig.useSsl,
        allowInsecure: EmailConfig.allowInsecure,
        username: EmailConfig.senderEmail,
        password: EmailConfig.senderPassword,
      );
      
      // Создание письма
      print('EmailService: Создаем письмо');
      final message = Message()
        ..from = Address(EmailConfig.senderEmail, EmailConfig.senderName)
        ..recipients.add(email)
        ..subject = EmailConfig.verificationSubject
        ..html = EmailConfig.verificationBody(code)
        ..text = EmailConfig.verificationBodyPlain(code);
      
      // Отправка письма
      print('EmailService: Отправляем письмо...');
      await send(message, smtpServer);
      print('EmailService: Письмо успешно отправлено');
      
      return EmailResult(
        success: true,
        message: 'Код подтверждения отправлен на $email',
      );
    } catch (e) {
      print('EmailService: Ошибка отправки email: $e');
      print('EmailService: Тип ошибки: ${e.runtimeType}');
      return EmailResult(
        success: false,
        message: 'Ошибка отправки email: ${e.toString()}',
      );
    }
  }
  
  /// Проверка кода подтверждения
  static EmailResult verifyCode({
    required String email,
    required String code,
  }) {
    try {
      final storedCode = _verificationCodes[email];
      
      if (storedCode == null) {
        return EmailResult(
          success: false,
          message: 'Код подтверждения не найден. Запросите новый код',
        );
      }
      
      // Проверка срока действия (10 минут)
      final now = DateTime.now();
      final difference = now.difference(storedCode.createdAt);
      
      if (difference.inMinutes > 10) {
        _verificationCodes.remove(email);
        return EmailResult(
          success: false,
          message: 'Код подтверждения истек. Запросите новый код',
        );
      }
      
      // Проверка самого кода
      if (storedCode.code != code) {
        // Увеличиваем счетчик попыток
        storedCode.attempts++;
        
        // Если слишком много попыток, удаляем код
        if (storedCode.attempts >= 5) {
          _verificationCodes.remove(email);
          return EmailResult(
            success: false,
            message: 'Превышено количество попыток. Запросите новый код',
          );
        }
        
        return EmailResult(
          success: false,
          message: 'Неверный код подтверждения. Осталось попыток: ${5 - storedCode.attempts}',
        );
      }
      
      // Код верный - удаляем его
      _verificationCodes.remove(email);
      
      return EmailResult(
        success: true,
        message: 'Email успешно подтвержден',
      );
    } catch (e) {
      return EmailResult(
        success: false,
        message: 'Ошибка проверки кода: ${e.toString()}',
      );
    }
  }
  
  /// Очистка устаревших кодов (можно вызывать периодически)
  static void cleanupExpiredCodes() {
    final now = DateTime.now();
    _verificationCodes.removeWhere((email, code) {
      final difference = now.difference(code.createdAt);
      return difference.inMinutes > 10;
    });
  }
  
  /// Проверка, существует ли активный код для email
  static bool hasActiveCode(String email) {
    final code = _verificationCodes[email];
    if (code == null) return false;
    
    final now = DateTime.now();
    final difference = now.difference(code.createdAt);
    return difference.inMinutes <= 10;
  }
}

/// Класс для хранения кода верификации
class VerificationCode {
  final String code;
  final DateTime createdAt;
  int attempts;
  
  VerificationCode({
    required this.code,
    required this.createdAt,
    this.attempts = 0,
  });
}

/// Результат операции с email
class EmailResult {
  final bool success;
  final String message;
  
  EmailResult({
    required this.success,
    required this.message,
  });
}


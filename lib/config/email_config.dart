/// Конфигурация для отправки email с кодом подтвержения
class EmailConfig {
  // SMTP сервер настройки для Mail.ru
  static const String smtpHost = 'smtp.mail.ru';
  static const int smtpPort = 465; // Порт для SSL
  
  // Учетные данные отправителя
  static const String senderEmail = 'notifyi@mail.ru';
  static const String senderPassword = 'RJjlv9uRYHnqMX9OMJWf'; // Пароль приложения для Mail.ru
  static const String senderName = 'CruchVerse';
  
  // Настройки безопасности для Mail.ru
  static const bool useSsl = true; // Используем SSL для Mail.ru
  static const bool allowInsecure = false;
  
  // Шаблон письма для верификации
  static const String verificationSubject = 'Подтверждение регистрации';
  
  // Шаблон письма для восстановления пароля
  static const String passwordResetSubject = 'Восстановление пароля';
  
  static String verificationBody(String code) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    body {
      font-family: Arial, sans-serif;
      line-height: 1.6;
      color: #333;
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
    }
    .container {
      background-color: #E5E5E5;
      border-radius: 10px;
      padding: 30px;
      box-shadow: 0 2px 4px rgba(107, 90, 110, 0.1);
    }
    .header {
      text-align: center;
      color: #6B5A6E;
      margin-bottom: 30px;
    }
    .code-container {
      background-color: #fff;
      border: 2px dashed #B89CB8;
      border-radius: 8px;
      padding: 20px;
      text-align: center;
      margin: 30px 0;
    }
    .code {
      font-size: 32px;
      font-weight: bold;
      letter-spacing: 8px;
      color: #684F66;
      font-family: 'Courier New', monospace;
    }
    .footer {
      text-align: center;
      color: #A89BAE;
      font-size: 14px;
      margin-top: 30px;
      padding-top: 20px;
      border-top: 1px solid #C7B6CC;
    }
    .warning {
      color: #e74c3c;
      font-size: 12px;
      margin-top: 15px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>Добро пожаловать в CruchVerse!</h1>
    </div>
    
    <p>Здравствуйте!</p>
    
    <p>Спасибо за регистрацию в нашем приложении. Для завершения регистрации, пожалуйста, введите следующий код подтверждения:</p>
    
    <div class="code-container">
      <div class="code">$code</div>
    </div>
    
    <p>Этот код действителен в течение 10 минут.</p>
    
    <p class="warning">⚠️ Если вы не регистрировались в CruchVerse, просто проигнорируйте это письмо.</p>
    
    <div class="footer">
      <p>С уважением,<br>Команда CruchVerse</p>
      <p style="font-size: 12px; color: #A89BAE;">Это автоматическое письмо, пожалуйста, не отвечайте на него.</p>
    </div>
  </div>
</body>
</html>
''';
  }
  
  // Альтернативный текстовый формат (для клиентов без поддержки HTML)
  static String verificationBodyPlain(String code) {
    return '''
Добро пожаловать в CruchVerse!

Спасибо за регистрацию в нашем приложении. 

Ваш код подтверждения: $code

Этот код действителен в течение 10 минут.

Если вы не регистрировались в CruchVerse, просто проигнорируйте это письмо.

С уважением,
Команда CruchVerse

---
Это автоматическое письмо, пожалуйста, не отвечайте на него.
''';
  }

  static String passwordResetBody(String code) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    body {
      font-family: Arial, sans-serif;
      line-height: 1.6;
      color: #333;
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
    }
    .container {
      background-color: #E5E5E5;
      border-radius: 10px;
      padding: 30px;
      box-shadow: 0 2px 4px rgba(107, 90, 110, 0.1);
    }
    .header {
      text-align: center;
      color: #6B5A6E;
      margin-bottom: 30px;
    }
    .code-container {
      background-color: #fff;
      border: 2px dashed #B89CB8;
      border-radius: 8px;
      padding: 20px;
      text-align: center;
      margin: 30px 0;
    }
    .code {
      font-size: 32px;
      font-weight: bold;
      letter-spacing: 8px;
      color: #684F66;
      font-family: 'Courier New', monospace;
    }
    .footer {
      text-align: center;
      color: #A89BAE;
      font-size: 14px;
      margin-top: 30px;
      padding-top: 20px;
      border-top: 1px solid #C7B6CC;
    }
    .warning {
      color: #e74c3c;
      font-size: 12px;
      margin-top: 15px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>Восстановление пароля</h1>
    </div>
    
    <p>Здравствуйте!</p>
    
    <p>Вы запросили восстановление пароля для вашего аккаунта в CruchVerse. Для сброса пароля используйте следующий код:</p>
    
    <div class="code-container">
      <div class="code">$code</div>
    </div>
    
    <p>Этот код действителен в течение 10 минут.</p>
    
    <p class="warning">⚠️ Если вы не запрашивали восстановление пароля, просто проигнорируйте это письмо. Ваш пароль останется без изменений.</p>
    
    <div class="footer">
      <p>С уважением,<br>Команда CruchVerse</p>
      <p style="font-size: 12px; color: #A89BAE;">Это автоматическое письмо, пожалуйста, не отвечайте на него.</p>
    </div>
  </div>
</body>
</html>
''';
  }

  static String passwordResetBodyPlain(String code) {
    return '''
Восстановление пароля

Здравствуйте!

Вы запросили восстановление пароля для вашего аккаунта в CruchVerse.

Ваш код восстановления: $code

Этот код действителен в течение 10 минут.

Если вы не запрашивали восстановление пароля, просто проигнорируйте это письмо.

С уважением,
Команда CruchVerse

---
Это автоматическое письмо, пожалуйста, не отвечайте на него.
''';
  }
}


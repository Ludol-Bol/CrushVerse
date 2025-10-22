# Настройка Email для отправки кодов подтверждения

Это руководство поможет вам настроить отправку email для кодов подтверждения регистрации.

## Файл конфигурации

Настройки email находятся в файле: `lib/config/email_config.dart`

## Настройка для Gmail

### Шаг 1: Создайте пароль приложения

1. Перейдите на страницу вашего аккаунта Google: https://myaccount.google.com/
2. Выберите "Безопасность" в левом меню
3. Включите "Двухфакторную аутентификацию" (если еще не включена)
4. Найдите раздел "Пароли приложений"
5. Создайте новый пароль приложения:
   - Выберите "Почта" в качестве приложения
   - Выберите устройство (или "Другое" и введите "Flutter App")
6. Скопируйте сгенерированный 16-значный пароль

### Шаг 2: Обновите конфигурацию

Откройте `lib/config/email_config.dart` и обновите следующие параметры:

```dart
// Учетные данные отправителя
static const String senderEmail = 'your-email@gmail.com'; // Ваш Gmail адрес
static const String senderPassword = 'xxxx xxxx xxxx xxxx'; // Пароль приложения (16 символов)
static const String senderName = 'CruchVerse'; // Имя отправителя (можно изменить)
```

### Настройки Gmail (уже настроены):
```dart
static const String smtpHost = 'smtp.gmail.com';
static const int smtpPort = 587;
static const bool useSsl = false; // TLS используется на порту 587
```

## Настройка для других почтовых сервисов

### Яндекс Почта

```dart
static const String smtpHost = 'smtp.yandex.ru';
static const int smtpPort = 465;
static const bool useSsl = true;

static const String senderEmail = 'your-email@yandex.ru';
static const String senderPassword = 'your-password';
```

### Mail.ru

```dart
static const String smtpHost = 'smtp.mail.ru';
static const int smtpPort = 465;
static const bool useSsl = true;

static const String senderEmail = 'your-email@mail.ru';
static const String senderPassword = 'your-password';
```

### Outlook/Hotmail

```dart
static const String smtpHost = 'smtp-mail.outlook.com';
static const int smtpPort = 587;
static const bool useSsl = false;

static const String senderEmail = 'your-email@outlook.com';
static const String senderPassword = 'your-password';
```

### SendGrid (рекомендуется для продакшена)

```dart
static const String smtpHost = 'smtp.sendgrid.net';
static const int smtpPort = 587;
static const bool useSsl = false;

static const String senderEmail = 'apikey'; // Буквально "apikey"
static const String senderPassword = 'your-sendgrid-api-key';
```

### Mailgun (рекомендуется для продакшена)

```dart
static const String smtpHost = 'smtp.mailgun.org';
static const int smtpPort = 587;
static const bool useSsl = false;

static const String senderEmail = 'your-mailgun-email';
static const String senderPassword = 'your-mailgun-password';
```

## Настройка шаблона письма

Вы можете изменить внешний вид письма в файле `lib/config/email_config.dart`:

### Изменить тему письма:
```dart
static const String verificationSubject = 'Подтверждение регистрации';
```

### Изменить HTML шаблон:
Найдите метод `verificationBody(String code)` и отредактируйте HTML код.

### Изменить текстовый шаблон:
Найдите метод `verificationBodyPlain(String code)` для изменения текстовой версии письма.

## Безопасность

### ⚠️ ВАЖНО для продакшена:

1. **НЕ храните пароли в коде!** 
   - Используйте переменные окружения
   - Для Flutter используйте пакет `flutter_dotenv` или `envied`

2. **Пример с flutter_dotenv:**

   Добавьте в `pubspec.yaml`:
   ```yaml
   dependencies:
     flutter_dotenv: ^5.0.2
   ```

   Создайте файл `.env` в корне проекта:
   ```
   SMTP_HOST=smtp.gmail.com
   SMTP_PORT=587
   SENDER_EMAIL=your-email@gmail.com
   SENDER_PASSWORD=your-app-password
   SENDER_NAME=CruchVerse
   ```

   Добавьте `.env` в `.gitignore`

   Обновите `email_config.dart`:
   ```dart
   import 'package:flutter_dotenv/flutter_dotenv.dart';

   class EmailConfig {
     static String get smtpHost => dotenv.env['SMTP_HOST']!;
     static int get smtpPort => int.parse(dotenv.env['SMTP_PORT']!);
     static String get senderEmail => dotenv.env['SENDER_EMAIL']!;
     static String get senderPassword => dotenv.env['SENDER_PASSWORD']!;
     static String get senderName => dotenv.env['SENDER_NAME']!;
     // ...
   }
   ```

## Тестирование

После настройки запустите приложение и попробуйте зарегистрироваться:

1. Введите email и пароль
2. Нажмите "Зарегистрироваться"
3. Проверьте почту (включая папку "Спам")
4. Введите 6-значный код

## Устранение проблем

### Ошибка "Username and Password not accepted"
- Проверьте правильность email и пароля
- Для Gmail: убедитесь, что используете пароль приложения, а не обычный пароль
- Убедитесь, что включена двухфакторная аутентификация

### Письма не приходят
- Проверьте папку "Спам"
- Проверьте правильность SMTP настроек
- Убедитесь, что SMTP порт не заблокирован файрволом

### Ошибка "Connection timeout"
- Проверьте интернет соединение
- Попробуйте изменить порт (587 на 465 или наоборот)
- Проверьте, не блокирует ли антивирус/файрвол соединение

### Письма попадают в спам
- Используйте профессиональный SMTP сервис (SendGrid, Mailgun)
- Настройте SPF и DKIM записи для вашего домена
- Добавьте понятный текст "от кого" письмо

## Рекомендации для продакшена

1. **Используйте профессиональный Email сервис:**
   - SendGrid (12,000 бесплатных писем в месяц)
   - Mailgun (5,000 бесплатных писем в месяц)
   - AWS SES (очень дешево)

2. **Добавьте rate limiting:**
   - Ограничьте количество писем на email (например, 3 в час)
   - Добавьте защиту от ботов (reCAPTCHA)

3. **Мониторинг:**
   - Логируйте все отправленные письма
   - Отслеживайте процент доставки
   - Настройте алерты при сбоях

4. **Храните коды в базе данных:**
   - Текущая реализация хранит коды в памяти
   - Для продакшена лучше хранить в базе данных (Supabase)
   - Это позволит коду работать даже после перезапуска сервера

## Дополнительные ресурсы

- [Gmail SMTP настройки](https://support.google.com/mail/answer/7126229)
- [SendGrid документация](https://docs.sendgrid.com/)
- [Mailgun документация](https://documentation.mailgun.com/)
- [Mailer пакет документация](https://pub.dev/packages/mailer)


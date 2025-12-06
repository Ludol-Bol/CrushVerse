# Локализация приложения Использование

### В виджетах

```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Получить локализацию в виджете
final l10n = AppLocalizations.of(context)!;

// Использовать строки
Text(l10n.email)
Text(l10n.password)
Text(l10n.signIn)
```

### В сервисах (без контекста)

Для использования локализации в сервисах без доступа к контексту, нужно передавать локализацию как параметр:

```dart
// Пример в AuthService
static String _getAuthErrorMessage(String message, AppLocalizations l10n) {
  if (message.contains('Invalid login credentials')) {
    return l10n.invalidEmailOrPassword;
  } else if (message.contains('User already registered')) {
    return l10n.userAlreadyExists;
  }
  // ...
}
```

### С параметрами

```dart
// В ARB файле определено:
// "registrationError": "Ошибка регистрации: {error}"

// Использование:
Text(l10n.registrationError('Ошибка подключения'))
```

## Добавление новых строк

1. Откройте `lib/l10n/app_en.arb` (шаблонный файл)
2. Добавьте новую строку:
```json
{
  "newString": "New String",
  "@newString": {
    "description": "Description of the string"
  }
}
```

3. Добавьте перевод в `lib/l10n/app_ru.arb`:
```json
{
  "newString": "Новая строка"
}
```

4. Запустите `flutter gen-l10n` для генерации кода

## Изменение языка приложения

Язык по умолчанию установлен в `lib/crush_verse_app.dart`:
```dart
locale: const Locale('ru'), // Язык по умолчанию
```

Для динамического изменения языка можно использовать пакет `shared_preferences` или `provider`.







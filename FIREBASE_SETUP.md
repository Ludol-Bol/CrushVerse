# Настройка Firebase

Firebase успешно подключен к проекту. Теперь необходимо добавить конфигурационные файлы.

## Шаги настройки

### 1. Создайте проект в Firebase Console

1. Перейдите на [Firebase Console](https://console.firebase.google.com/)
2. Создайте новый проект или выберите существующий
3. Добавьте приложение для Android и iOS (если планируете поддерживать обе платформы)

### 2. Настройка Android

1. В Firebase Console перейдите в настройки проекта → "Добавить приложение" → Android
2. Укажите Package name: `com.example.cruch` (или ваш собственный)
3. Скачайте файл `google-services.json`
4. Поместите файл `google-services.json` в папку `android/app/`

### 3. Настройка iOS (если нужно)

1. В Firebase Console перейдите в настройки проекта → "Добавить приложение" → iOS
2. Укажите Bundle ID (можно найти в `ios/Runner.xcodeproj/project.pbxproj`)
3. Скачайте файл `GoogleService-Info.plist`
4. Поместите файл `GoogleService-Info.plist` в папку `ios/Runner/`
5. Откройте `ios/Runner.xcworkspace` в Xcode
6. Перетащите `GoogleService-Info.plist` в проект Runner в Xcode
7. Убедитесь, что файл добавлен в Target "Runner"

### 4. Установка зависимостей

Выполните команду:
```bash
flutter pub get
```

### 5. Проверка

После добавления конфигурационных файлов запустите приложение:
```bash
flutter run
```

## Что уже настроено

✅ Добавлен `firebase_core` в `pubspec.yaml`
✅ Настроен Android `build.gradle` для Google Services
✅ Добавлен плагин Google Services в `android/settings.gradle`
✅ Добавлен Firebase BoM и базовые зависимости в `android/app/build.gradle`
✅ Firebase инициализирован в `lib/main.dart`

## Дополнительные сервисы Firebase

Если вы планируете использовать другие сервисы Firebase, добавьте соответствующие зависимости:

- **Firebase Authentication**: `firebase_auth: ^5.3.1`
- **Cloud Firestore**: `cloud_firestore: ^5.4.3`
- **Firebase Storage**: `firebase_storage: ^12.3.2`
- **Firebase Analytics**: `firebase_analytics: ^11.3.3`
- **Firebase Cloud Messaging**: `firebase_messaging: ^15.1.3`

Пример добавления в `pubspec.yaml`:
```yaml
dependencies:
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.3
```

После добавления выполните `flutter pub get`.


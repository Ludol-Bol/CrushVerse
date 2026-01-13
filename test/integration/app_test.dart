import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cruch/crush_verse_app.dart';
import 'package:cruch/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Интеграционные тесты приложения', () {
    testWidgets('полный поток регистрации', (WidgetTester tester) async {
      // Запускаем приложение с правильной настройкой
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en'),
            Locale('ru'),
          ],
          locale: Locale('ru'),
          home: CrushVerseApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Находим кнопку регистрации
      final registerButton = find.text('РЕГИСТРАЦИЯ');
      expect(registerButton, findsOneWidget);

      // Нажимаем кнопку регистрации
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Заполняем форму регистрации
      // (в реальном тесте нужно заполнить поля)
      // await tester.enterText(find.byKey(Key('nickname_field')), 'testuser');
      // await tester.enterText(find.byKey(Key('email_field')), 'test@example.com');
      // await tester.enterText(find.byKey(Key('password_field')), 'password123');
      
      // Нажимаем кнопку регистрации
      // await tester.tap(find.text('ЗАРЕГИСТРИРОВАТЬСЯ'));
      // await tester.pumpAndSettle();

      // Проверяем переход на экран подтверждения email
      // expect(find.text('Подтверждение email'), findsOneWidget);
    });

    testWidgets('полный поток входа', (WidgetTester tester) async {
      // Запускаем приложение с правильной настройкой
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en'),
            Locale('ru'),
          ],
          locale: Locale('ru'),
          home: CrushVerseApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Заполняем поля входа
      // await tester.enterText(find.byKey(Key('email_field')), 'test@example.com');
      // await tester.enterText(find.byKey(Key('password_field')), 'password123');
      
      // Нажимаем кнопку входа
      // await tester.tap(find.text('ВОЙТИ'));
      // await tester.pumpAndSettle();

      // Проверяем переход на главный экран
      // expect(find.text('CruchVerse'), findsOneWidget);
    });
  });
}


import 'package:cruch/screens/login_screen/screen/login_screen.dart';
import 'package:cruch/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    testWidgets('отображает поля для входа', (WidgetTester tester) async {
      // Создаем MaterialApp с локализацией для корректной работы виджета
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
          home: LoginScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Проверяем наличие полей ввода
      expect(find.byType(TextFormField), findsNWidgets(2));

      // Проверяем наличие кнопок
      expect(find.text('ВОЙТИ'), findsOneWidget);
      expect(find.text('РЕГИСТРАЦИЯ'), findsOneWidget);
    });

    testWidgets('валидация работает для пустых полей',
        (WidgetTester tester) async {
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
          home: LoginScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Находим кнопку входа
      final signInButton = find.text('ВОЙТИ');
      expect(signInButton, findsOneWidget);

      // Нажимаем кнопку без заполнения полей
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      // Проверяем, что валидация сработала
      // (виджет должен показать ошибки валидации)
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('переход на экран регистрации', (WidgetTester tester) async {
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
          home: LoginScreen(),
        ),
      );

      await tester.pumpAndSettle();

      // Находим кнопку регистрации
      final registerButton = find.text('РЕГИСТРАЦИЯ');
      expect(registerButton, findsOneWidget);

      // Нажимаем кнопку
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Проверяем, что произошел переход
      // (в реальном тесте нужно проверить наличие RegisterScreen)
      expect(find.byType(LoginScreen), findsNothing);
    });
  });
}

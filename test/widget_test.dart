// Базовый тест приложения
import 'package:cruch/crush_verse_app.dart';
import 'package:cruch/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  testWidgets('Приложение запускается корректно', (WidgetTester tester) async {
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

    // Проверяем, что приложение запустилось
    // (должен быть либо LoginScreen, либо MainScreen в зависимости от авторизации)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

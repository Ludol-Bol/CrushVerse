import 'package:cruch/screens/login_screen/screen/login_screen.dart';
import 'package:cruch/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';

class CrushVerseApp extends StatelessWidget {
  const CrushVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cruch',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
      // Локализация
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // Английский
        Locale('ru'), // Русский
      ],
      locale: const Locale('ru'), // Язык по умолчанию
    );
  }
}
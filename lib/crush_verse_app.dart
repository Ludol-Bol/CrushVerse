import 'package:cruch/screens/login_screen/screen/login_screen.dart';
import 'package:cruch/screens/main_screen.dart';
import 'package:cruch/services/auth_service.dart';
import 'package:cruch/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';

class CrushVerseApp extends StatefulWidget {
  const CrushVerseApp({super.key});

  @override
  State<CrushVerseApp> createState() => _CrushVerseAppState();
}

class _CrushVerseAppState extends State<CrushVerseApp> {
  Widget _home = const Scaffold(
    body: Center(child: CircularProgressIndicator()),
  );

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    // Пытаемся выполнить автоматический вход
    final user = await AuthService.autoSignIn();
    
    if (mounted) {
      setState(() {
        _home = user != null ? const MainScreen() : const LoginScreen();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cruch',
      theme: AppTheme.lightTheme,
      home: _home,
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
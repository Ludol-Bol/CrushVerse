import 'package:cruch/screens/login_screen/screen/login_screen.dart';
import 'package:cruch/themes/app_theme.dart';
import 'package:flutter/material.dart';

class CrushVerseApp extends StatelessWidget {
  const CrushVerseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
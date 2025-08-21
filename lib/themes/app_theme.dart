import 'package:flutter/material.dart';
import 'text_styles.dart';
import 'input_styles.dart';
import 'colors.dart';
import 'button_styles.dart';
import 'checkbox_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryVariant,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
        onPrimary: AppColors.onPrimary,
        onSurface: AppColors.onSurface,
        onBackground: AppColors.onBackground,
        onError: AppColors.onError,
      ),
      inputDecorationTheme: AppInputStyles.theme,
      elevatedButtonTheme: ElevatedButtonThemeData(style: AppButtonStyles.elevated),
      outlinedButtonTheme: OutlinedButtonThemeData(style: AppButtonStyles.outlined),
      textButtonTheme: TextButtonThemeData(style: AppButtonStyles.text),
      checkboxTheme: AppCheckboxStyles.theme,
    );
  }
}
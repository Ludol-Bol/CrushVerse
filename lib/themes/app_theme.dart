import 'package:flutter/material.dart';
import 'text_styles.dart';
import 'input_styles.dart';
import 'colors.dart';
import 'button_styles.dart';
import 'checkbox_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryVariant,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.onPrimary,
        onSurface: AppColors.onSurface,
        onError: AppColors.onError,
      ),
      inputDecorationTheme: AppInputStyles.theme,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.inputBorder,
        selectionColor: AppColors.inputBorder,
        selectionHandleColor: AppColors.inputBorder,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: AppButtonStyles.elevated),
      outlinedButtonTheme: OutlinedButtonThemeData(style: AppButtonStyles.outlined),
      textButtonTheme: TextButtonThemeData(style: AppButtonStyles.text),
      checkboxTheme: AppCheckboxStyles.theme,
    );
  }
}
import 'package:cruch/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class AppInputStyles {
  static const double borderRadius = 12.0;
  static const EdgeInsets contentPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 14,
  );

  static InputDecorationTheme get theme {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: contentPadding,
      labelStyle: AppTextStyles.inputLabel,
      floatingLabelStyle: const TextStyle(color: AppColors.primary),
    );
  }
}
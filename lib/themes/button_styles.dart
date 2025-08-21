import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppButtonStyles {
  static const double borderRadius = 12.0;
  static const EdgeInsetsGeometry padding = EdgeInsets.symmetric(vertical: 16);

  static ButtonStyle get elevated {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  static ButtonStyle get outlined {
    return OutlinedButton.styleFrom(
      side: const BorderSide(color: AppColors.primary),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding,
      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  static ButtonStyle get text {
    return TextButton.styleFrom(
      textStyle: AppTextStyles.bodyText1,
      padding: EdgeInsets.zero,
      minimumSize: const Size(0, 0),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
} 
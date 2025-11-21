import 'package:flutter/material.dart';
import 'colors.dart';

class AppCheckboxStyles {
  static const double borderRadius = 4.0;

  static CheckboxThemeData get theme => CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          return AppColors.background;
        }),
        checkColor: WidgetStateProperty.all(AppColors.inputBorder),
        side: const BorderSide(color: AppColors.inputBorder, width: 2),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      );
} 
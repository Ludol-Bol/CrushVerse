import 'package:flutter/material.dart';
import 'colors.dart';

class AppCheckboxStyles {
  static const double borderRadius = 4.0;

  static CheckboxThemeData get theme => CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return AppColors.divider;
        }),
        checkColor: MaterialStateProperty.all(AppColors.onPrimary),
      );
} 
import 'package:cruch/screens/forgot_password_screen/forgot_password_screen.dart';
import 'package:cruch/themes/text_styles.dart';
import 'package:cruch/themes/colors.dart';
import 'package:cruch/themes/checkbox_styles.dart';
import 'package:cruch/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class RememberMeRowWidget extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const RememberMeRowWidget({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppCheckboxStyles.borderRadius),
              border: Border.all(
                color: AppColors.inputBorder,
                width: 2,
              ),
            ),
            child: value
                ? const Icon(
                    Icons.check,
                    size: 18,
                    color: AppColors.inputBorder,
                  )
                : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(l10n.rememberMe, style: AppTextStyles.bodyText3),
        const Spacer(),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ForgotPasswordScreen(),
              ),
            );
          },
          child: Text(l10n.forgotPassword, style: AppTextStyles.bodyText3),
        ),
      ],
    );
  }
}
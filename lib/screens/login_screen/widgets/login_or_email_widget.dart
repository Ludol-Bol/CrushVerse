import 'package:flutter/material.dart';
import 'package:cruch/themes/text_styles.dart';
import 'package:cruch/themes/colors.dart';
import 'package:cruch/l10n/app_localizations.dart';

class LoginOrEmailWidget extends StatelessWidget {
  const LoginOrEmailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.nicknameOrEmail, style: AppTextStyles.bodyText1),
        const TextField(
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person_outline, color: AppColors.inputBorder),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cruch/themes/text_styles.dart';
import 'package:cruch/themes/colors.dart';
import 'package:cruch/l10n/app_localizations.dart';

class LoginOrEmailWidget extends StatelessWidget {
  final TextEditingController controller;
  
  const LoginOrEmailWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.nicknameOrEmail, style: AppTextStyles.bodyText1),
        TextField(
          controller: controller,
          style: AppTextStyles.inputText,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.person_outline, color: AppColors.inputBorder),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }
}
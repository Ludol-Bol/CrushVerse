import 'package:cruch/themes/text_styles.dart';
import 'package:cruch/themes/colors.dart';
import 'package:cruch/themes/checkbox_styles.dart';
import 'package:cruch/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class RememberMeRowWidget extends StatefulWidget {
  const RememberMeRowWidget({super.key});

  @override
  State<RememberMeRowWidget> createState() => _RememberMeRowWidgetState();
}

class _RememberMeRowWidgetState extends State<RememberMeRowWidget> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        GestureDetector(
          onTap: () => setState(() => _rememberMe = !_rememberMe),
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
            child: _rememberMe
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
          onPressed: () {},
          child: Text(l10n.forgotPassword, style: AppTextStyles.bodyText3),
        ),
      ],
    );
  }
}
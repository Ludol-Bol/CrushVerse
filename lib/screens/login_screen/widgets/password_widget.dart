import 'package:flutter/material.dart';
import 'package:cruch/themes/text_styles.dart';
import 'package:cruch/themes/colors.dart';
import 'package:cruch/l10n/app_localizations.dart';

class PasswordWidget extends StatefulWidget{
  final TextEditingController controller;
  
  const PasswordWidget({
    super.key,
    required this.controller,
  });
  
  @override
  State<PasswordWidget> createState() => _PasswordWidgetState();
}

class _PasswordWidgetState extends State<PasswordWidget> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.password, style: AppTextStyles.bodyText1),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          style: AppTextStyles.inputText,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.inputBorder),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: AppColors.inputBorder,
              ),
              onPressed: _toggleVisibility,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.enterPassword;
            }
            return null;
          },
        ),
      ],
    );
  }
}

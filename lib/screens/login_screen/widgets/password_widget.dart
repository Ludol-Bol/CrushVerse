import 'package:flutter/material.dart';
import 'package:cruch/themes/text_styles.dart';

class PasswordWidget extends StatefulWidget{
  const PasswordWidget({super.key});
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Пароль',
          style: AppTextStyles.bodyText1,
        ),
        TextField(
          obscureText: _obscureText,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
              onPressed: _toggleVisibility,
            ),
          ),
        ),
      ],
    );
  }
}

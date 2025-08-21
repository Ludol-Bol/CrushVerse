import 'package:cruch/themes/text_styles.dart';
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
    return Row(
      children: [
        Checkbox(
          value: _rememberMe,
          onChanged: (val) => setState(() => _rememberMe = val ?? false),
        ),
        const Text('Запомнить меня', style: AppTextStyles.bodyText1),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: const Text('Забыли пароль?'),
        ),
      ],
    );
  }
}
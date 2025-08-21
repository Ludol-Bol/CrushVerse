import 'package:flutter/material.dart';
import 'package:cruch/themes/text_styles.dart';

class LoginOrEmailWidget extends StatelessWidget {
  const LoginOrEmailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Никнейм/Email',
          style: AppTextStyles.bodyText1,
        ),
        TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person_outline),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }
}
import 'package:cruch/screens/login_screen/widgets/password_widget.dart';
import 'package:cruch/screens/login_screen/widgets/widget.dart';
import 'package:cruch/themes/colors.dart';
import 'package:cruch/themes/input_styles.dart';
import 'package:flutter/material.dart';

import '../widgets/remember_me_widget.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class  _LoginScreenState  extends State<LoginScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/image/main_screen_img.png',
                  fit: BoxFit.cover,
                  height: 220,
                ),
              ),
              const SizedBox(height: 24),
              const LoginOrEmailWidget(),
              const SizedBox(height: 12),
              const PasswordWidget(),
              const SizedBox(height: 8),
              const RememberMeRowWidget(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('ВХОД', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.onBackground,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('РЕГИСТРАЦИЯ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset('assets/image/icons-vk.png', width: 50, height: 50),
                    iconSize: 50,
                    padding: const EdgeInsets.all(2),
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 50),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Image.asset('assets/image/icons-google.png', width: 46, height: 46),
                    iconSize: 50,
                    padding: const EdgeInsets.all(2),
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class _SocialButton extends StatelessWidget {
  final String asset;

  final VoidCallback onTap;
  const _SocialButton({required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppInputStyles.borderRadius),
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(AppInputStyles.borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(asset, width: 28, height: 28),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
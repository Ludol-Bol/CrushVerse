import 'package:cruch/screens/login_screen/widgets/password_widget.dart';
import 'package:cruch/screens/register_screen/register_screen.dart';
import 'package:cruch/screens/main_screen.dart';
import 'package:cruch/services/auth_service.dart';
import 'package:cruch/themes/colors.dart';
import 'package:cruch/themes/input_styles.dart';
import 'package:cruch/themes/text_styles.dart';
import 'package:cruch/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../widgets/remember_me_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final result = await AuthService.signInWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result.success) {
      // Переход на главный экран
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset('assets/image/main_screen_img.png',
                  fit: BoxFit.cover,
                  height: 330,
                ),
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.nicknameOrEmail, style: AppTextStyles.bodyText1),
                        TextFormField(
                          controller: _emailController,
                          style: AppTextStyles.inputText,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_outline, color: AppColors.inputBorder),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.enterEmail;
                            }
                            if (!value.contains('@')) {
                              return l10n.enterValidEmail;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    PasswordWidget(controller: _passwordController),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const RememberMeRowWidget(),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonBackground,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        disabledBackgroundColor: AppColors.buttonBackground,
                        disabledForegroundColor: Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(l10n.signIn.toUpperCase(), style: AppTextStyles.bodyText1),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonBackground,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(l10n.signUp.toUpperCase(),
                          style: AppTextStyles.bodyText1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
           ///to do: необходимо сделать после создания основного функционала
           /*   Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset('assets/image/icons-vk.png',
                        width: 50, height: 50),
                    iconSize: 50,
                    padding: const EdgeInsets.all(2),
                    constraints:
                        const BoxConstraints(minWidth: 28, minHeight: 50),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 8),
                  IconButton(icon: Image.asset('assets/image/icons-google.png', width: 46, height: 46),
                    iconSize: 50,
                    padding: const EdgeInsets.all(2),
                    constraints:
                        const BoxConstraints(minWidth: 28, minHeight: 28),
                    onPressed: () {},
                  ),
                ],
              ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
///to do: сделать после того как основной функционал будет реализован
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

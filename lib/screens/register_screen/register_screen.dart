import 'package:cruch/screens/register_screen/verify_email_screen.dart';
import 'package:cruch/services/auth_service.dart';
import 'package:cruch/themes/button_styles.dart';
import 'package:cruch/themes/colors.dart';
import 'package:cruch/themes/input_styles.dart';
import 'package:cruch/themes/text_styles.dart';
import 'package:cruch/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nicknameController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration({Widget? prefixIcon, Widget? suffixIcon}) {
    return InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final result = await AuthService.signUpWithEmail(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      nickname: _nicknameController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result.success) {
      if (result.needsEmailConfirmation) {
        // Переход на экран подтверждения email
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => VerifyEmailScreen(
              email: _emailController.text.trim(),
            ),
          ),
        );
      } else {
        // Email уже подтвержден (или не требуется подтверждение)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.registration,
          style: AppTextStyles.headline4,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.createAccountToContinue,
                  style: AppTextStyles.bodyText1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Никнейм
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.nickname, style: AppTextStyles.bodyText1),
                    TextFormField(
                      controller: _nicknameController,
                      style: AppTextStyles.inputText,
                      decoration: _buildInputDecoration(prefixIcon: const Icon(Icons.person_outline, color: AppColors.inputBorder)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.enterNickname;
                        }
                        if (value.length < 3) {
                          return l10n.nicknameMinLength;
                        }
                        if (value.length > 50) {
                          return l10n.nicknameMaxLength;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Email
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.email, style: AppTextStyles.bodyText1),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: AppTextStyles.inputText,
                      decoration: _buildInputDecoration(prefixIcon: const Icon(Icons.email_outlined, color: AppColors.inputBorder)),
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
                const SizedBox(height: 16),

                // Пароль
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.password, style: AppTextStyles.bodyText1),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      style: AppTextStyles.inputText,
                      decoration: _buildInputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.inputBorder),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.inputBorder,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.enterPassword;
                        }
                        if (value.length < 6) {
                          return l10n.passwordTooShort;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Подтверждение пароля
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.confirmPassword, style: AppTextStyles.bodyText1),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      style: AppTextStyles.inputText,
                      decoration: _buildInputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.inputBorder),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: AppColors.inputBorder,
                          ),
                          onPressed: () {
                            setState(
                                () => _obscureConfirmPassword = !_obscureConfirmPassword);
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.confirmPasswordValidation;
                        }
                        if (value != _passwordController.text) {
                          return l10n.passwordsDoNotMatch;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Кнопка регистрации
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(l10n.signUp.toUpperCase(), style: AppTextStyles.bodyText1),
                ),
                const SizedBox(height: 16),

                // Ссылка на вход
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.alreadyHaveAccount,
                      style: AppTextStyles.bodyText1,
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        l10n.signIn,
                        style: AppTextStyles.bodyText1.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


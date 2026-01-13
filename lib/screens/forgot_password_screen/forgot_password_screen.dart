import 'package:cruch/services/auth_service.dart';
import 'package:cruch/themes/button_styles.dart';
import 'package:cruch/themes/colors.dart';
import 'package:cruch/themes/text_styles.dart';
import 'package:cruch/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _codeSent = false;
  bool _codeVerified = false;
  String? _userEmail;

  final List<TextEditingController> _codeControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _codeFocusNodes = List.generate(6, (_) => FocusNode());
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isVerifyingCode = false;
  bool _isResettingPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    for (var controller in _codeControllers) {
      controller.dispose();
    }
    for (var focusNode in _codeFocusNodes) {
      focusNode.dispose();
    }
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _code {
    return _codeControllers.map((c) => c.text).join();
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final result = await AuthService.sendPasswordResetCode(
      email: _emailController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result.success) {
      setState(() {
        _codeSent = true;
        _userEmail = _emailController.text.trim();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _verifyCode() async {
    final l10n = AppLocalizations.of(context)!;

    if (_code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.enterSixDigitCode),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isVerifyingCode = true);

    final result = await AuthService.verifyPasswordResetCode(
      email: _userEmail!,
      code: _code,
    );

    setState(() => _isVerifyingCode = false);

    if (!mounted) return;

    if (result.success) {
      // Код подтвержден, показываем форму для нового пароля
      setState(() {
        _codeVerified = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.red,
        ),
      );

      // Очистить поля при ошибке
      for (var controller in _codeControllers) {
        controller.clear();
      }
      _codeFocusNodes[0].requestFocus();
    }
  }

  Future<void> _resetPassword() async {
    final l10n = AppLocalizations.of(context)!;

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.passwordsDoNotMatch),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.passwordTooShort),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isResettingPassword = true);

    final result = await AuthService.resetPassword(
      email: _userEmail!,
      code: _code,
      newPassword: _newPasswordController.text,
    );

    setState(() => _isResettingPassword = false);

    if (!mounted) return;

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.passwordChangedSuccessfully),
          backgroundColor: Colors.green,
        ),
      );

      // Переход на экран входа
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _resendCode() async {
    setState(() => _isLoading = true);

    final result = await AuthService.sendPasswordResetCode(
      email: _userEmail!,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.message),
        backgroundColor: result.success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!_codeSent) {
      // Экран ввода email
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
            l10n.forgotPassword,
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
                  const SizedBox(height: 40),
                  Text(
                    l10n.enterEmailForPasswordReset,
                    style: AppTextStyles.bodyText1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.email, style: AppTextStyles.bodyText1),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: AppTextStyles.inputText,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined,
                              color: AppColors.inputBorder),
                        ),
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
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _sendCode,
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
                        : Text(l10n.sendCode.toUpperCase(), style: AppTextStyles.bodyText1),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Экран ввода кода и нового пароля
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
          l10n.passwordReset,
          style: AppTextStyles.headline4,
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                l10n.codeSentTo,
                style: AppTextStyles.bodyText1.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                _userEmail ?? '',
                style: AppTextStyles.bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Поля для ввода кода
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => _buildCodeInput(index),
                ),
              ),
              const SizedBox(height: 32),

              // Кнопка подтверждения кода
              ElevatedButton(
                onPressed: _isVerifyingCode ? null : _verifyCode,
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
                child: _isVerifyingCode
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(l10n.confirmCode.toUpperCase(), style: AppTextStyles.bodyText1),
              ),
              const SizedBox(height: 24),

              // Повторная отправка
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.didNotReceiveCode,
                    style: AppTextStyles.bodyText1.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: _isLoading ? null : _resendCode,
                    child: _isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.sendAgain),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Поля для нового пароля (показываются после подтверждения кода)
              if (_codeVerified)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.newPassword, style: AppTextStyles.bodyText1),
                        TextFormField(
                          controller: _newPasswordController,
                          obscureText: _obscureNewPassword,
                          style: AppTextStyles.inputText,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline,
                                color: AppColors.inputBorder),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureNewPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.inputBorder,
                              ),
                              onPressed: () {
                                setState(() =>
                                    _obscureNewPassword = !_obscureNewPassword);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.confirmNewPassword,
                            style: AppTextStyles.bodyText1),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          style: AppTextStyles.inputText,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline,
                                color: AppColors.inputBorder),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: AppColors.inputBorder,
                              ),
                              onPressed: () {
                                setState(() => _obscureConfirmPassword =
                                    !_obscureConfirmPassword);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isResettingPassword ? null : _resetPassword,
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
                      child: _isResettingPassword
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(l10n.changePassword.toUpperCase(), style: AppTextStyles.bodyText1),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeInput(int index) {
    return SizedBox(
      width: 50,
      height: 60,
      child: TextField(
        controller: _codeControllers[index],
        focusNode: _codeFocusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.inputBorder,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.inputBorder, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.inputBorder, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.inputBorder, width: 2),
          ),
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 5) {
              _codeFocusNodes[index + 1].requestFocus();
            } else {
              _codeFocusNodes[index].unfocus();
              _verifyCode();
            }
          }
        },
        onTap: () {
          _codeControllers[index].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _codeControllers[index].text.length,
          );
        },
      ),
    );
  }
}

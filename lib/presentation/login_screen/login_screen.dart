import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/forgot_password_widget.dart';
import './widgets/login_button_widget.dart';
import './widgets/signup_link_widget.dart';
import './widgets/social_login_widget.dart';
import './widgets/spiritual_input_field_widget.dart';
import './widgets/spiritual_logo_widget.dart';
import './widgets/welcome_text_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  // Mock credentials for testing
  final String _mockEmail = "alma@soulconnect.com";
  final String _mockPassword = "spiritual123";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _emailError == null &&
        _passwordError == null;
  }

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _emailError = 'El email es requerido';
      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        _emailError = 'Ingresa un email válido';
      } else {
        _emailError = null;
      }
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = 'La contraseña es requerida';
      } else if (value.length < 6) {
        _passwordError = 'La contraseña debe tener al menos 6 caracteres';
      } else {
        _passwordError = null;
      }
    });
  }

  Future<void> _handleLogin() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate authentication delay
    await Future.delayed(const Duration(seconds: 2));

    // Check mock credentials
    if (_emailController.text.trim() == _mockEmail &&
        _passwordController.text == _mockPassword) {
      // Success - provide haptic feedback
      HapticFeedback.lightImpact();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('¡Bienvenido de vuelta, alma hermosa!'),
            backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        // Navigate to profile creation or matches list
        Navigator.pushReplacementNamed(context, '/matches-list');
      }
    } else {
      // Show spiritual-friendly error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Las credenciales no resuenan con nuestra comunidad. Intenta nuevamente.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _handleForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            const Text('Te enviaremos un enlace de recuperación a tu email'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _handleGoogleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Conectando con Google...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _handleAppleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Conectando con Apple...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _handleSignUp() {
    Navigator.pushNamed(context, '/profile-creation');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 8.h),

                      // Spiritual Logo
                      const SpiritualLogoWidget(),

                      SizedBox(height: 4.h),

                      // Welcome Text
                      const WelcomeTextWidget(),

                      SizedBox(height: 6.h),

                      // Email Input
                      SpiritualInputFieldWidget(
                        label: 'Email',
                        hint: 'Ingresa tu email espiritual',
                        iconName: 'self_improvement',
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        errorText: _emailError,
                        onChanged: _validateEmail,
                      ),

                      SizedBox(height: 3.h),

                      // Password Input
                      SpiritualInputFieldWidget(
                        label: 'Contraseña',
                        hint: 'Tu clave sagrada',
                        iconName: 'spa',
                        isPassword: true,
                        controller: _passwordController,
                        errorText: _passwordError,
                        onChanged: _validatePassword,
                      ),

                      SizedBox(height: 2.h),

                      // Forgot Password Link
                      ForgotPasswordWidget(
                        onTap: _handleForgotPassword,
                      ),

                      SizedBox(height: 4.h),

                      // Login Button
                      LoginButtonWidget(
                        isLoading: _isLoading,
                        isEnabled: _isFormValid,
                        onPressed: _handleLogin,
                      ),

                      SizedBox(height: 4.h),

                      // Social Login
                      SocialLoginWidget(
                        onGoogleLogin: _handleGoogleLogin,
                        onAppleLogin: _handleAppleLogin,
                      ),

                      SizedBox(height: 4.h),

                      // Sign Up Link
                      SignupLinkWidget(
                        onTap: _handleSignUp,
                      ),

                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

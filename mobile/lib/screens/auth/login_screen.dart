import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../services/biometric_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/ijevo_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'ijeoma.uche@example.com');
  final _passwordController = TextEditingController(text: 'SecretPass123!');
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      await ref.read(authProvider.notifier).login(email: _emailController.text.trim());
      if (mounted) {
        setState(() => _isLoading = false);
        context.go('/home');
      }
    }
  }

  void _onBiometricLogin() async {
    final success = await BiometricService.authenticate(
      reason: 'Log in to Ijevo with Biometrics',
    );
    if (success && mounted) {
      await ref.read(authProvider.notifier).login();
      if (mounted) {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Logo
                Center(
                  child: Image.asset(
                    'assets/ijevo-logo-dark.png',
                    height: 48,
                    errorBuilder: (ctx, err, stack) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              'i',
                              style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('ijevo', style: AppTextStyles.h1.copyWith(fontSize: 28)),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                Text('Welcome Back', style: AppTextStyles.h1),
                const SizedBox(height: 6),
                Text(
                  'Log in to send money, check rates, and manage wallets.',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),

                const SizedBox(height: 32),

                // Email / Phone
                Text('EMAIL OR PHONE NUMBER', style: AppTextStyles.label),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'name@example.com or +44...',
                    prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your email or phone' : null,
                ),

                const SizedBox(height: 18),

                // Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('PASSWORD', style: AppTextStyles.label),
                    InkWell(
                      onTap: () => context.push('/forgot-password'),
                      child: Text(
                        'Forgot Password?',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? 'Please enter your password' : null,
                ),

                const SizedBox(height: 28),

                // Primary Log In Button
                IjevoButton(
                  text: 'Log In',
                  isLoading: _isLoading,
                  onPressed: _onLogin,
                ),

                const SizedBox(height: 20),

                // Biometrics Shortcut
                Center(
                  child: InkWell(
                    onTap: _onBiometricLogin,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.fingerprint, color: AppColors.primary, size: 24),
                          const SizedBox(width: 10),
                          Text(
                            'Quick Log In with Biometrics',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // Sign Up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    InkWell(
                      onTap: () => context.go('/signup'),
                      child: Text(
                        'Sign Up',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

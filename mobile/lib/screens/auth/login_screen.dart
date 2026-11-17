import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/ijevo_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

  void _onBiometricLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => _isLoading = false);
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const Spacer(),

              // Logo & App Name
              Image.asset(
                'assets/ijevo-logo-dark.png',
                height: 54,
                errorBuilder: (ctx, err, stack) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          'i',
                          style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text('ijevo', style: AppTextStyles.h1.copyWith(fontSize: 32)),
                  ],
                ),
              ),

              const SizedBox(height: 36),

              // Avatar Initials
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  color: AppColors.navy,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text('IU', style: AppTextStyles.h1.copyWith(color: Colors.white)),
              ),
              const SizedBox(height: 16),

              Text('Welcome back, Ijeoma', style: AppTextStyles.h2),
              const SizedBox(height: 4),
              Text(
                'ijeoma.uche@example.com',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),

              const SizedBox(height: 32),

              // Quick Biometric Trigger Button
              InkWell(
                onTap: _onBiometricLogin,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.fingerprint, color: AppColors.primary, size: 28),
                      const SizedBox(width: 12),
                      Text(
                        'Unlock with Face ID',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Or Enter App
              IjevoButton(
                text: 'Log In to Account',
                isLoading: _isLoading,
                onPressed: _onBiometricLogin,
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Switched to email/password entry')),
                  );
                },
                child: Text(
                  'Switch account or log in with password',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

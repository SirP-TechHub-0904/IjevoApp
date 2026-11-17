import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/storage_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/back_circle_button.dart';
import '../../widgets/ijevo_button.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onUpdatePassword() async {
    final cur = _currentController.text.trim();
    final newP = _newController.text.trim();
    final conf = _confirmController.text.trim();

    if (cur.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your current password')),
      );
      return;
    }

    if (newP.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New password must be at least 8 characters')),
      );
      return;
    }

    if (newP != conf) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New passwords do not match')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await StorageService.setUserPassword(newP);
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.primary,
          content: Text('Password updated successfully!'),
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Change Password', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Security & Passwords', style: AppTextStyles.h2),
              const SizedBox(height: 6),
              Text(
                'Choose a strong, unique password to safeguard your Ijevo remittance account.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.4),
              ),

              const SizedBox(height: 28),

              // Current Password
              Text('CURRENT PASSWORD', style: AppTextStyles.label),
              const SizedBox(height: 8),
              TextField(
                controller: _currentController,
                obscureText: _obscureCurrent,
                decoration: InputDecoration(
                  hintText: 'Enter current password',
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureCurrent ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),

              const SizedBox(height: 20),

              // New Password
              Text('NEW PASSWORD', style: AppTextStyles.label),
              const SizedBox(height: 8),
              TextField(
                controller: _newController,
                obscureText: _obscureNew,
                decoration: InputDecoration(
                  hintText: 'At least 8 characters',
                  prefixIcon: const Icon(Icons.vpn_key_outlined, color: AppColors.textSecondary),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureNew ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),

              const SizedBox(height: 20),

              // Confirm New Password
              Text('CONFIRM NEW PASSWORD', style: AppTextStyles.label),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  hintText: 'Re-enter new password',
                  prefixIcon: const Icon(Icons.vpn_key_outlined, color: AppColors.textSecondary),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                    onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),

              const SizedBox(height: 24),

              // Security rules box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PASSWORD CRITERIA', style: AppTextStyles.label),
                    const SizedBox(height: 8),
                    _buildRuleItem('Minimum 8 characters long'),
                    _buildRuleItem('Includes at least one uppercase letter (A-Z)'),
                    _buildRuleItem('Includes at least one number (0-9)'),
                    _buildRuleItem('Includes a special character (!@#\$%^&*)'),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              IjevoButton(
                text: 'Update Password',
                isLoading: _isLoading,
                onPressed: _onUpdatePassword,
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRuleItem(String rule) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              rule,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Account', style: AppTextStyles.h2),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: AppColors.navy,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    user.initials,
                    style: AppTextStyles.h2.copyWith(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            user.fullName,
                            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.verified, color: AppColors.primary, size: 18),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user.phoneNumber,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                      Text(
                        user.email,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text('MANAGE', style: AppTextStyles.label),
          const SizedBox(height: 8),

          _buildMenuTile(
            context: context,
            icon: Icons.person_outline,
            title: 'Personal Details',
            subtitle: 'Name, address, email, phone number',
            route: '/account/personal-details',
          ),
          _buildMenuTile(
            context: context,
            icon: Icons.people_outline,
            title: 'Saved Recipients',
            subtitle: 'Manage African bank accounts & mobile money',
            route: '/account/recipients',
          ),
          _buildMenuTile(
            context: context,
            icon: Icons.credit_card_outlined,
            title: 'Payment Methods',
            subtitle: 'Linked bank accounts and cards',
            route: '/account/payment-methods',
          ),
          _buildMenuTile(
            context: context,
            icon: Icons.lock_outline,
            title: 'Security & Preferences',
            subtitle: 'Face ID, alerts, and notifications',
            route: '/account/settings',
          ),

          const SizedBox(height: 24),
          Text('SUPPORT & LEGAL', style: AppTextStyles.label),
          const SizedBox(height: 8),

          _buildMenuTile(
            context: context,
            icon: Icons.help_outline,
            title: 'Help Center & FAQs',
            subtitle: 'Search articles or chat with support',
            route: '/account/help',
          ),
          _buildMenuTile(
            context: context,
            icon: Icons.description_outlined,
            title: 'Legal & Regulatory',
            subtitle: 'FCA terms, privacy policy & cookies',
            route: '/account/legal',
          ),

          const SizedBox(height: 24),

          // Log Out Button
          OutlinedButton.icon(
            onPressed: () {
              context.go('/login');
            },
            icon: const Icon(Icons.logout, color: AppColors.error),
            label: const Text('Log Out', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              side: const BorderSide(color: Color(0xFFFEE2E2)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: const Color(0xFFFEF2F2),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String route,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.surfaceSecondary,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: 20),
        ),
        title: Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
        onTap: () => context.push(route),
      ),
    );
  }
}

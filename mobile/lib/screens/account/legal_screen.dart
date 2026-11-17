import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/back_circle_button.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Legal & Compliance', style: AppTextStyles.h3),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildLegalTile(
            context: context,
            title: 'User Agreement & Terms of Service',
            subtitle: 'v2.4 • Updated Nov 2026',
            slug: 'terms',
          ),
          _buildLegalTile(
            context: context,
            title: 'Privacy Policy & GDPR Compliance',
            subtitle: 'How we safeguard your data',
            slug: 'privacy',
          ),
          _buildLegalTile(
            context: context,
            title: 'Cookie & Tracking Policy',
            subtitle: 'Manage your browser & app preferences',
            slug: 'cookies',
          ),
          _buildLegalTile(
            context: context,
            title: 'Third-Party Software Notices',
            subtitle: 'Open-source licenses & attributions',
            slug: 'licenses',
          ),
          _buildLegalTile(
            context: context,
            title: 'Company Registration Details',
            subtitle: 'Ijevo Remit Ltd (Company No. 14298192)',
            slug: 'company',
          ),

          const SizedBox(height: 32),
          Center(
            child: Text(
              'Ijevo App Version 1.0.0 (Build 202611)',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String slug,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        title: Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
        onTap: () {
          context.push(
            '/account/legal/view',
            extra: {'title': title, 'slug': slug},
          );
        },
      ),
    );
  }
}

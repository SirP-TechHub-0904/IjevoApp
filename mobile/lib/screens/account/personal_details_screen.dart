import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/back_circle_button.dart';

class PersonalDetailsScreen extends ConsumerWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Personal Details', style: AppTextStyles.h3),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildItem('Legal Full Name', user.fullName, isEditable: false),
          _buildItem('Date of Birth', user.dateOfBirth, isEditable: false),
          _buildItem('Residential Address', '${user.address}, ${user.city}, ${user.postcode}', isEditable: true),
          _buildItem('Mobile Phone Number', user.phoneNumber, isEditable: true),
          _buildItem('Email Address', user.email, isEditable: false),
          _buildItem('Country of Residence', user.country, isEditable: false),
          _buildItem('KYC Verification', 'Identity Verified ✓', valueColor: AppColors.primary, isEditable: false),

          const SizedBox(height: 24),

          // Download monthly history PDF
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Downloading full annual statement PDF...')),
              );
            },
            icon: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.primary),
            label: const Text('Download Transfer Statements PDF', style: TextStyle(color: AppColors.textPrimary)),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String label, String value, {bool isEditable = true, Color? valueColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.bodySmall),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          if (isEditable)
            const Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary)
          else
            const Icon(Icons.lock_outline, size: 16, color: AppColors.textMuted),
        ],
      ),
    );
  }
}

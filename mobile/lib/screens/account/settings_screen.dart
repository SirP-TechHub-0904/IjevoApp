import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/back_circle_button.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final notifier = ref.read(authProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Security & Preferences', style: AppTextStyles.h3),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('SECURITY', style: AppTextStyles.label),
          const SizedBox(height: 8),
          _buildToggle(
            title: 'Biometric Unlock (Face ID / Fingerprint)',
            subtitle: 'Quick and secure login to your account',
            value: user.biometricsEnabled,
            onChanged: (val) => notifier.toggleBiometrics(val),
          ),

          const SizedBox(height: 24),
          Text('COMMUNICATION NOTIFICATIONS', style: AppTextStyles.label),
          const SizedBox(height: 8),
          _buildToggle(
            title: 'Push Notifications',
            subtitle: 'Instant alerts on transfer status updates',
            value: user.pushNotifications,
            onChanged: (val) => notifier.togglePush(val),
          ),
          const SizedBox(height: 8),
          _buildToggle(
            title: 'SMS Alerts',
            subtitle: 'Receive text message for completed transfers',
            value: user.smsNotifications,
            onChanged: (val) => notifier.toggleSms(val),
          ),
          const SizedBox(height: 8),
          _buildToggle(
            title: 'WhatsApp Receipts',
            subtitle: 'Get automated PDF receipts on WhatsApp',
            value: user.whatsappNotifications,
            onChanged: (val) => notifier.toggleWhatsapp(val),
          ),
          const SizedBox(height: 8),
          _buildToggle(
            title: 'Email Market Updates',
            subtitle: 'Exchange rate spikes and promo codes',
            value: user.emailNotifications,
            onChanged: (val) => notifier.toggleEmail(val),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primaryLight,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

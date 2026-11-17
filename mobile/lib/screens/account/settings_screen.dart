import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../services/biometric_service.dart';
import '../../services/onesignal_service.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/back_circle_button.dart';
import '../../widgets/ijevo_button.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const Map<String, String> _timeoutLabels = {
    'immediately': 'Immediately (Every time you leave)',
    '15_minutes': 'After 15 minutes of inactivity',
    '1_hour': 'After 1 hour of inactivity',
    '1_day': 'After 1 day',
    '7_days': 'Keep open for 7 days',
  };

  void _showTimeoutPicker(BuildContext context, String currentVal, AuthNotifier notifier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final bottomPadding = MediaQuery.of(ctx).viewPadding.bottom;
        return Container(
          padding: EdgeInsets.fromLTRB(24, 20, 24, 28 + bottomPadding),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Auto-Lock App When Leaving', style: AppTextStyles.h2),
              const SizedBox(height: 6),
              Text(
                'Choose how long the app can remain in the background before requiring biometric authentication or login.',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),

              ..._timeoutLabels.entries.map((entry) {
                final isSelected = entry.key == currentVal;
                return InkWell(
                  onTap: () {
                    notifier.setAutoLockTimeout(entry.key);
                    Navigator.pop(ctx);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryLight : AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            entry.value,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                              color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle, color: AppColors.primary, size: 22)
                        else
                          const Icon(Icons.circle_outlined, color: AppColors.border, size: 22),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _confirmLogout(BuildContext context, AuthNotifier notifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout, color: Colors.red, size: 28),
            ),
            const SizedBox(height: 18),
            Text('Log Out of Ijevo?', style: AppTextStyles.h2, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'You will need your password or biometric unlock to sign back in.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            IjevoButton(
              text: 'Log Out',
              backgroundColor: Colors.red,
              onPressed: () async {
                Navigator.pop(ctx);
                await notifier.logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmResetFreshInstall(BuildContext context, AuthNotifier notifier) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.restart_alt, color: AppColors.primary, size: 28),
            ),
            const SizedBox(height: 18),
            Text('Simulate Fresh Install?', style: AppTextStyles.h2, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'This resets all local storage so you can experience the first-time launcher onboarding carousel and registration flow from scratch.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            IjevoButton(
              text: 'Reset to First Launch',
              onPressed: () async {
                Navigator.pop(ctx);
                await notifier.resetAllForTesting();
                if (context.mounted) {
                  context.go('/onboarding');
                }
              },
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancel',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
          children: [
            Text('SECURITY & APP LOCK', style: AppTextStyles.label),
            const SizedBox(height: 10),

            // 1. Biometric Unlock Toggle
            _buildToggle(
              title: 'Biometric Unlock (Face ID / Fingerprint)',
              subtitle: 'Unlock with biometrics whenever you return to Ijevo',
              value: user.biometricsEnabled,
              onChanged: (val) async {
                if (val) {
                  final canAuth = await BiometricService.authenticate(
                    reason: 'Scan your biometric to enable instant unlock',
                  );
                  if (canAuth) {
                    notifier.toggleBiometrics(true);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: AppColors.primary,
                          content: Text('Biometric unlock enabled successfully!'),
                        ),
                      );
                    }
                  } else {
                    notifier.toggleBiometrics(false);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Biometric verification cancelled or not recognized.'),
                        ),
                      );
                    }
                  }
                } else {
                  notifier.toggleBiometrics(false);
                }
              },
            ),

            const SizedBox(height: 10),

            // 2. Auto-Lock Timeout Selector
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.timer_outlined, color: AppColors.primary, size: 22),
                ),
                title: Text(
                  'Auto-Lock Timeout',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  _timeoutLabels[user.autoLockTimeout] ?? 'Immediately',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                onTap: () => _showTimeoutPicker(context, user.autoLockTimeout, notifier),
              ),
            ),

            const SizedBox(height: 10),

            // 3. Change Password
            Container(
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
                  child: const Icon(Icons.lock_outline, color: AppColors.textPrimary, size: 20),
                ),
                title: Text('Change Password', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text('Update your account security password', style: AppTextStyles.bodySmall),
                trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                onTap: () => context.push('/account/change-password'),
              ),
            ),

            const SizedBox(height: 28),
            Text('COMMUNICATION NOTIFICATIONS', style: AppTextStyles.label),
            const SizedBox(height: 10),

            _buildToggle(
              title: 'Push Notifications',
              subtitle: 'Instant alerts on transfer status updates',
              value: user.pushNotifications,
              onChanged: (val) async {
                notifier.togglePush(val);
                if (val) {
                  await OneSignalService().requestPermission();
                }
              },
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

            const SizedBox(height: 32),
            Text('SESSION & DEMO CONTROLS', style: AppTextStyles.label),
            const SizedBox(height: 10),

            // Log Out Button
            OutlinedButton.icon(
              onPressed: () => _confirmLogout(context, notifier),
              icon: const Icon(Icons.logout, color: Colors.red, size: 20),
              label: const Text(
                'Log Out',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                side: BorderSide(color: Colors.red.withValues(alpha: 0.3)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                backgroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            // Reset to First-Launch button
            TextButton.icon(
              onPressed: () => _confirmResetFreshInstall(context, notifier),
              icon: const Icon(Icons.refresh, color: AppColors.textSecondary, size: 18),
              label: Text(
                'Reset to Fresh Install (Test First-Time Launch)',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
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

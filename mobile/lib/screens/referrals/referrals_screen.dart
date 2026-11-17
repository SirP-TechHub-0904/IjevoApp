import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/ijevo_button.dart';

class ReferralsScreen extends ConsumerWidget {
  const ReferralsScreen({super.key});

  void _showQrModal(BuildContext context, String code) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final bottomPadding = MediaQuery.of(ctx).viewPadding.bottom;
        return Container(
          padding: EdgeInsets.fromLTRB(24, 16, 24, 28 + bottomPadding),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Scan Referral QR Code', style: AppTextStyles.h2),
                const SizedBox(height: 6),
                Text(
                  'Let your friend scan this QR code to sign up with your code $code',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
                    ],
                  ),
                  child: QrImageView(
                    data: 'https://ijevo.com/join?ref=$code',
                    version: QrVersions.auto,
                    size: 160.0,
                    eyeStyle: const QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: AppColors.navy,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                IjevoButton(
                  text: 'Done',
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final code = user.referralCode;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Refer & Earn', style: AppTextStyles.h2),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            children: [
            // Hero Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.navy, Color(0xFF1E3A5F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.navy.withOpacity(0.2),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 36),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Earn £20 for each friend you refer!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your friends get £5 off their first transfer, and you get £20 credited directly to your Ijevo GBP wallet when they send £50 or more.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFFCBD5E1)),
                  ),
                  const SizedBox(height: 20),

                  // Referral Code Box
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          code,
                          style: AppTextStyles.h2.copyWith(
                            color: Colors.white,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: code));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Referral code copied to clipboard!'),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'COPY',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Share Actions Row
            Row(
              children: [
                Expanded(
                  child: IjevoButton(
                    text: 'Share Link',
                    icon: const Icon(Icons.share, size: 18, color: Colors.white),
                    onPressed: () {
                      Share.share(
                        'Join me on Ijevo to send money with zero fees and best exchange rates! Use my referral code $code: https://ijevo.com/join?ref=$code',
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () => _showQrModal(context, code),
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(Icons.qr_code_2, color: AppColors.navy, size: 26),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Stats Cards Row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Total Earned', '£${user.referralEarnings.toStringAsFixed(2)}', Icons.payments_outlined),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('Friends Joined', '3', Icons.people_outline),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // How it works
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How It Works', style: AppTextStyles.h3),
                  const SizedBox(height: 16),
                  _buildStep('1', 'Share your unique invite code with friends & family.'),
                  const SizedBox(height: 14),
                  _buildStep('2', 'They register and make their first transfer of £50 or more.'),
                  const SizedBox(height: 14),
                  _buildStep('3', 'You get £20 bonus instantly paid to your Ijevo GBP wallet!'),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 22),
          const SizedBox(height: 10),
          Text(value, style: AppTextStyles.h2),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _buildStep(String num, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            num,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: AppTextStyles.bodyMedium),
        ),
      ],
    );
  }
}

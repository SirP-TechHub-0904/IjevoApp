import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/card_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/back_circle_button.dart';

class PaymentMethodsManageScreen extends ConsumerWidget {
  const PaymentMethodsManageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardState = ref.watch(cardProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Payment Methods', style: AppTextStyles.h3),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('LINKED UK BANK ACCOUNTS', style: AppTextStyles.label),
          const SizedBox(height: 8),
          _buildCard(
            icon: Icons.account_balance,
            title: 'Lloyds Bank PLC',
            subtitle: 'Sort Code: 30-94-81 • Account: •••• 5591',
            badge: 'Connected',
          ),

          const SizedBox(height: 24),
          Text('SAVED DEBIT CARDS (${cardState.cards.length})', style: AppTextStyles.label),
          const SizedBox(height: 8),

          ...cardState.cards.map((card) {
            return _buildCard(
              icon: Icons.credit_card,
              title: '${card.brand} Debit Card',
              subtitle: '•••• •••• •••• ${card.last4} • Exp ${card.expiryDate}',
              badge: card.isDefault ? 'Default' : 'Verified',
            );
          }),

          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => context.push('/send/link-card'),
            icon: const Icon(Icons.add, color: AppColors.primary),
            label: const Text('Link a New Debit Card', style: TextStyle(color: AppColors.textPrimary)),
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

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String badge,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.surfaceSecondary,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.textPrimary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        badge,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/transfer_provider.dart';
import '../../../providers/wallet_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/back_circle_button.dart';

class PaymentMethodScreen extends ConsumerWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transfer = ref.watch(transferProvider);
    final wallets = ref.watch(walletProvider);
    final gbpWallet = wallets.gbpWallet;

    final methods = [
      {
        'title': 'Instant Bank Transfer',
        'subtitle': 'Connect your UK bank app (Recommended • Free)',
        'icon': Icons.account_balance,
        'badge': 'FASTEST',
      },
      {
        'title': 'Ijevo GBP Wallet',
        'subtitle': 'Available balance: £${gbpWallet?.balance.toStringAsFixed(2) ?? '0.00'}',
        'icon': Icons.account_balance_wallet,
        'badge': 'INSTANT',
      },
      {
        'title': 'Debit Card (•••• 9021)',
        'subtitle': 'Visa • Exp 09/28',
        'icon': Icons.credit_card,
        'badge': null,
      },
      {
        'title': 'Apple Pay',
        'subtitle': 'Fast checkout with Touch / Face ID',
        'icon': Icons.apple,
        'badge': null,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Choose Payment Method', style: AppTextStyles.h3),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ...methods.map((m) {
            final isSelected = transfer.paymentMethod == m['title'];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryLight : AppColors.surfaceSecondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    m['icon'] as IconData,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
                title: Row(
                  children: [
                    Text(
                      m['title'] as String,
                      style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                    ),
                    if (m['badge'] != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          m['badge'] as String,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                subtitle: Text(
                  m['subtitle'] as String,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : const Icon(Icons.circle_outlined, color: AppColors.border),
                onTap: () {
                  ref.read(transferProvider.notifier).selectPaymentMethod(m['title'] as String);
                  Navigator.of(context).pop();
                },
              ),
            );
          }),

          const SizedBox(height: 8),

          // Add New Card Button
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Card entry modal opened')),
              );
            },
            icon: const Icon(Icons.add, color: AppColors.primary),
            label: const Text('Add a new debit card', style: TextStyle(color: AppColors.textPrimary)),
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
}

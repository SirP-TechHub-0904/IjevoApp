import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../providers/card_provider.dart';
import '../../../providers/transfer_provider.dart';
import '../../../providers/wallet_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/back_circle_button.dart';
import '../../../widgets/flag_avatar.dart';

class PaymentMethodScreen extends ConsumerWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transfer = ref.watch(transferProvider);
    final wallets = ref.watch(walletProvider);
    final cardState = ref.watch(cardProvider);
    final currencyFormat = NumberFormat('#,##0.00');

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
          // Section: Multi-Currency Wallets
          Text('PAY WITH WALLET (${wallets.wallets.length})', style: AppTextStyles.label),
          const SizedBox(height: 10),

          ...wallets.wallets.map((w) {
            final walletTitle = '${w.currencyCode} Wallet';
            final isSelected = transfer.paymentMethod == walletTitle ||
                (transfer.paymentMethod.contains(w.currencyCode) && transfer.paymentMethod.contains('Wallet'));
            final formattedBal = '${w.currencySymbol}${currencyFormat.format(w.balance)}';

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                leading: FlagAvatar(countryCode: w.countryCode, size: 36),
                title: Row(
                  children: [
                    Text(
                      w.currencyName,
                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'INSTANT',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  'Available: $formattedBal',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: w.balance > 0 ? AppColors.primaryDark : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : const Icon(Icons.circle_outlined, color: AppColors.border),
                onTap: () {
                  ref.read(transferProvider.notifier).selectPaymentMethod(walletTitle);
                  Navigator.of(context).pop();
                },
              ),
            );
          }),

          const SizedBox(height: 20),

          // Section: Linked Debit Cards
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('LINKED DEBIT CARDS', style: AppTextStyles.label),
              InkWell(
                onTap: () => context.push('/send/link-card'),
                child: Text(
                  '+ Link Card',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          ...cardState.cards.map((card) {
            final cardTitle = '${card.brand} (•••• ${card.last4})';
            final isSelected = transfer.paymentMethod == cardTitle ||
                transfer.paymentMethod.contains(card.last4);

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryLight : AppColors.surfaceSecondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.credit_card,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                ),
                title: Text(
                  cardTitle,
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Expires ${card.expiryDate} • Verified debit',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : const Icon(Icons.circle_outlined, color: AppColors.border),
                onTap: () {
                  ref.read(transferProvider.notifier).selectPaymentMethod(cardTitle);
                  Navigator.of(context).pop();
                },
              ),
            );
          }),

          // Link New Card Button
          OutlinedButton.icon(
            onPressed: () => context.push('/send/link-card'),
            icon: const Icon(Icons.add, color: AppColors.primary),
            label: const Text('Link a new debit card', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              side: const BorderSide(color: AppColors.border, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: Colors.white,
            ),
          ),

          const SizedBox(height: 24),

          // Section: Instant Bank Transfer & Other
          Text('INSTANT BANK TRANSFER', style: AppTextStyles.label),
          const SizedBox(height: 10),

          Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: transfer.paymentMethod.contains('Instant') ? AppColors.primary : AppColors.border,
                width: transfer.paymentMethod.contains('Instant') ? 2 : 1,
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              leading: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: transfer.paymentMethod.contains('Instant') ? AppColors.primaryLight : AppColors.surfaceSecondary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_balance,
                  color: transfer.paymentMethod.contains('Instant') ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
              title: Row(
                children: [
                  Text(
                    'Instant Bank Transfer',
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'RECOMMENDED',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                'Open Banking • Lloyds, Barclays, NatWest, Monzo, etc.',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              trailing: transfer.paymentMethod.contains('Instant')
                  ? const Icon(Icons.check_circle, color: AppColors.primary)
                  : const Icon(Icons.circle_outlined, color: AppColors.border),
              onTap: () {
                ref.read(transferProvider.notifier).selectPaymentMethod('Instant bank transfer');
                Navigator.of(context).pop();
              },
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../providers/card_provider.dart';
import '../../../providers/linked_bank_provider.dart';
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
    final bankState = ref.watch(linkedBankProvider);
    final cardState = ref.watch(cardProvider);
    final wallets = ref.watch(walletProvider);
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
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 80),
          children: [
            // Helper explanation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Select an active wallet, debit card, or UK bank account to debit £${currencyFormat.format(transfer.sendAmount)} for this transfer.',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================
            // 1. ACTIVE & MULTI-CURRENCY WALLETS
            // ==========================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('WALLETS (${wallets.wallets.length})', style: AppTextStyles.label),
                InkWell(
                  onTap: () => context.push('/home/convert'),
                  child: Text(
                    'Convert / Top Up',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ...wallets.wallets.map((w) {
              final walletTitle = '${w.currencyCode} Wallet';
              final isSelected = transfer.paymentMethod == walletTitle ||
                  (transfer.paymentMethodType == 'wallet' && transfer.paymentMethod.contains(w.currencyCode));
              final formattedBal = '${w.currencySymbol}${currencyFormat.format(w.balance)}';
              final isZero = w.balance <= 0.0;
              final hasEnough = w.balance >= transfer.sendAmount;

              return Opacity(
                opacity: isZero ? 0.45 : 1.0,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isZero ? AppColors.surfaceSecondary.withValues(alpha: 0.5) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : (isZero ? AppColors.borderLight : AppColors.border),
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
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isZero ? AppColors.textSecondary : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: isZero ? AppColors.borderLight : AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isZero ? 'ZERO BALANCE' : 'ACTIVE',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isZero ? AppColors.textMuted : AppColors.primary,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      isZero
                          ? 'Available: $formattedBal • Tap to top up'
                          : 'Available: $formattedBal • Zero debit fee',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isZero
                            ? AppColors.textMuted
                            : (hasEnough ? AppColors.primaryDark : AppColors.textSecondary),
                        fontWeight: isZero ? FontWeight.normal : FontWeight.w600,
                      ),
                    ),
                    trailing: isZero
                        ? const Icon(Icons.block, color: AppColors.textMuted, size: 20)
                        : (isSelected
                            ? const Icon(Icons.check_circle, color: AppColors.primary, size: 24)
                            : const Icon(Icons.circle_outlined, color: AppColors.border, size: 24)),
                    onTap: isZero
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${w.currencyName} is empty ($formattedBal). Top up or convert to use this wallet.'),
                                backgroundColor: AppColors.navy,
                                action: SnackBarAction(
                                  label: 'Top Up',
                                  textColor: AppColors.primary,
                                  onPressed: () => context.push('/home/wallets/add-money', extra: w.id),
                                ),
                              ),
                            );
                          }
                        : () {
                            ref.read(transferProvider.notifier).selectPaymentMethod(
                                  walletTitle,
                                  subtitle: 'Available balance: $formattedBal • Instant debit',
                                  badge: 'Active Wallet',
                                  type: 'wallet',
                                );
                            Navigator.of(context).pop();
                          },
                  ),
                ),
              );
            }),

            const SizedBox(height: 18),

            // ==========================================
            // 2. SAVED DEBIT CARDS & LINK CARD
            // ==========================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SAVED DEBIT CARDS (${cardState.cards.length})', style: AppTextStyles.label),
                InkWell(
                  onTap: () => context.push('/send/link-card'),
                  child: Text(
                    '+ Link Card',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ...cardState.cards.map((card) {
              final cardTitle = '${card.brand} Debit Card (${card.last4})';
              final isSelected = transfer.paymentMethod.contains(card.last4) ||
                  (transfer.paymentMethodType == 'card' && transfer.paymentMethod.contains(card.brand));

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
                      Icons.credit_card,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      size: 22,
                    ),
                  ),
                  title: Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${card.brand} Debit Card',
                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: card.isDefault ? AppColors.primaryLight : AppColors.surfaceSecondary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          card.isDefault ? 'DEFAULT' : 'VERIFIED',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: card.isDefault ? AppColors.primary : AppColors.textSecondary,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text(
                        '•••• •••• •••• ${card.last4} • Exp ${card.expiryDate}',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Immediate debit upon confirmation',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark, fontSize: 11),
                      ),
                    ],
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primary, size: 24)
                      : const Icon(Icons.circle_outlined, color: AppColors.border, size: 24),
                  onTap: () {
                    ref.read(transferProvider.notifier).selectPaymentMethod(
                          cardTitle,
                          subtitle: '•••• •••• •••• ${card.last4} • Exp ${card.expiryDate}',
                          badge: card.isDefault ? 'Default' : 'Verified',
                          type: 'card',
                        );
                    Navigator.of(context).pop();
                  },
                ),
              );
            }),

            // Link a new card button (Prominent)
            InkWell(
              onTap: () => context.push('/send/link-card'),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_card_rounded, color: AppColors.primaryDark, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '+ Link a new debit card',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ==========================================
            // 3. LINKED UK BANK ACCOUNTS
            // ==========================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('LINKED UK BANK ACCOUNTS (${bankState.banks.length})', style: AppTextStyles.label),
                InkWell(
                  onTap: () => context.push('/send/bank-picker'),
                  child: Text(
                    '+ Connect Bank',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            ...bankState.banks.map((bank) {
              final bankTitle = '${bank.bankName} (${bank.accountNumber})';
              final isSelected = transfer.paymentMethod.contains(bank.bankName) ||
                  (transfer.paymentMethodType == 'bank' && transfer.paymentMethod.contains(bank.accountNumber));

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
                      Icons.account_balance,
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                      size: 22,
                    ),
                  ),
                  title: Row(
                    children: [
                      Flexible(
                        child: Text(
                          bank.bankName,
                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'CONNECTED',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text(
                        'Sort Code: ${bank.sortCode} • Account: ${bank.accountNumber}',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Instant direct debit via Open Banking',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.primaryDark, fontSize: 11),
                      ),
                    ],
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primary, size: 24)
                      : const Icon(Icons.circle_outlined, color: AppColors.border, size: 24),
                  onTap: () {
                    ref.read(transferProvider.notifier).selectPaymentMethod(
                          bankTitle,
                          subtitle: 'Sort Code: ${bank.sortCode} • Account: ${bank.accountNumber}',
                          badge: 'Connected',
                          type: 'bank',
                        );
                    Navigator.of(context).pop();
                  },
                ),
              );
            }),

            const SizedBox(height: 24),

            // ==========================================
            // 4. OTHER PAYMENT OPTIONS
            // ==========================================
            Text('OTHER PAYMENT OPTIONS', style: AppTextStyles.label),
            const SizedBox(height: 10),

            Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: transfer.paymentMethodType == 'instant' ? AppColors.primary : AppColors.border,
                  width: transfer.paymentMethodType == 'instant' ? 2 : 1,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: transfer.paymentMethodType == 'instant' ? AppColors.primaryLight : AppColors.surfaceSecondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.bolt,
                    color: transfer.paymentMethodType == 'instant' ? AppColors.primary : AppColors.textPrimary,
                    size: 24,
                  ),
                ),
                title: Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Instant Bank Transfer',
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'OPEN BANKING',
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
                  'Pay with any UK banking app (Barclays, NatWest, Monzo, Revolut, HSBC, etc.)',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                trailing: transfer.paymentMethodType == 'instant'
                    ? const Icon(Icons.check_circle, color: AppColors.primary, size: 24)
                    : const Icon(Icons.circle_outlined, color: AppColors.border, size: 24),
                onTap: () {
                  ref.read(transferProvider.notifier).selectPaymentMethod(
                        'Instant bank transfer',
                        subtitle: 'Open Banking • Faster Payments',
                        badge: 'Open Banking',
                        type: 'instant',
                      );
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

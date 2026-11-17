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
import '../../../widgets/ijevo_button.dart';

class ConfirmTransferScreen extends ConsumerWidget {
  const ConfirmTransferScreen({super.key});

  void _showPromoDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Add Promo Code', style: AppTextStyles.h3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter your promotional or referral discount code to get an extra bonus on this transfer.',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                hintText: 'e.g. IJEVO5',
                prefixIcon: Icon(Icons.card_giftcard, color: AppColors.primary),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(90, 40),
            ),
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(transferProvider.notifier).applyPromoCode(controller.text.trim());
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Promo code applied successfully!'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              }
            },
            child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transfer = ref.watch(transferProvider);
    final walletState = ref.watch(walletProvider);
    final cardState = ref.watch(cardProvider);
    final bankState = ref.watch(linkedBankProvider);
    final currencyFormat = NumberFormat('#,##0.00');
    final recipient = transfer.selectedRecipient;

    final sendFormatted = '£${currencyFormat.format(transfer.sendAmount)}';
    final payoutFormatted =
        '${transfer.selectedCountry.currencySymbol}${currencyFormat.format(transfer.payoutAmount)}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Confirm Transfer', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
          child: Column(
          children: [
            // Main Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Amount Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('You send', style: AppTextStyles.bodySmall),
                          const SizedBox(height: 4),
                          Text(sendFormatted, style: AppTextStyles.h2),
                        ],
                      ),
                      const Icon(Icons.arrow_forward, color: AppColors.textSecondary),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('They receive', style: AppTextStyles.bodySmall),
                          const SizedBox(height: 4),
                          Text(
                            payoutFormatted,
                            style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Divider(height: 32, color: AppColors.borderLight),

                  // Detail lines
                  _buildDetailRow(
                    label: 'Exchange rate',
                    value:
                        '1 GBP = ${transfer.selectedCountry.currencySymbol}${currencyFormat.format(transfer.rate)} ${transfer.selectedCountry.currencyCode}',
                  ),
                  const SizedBox(height: 14),
                  _buildDetailRow(
                    label: 'Transfer fee',
                    value: 'FREE (£0.00)',
                    valueColor: AppColors.primary,
                    isBold: true,
                  ),
                  const SizedBox(height: 14),
                  _buildDetailRow(
                    label: 'Estimated delivery',
                    value: 'Within 5 minutes',
                    isBold: true,
                  ),

                  if (transfer.promoCode != null) ...[
                    const SizedBox(height: 14),
                    _buildDetailRow(
                      label: 'Promo Code (${transfer.promoCode})',
                      value: '-£${transfer.discount.toStringAsFixed(2)}',
                      valueColor: AppColors.primary,
                      isBold: true,
                    ),
                  ],

                  const Divider(height: 32, color: AppColors.borderLight),

                  // Recipient info
                  if (recipient != null) ...[
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AppColors.navy,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            recipient.displayInitials,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                recipient.fullName,
                                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${recipient.institutionName} • ${recipient.accountNumber}',
                                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/send/recipient'),
                          child: Text(
                            'Change',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Promo Code Card / Button
            InkWell(
              onTap: () => _showPromoDialog(context, ref),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.confirmation_num_outlined, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        transfer.promoCode != null
                            ? 'Promo code: ${transfer.promoCode} applied'
                            : '+ Add Promo Code',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: transfer.promoCode != null ? AppColors.primary : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Payment Method Section - Direct Vertical List
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('DEBIT FROM', style: AppTextStyles.label.copyWith(fontSize: 11)),
                      Text(
                        'Select payment source',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 1. Wallets listed vertically
                  ...walletState.wallets.map((w) {
                    final isZero = w.balance <= 0.0;
                    final isSelected = transfer.paymentMethod == '${w.currencyCode} Wallet' ||
                        (transfer.paymentMethodType == 'wallet' && transfer.paymentMethod.contains(w.currencyCode));
                    final formattedBal = '${w.currencySymbol}${currencyFormat.format(w.balance)}';

                    return _buildPaymentOptionItem(
                      leading: FlagAvatar(countryCode: w.countryCode, size: 28),
                      title: '${w.currencyCode} Wallet',
                      subtitle: isZero ? 'Balance: $formattedBal (Zero balance)' : 'Balance: $formattedBal',
                      isSelected: isSelected,
                      isZero: isZero,
                      onTap: isZero
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${w.currencyName} is empty ($formattedBal). Top up to use.'),
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
                                    '${w.currencyCode} Wallet',
                                    subtitle: 'Available balance: $formattedBal • Instant debit',
                                    badge: 'Active Wallet',
                                    type: 'wallet',
                                  );
                            },
                    );
                  }),

                  // 2. Saved Cards listed vertically
                  ...cardState.cards.map((c) {
                    final cardTitle = '${c.brand} Debit Card (${c.last4})';
                    final isSelected = transfer.paymentMethod.contains(c.last4) ||
                        (transfer.paymentMethodType == 'card' && transfer.paymentMethod.contains(c.brand));

                    return _buildPaymentOptionItem(
                      leading: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.credit_card_rounded, color: AppColors.primary, size: 16),
                      ),
                      title: '${c.brand} Debit Card',
                      subtitle: 'Card ending with *${c.last4}',
                      isSelected: isSelected,
                      onTap: () {
                        ref.read(transferProvider.notifier).selectPaymentMethod(
                              cardTitle,
                              subtitle: '•••• •••• •••• ${c.last4} • Exp ${c.expiryDate}',
                              badge: c.isDefault ? 'Default' : 'Verified',
                              type: 'card',
                            );
                      },
                    );
                  }),

                  // 3. Linked Banks listed vertically
                  ...bankState.banks.map((b) {
                    final bankTitle = '${b.bankName} (${b.accountNumber})';
                    final isSelected = transfer.paymentMethod.contains(b.bankName) ||
                        (transfer.paymentMethodType == 'bank' && transfer.paymentMethod.contains(b.accountNumber));
                    final last4 = b.accountNumber.length > 4
                        ? b.accountNumber.substring(b.accountNumber.length - 4)
                        : b.accountNumber;

                    return _buildPaymentOptionItem(
                      leading: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 16),
                      ),
                      title: b.bankName,
                      subtitle: 'Bank ending with *$last4',
                      isSelected: isSelected,
                      onTap: () {
                        ref.read(transferProvider.notifier).selectPaymentMethod(
                              bankTitle,
                              subtitle: 'Sort Code: ${b.sortCode} • Account: ${b.accountNumber}',
                              badge: 'Connected',
                              type: 'bank',
                            );
                      },
                    );
                  }),

                  const SizedBox(height: 4),

                  // Link a new debit card or bank
                  InkWell(
                    onTap: () => context.push('/send/link-card'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_circle_outline, size: 18, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Text(
                            '+ Link a new debit card or bank',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Action Button
            IjevoButton(
              text: 'Pay $sendFormatted',
              onPressed: () {
                if (transfer.paymentMethodType == 'instant' ||
                    (transfer.paymentMethod.contains('Instant') && !transfer.paymentMethod.contains('Lloyds'))) {
                  context.push('/send/bank-picker');
                } else {
                  context.push('/send/success');
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
  }

  Widget _buildPaymentOptionItem({
    required Widget leading,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    bool isZero = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryLight
              : (isZero ? AppColors.surfaceSecondary.withValues(alpha: 0.5) : AppColors.surfaceSecondary),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isZero ? AppColors.borderLight : AppColors.border),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isZero ? AppColors.textMuted : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isZero ? AppColors.textMuted : AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelected ? AppColors.primary : AppColors.border,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    Color? valueColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

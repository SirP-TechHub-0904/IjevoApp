import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../providers/transfer_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/back_circle_button.dart';
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
                    content: Text('Promo code applied successfully! 🎉'),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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
                    value: 'Within 5 minutes ⚡',
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

            // Payment Method Selector
            InkWell(
              onTap: () => context.push('/send/payment-method'),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceSecondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.account_balance, color: AppColors.textPrimary, size: 20),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Payment Method', style: AppTextStyles.bodySmall),
                          const SizedBox(height: 2),
                          Text(
                            transfer.paymentMethod,
                            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: AppColors.textMuted),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action Button
            IjevoButton(
              text: 'Pay $sendFormatted',
              onPressed: () {
                if (transfer.paymentMethod.contains('Instant')) {
                  context.push('/send/bank-picker');
                } else {
                  context.push('/send/success');
                }
              },
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shield_outlined, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Text(
                  'FCA Regulated & Protected',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted),
                ),
              ],
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../models/transaction_model.dart';
import '../../providers/transfer_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/ijevo_button.dart';

class ReceiptModal extends ConsumerWidget {
  final TransactionModel transaction;

  const ReceiptModal({
    super.key,
    required this.transaction,
  });

  static void show(BuildContext context, TransactionModel tx) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ReceiptModal(transaction: tx),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currencyFormat = NumberFormat('#,##0.00');
    final formattedDate = DateFormat('MMM d, yyyy • h:mm a').format(transaction.createdAt);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const SizedBox(height: 12),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Transfer Receipt', style: AppTextStyles.h3),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceSecondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 18, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.borderLight),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Amount Pill
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '£${currencyFormat.format(transaction.sendAmount)}',
                      style: AppTextStyles.h1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${transaction.payoutCurrency} ${currencyFormat.format(transaction.payoutAmount)} delivered',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: AppTextStyles.bodySmall,
                    ),

                    const SizedBox(height: 24),

                    // Transfer Details Container
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildRow('Status', 'Delivered', valueColor: AppColors.primary, isBold: true),
                          const Divider(height: 20, color: AppColors.border),
                          _buildRow('Transfer Reference', transaction.referenceNumber),
                          const Divider(height: 20, color: AppColors.border),
                          _buildRow('Recipient', transaction.recipientName),
                          const Divider(height: 20, color: AppColors.border),
                          _buildRow('Destination', '${transaction.recipientInstitution} (${transaction.recipientAccount})'),
                          const Divider(height: 20, color: AppColors.border),
                          _buildRow('Exchange Rate', '1 GBP = ${transaction.exchangeRate.toStringAsFixed(2)} ${transaction.payoutCurrency}'),
                          const Divider(height: 20, color: AppColors.border),
                          _buildRow('Transfer Fee', 'FREE (£0.00)', valueColor: AppColors.primary, isBold: true),
                          const Divider(height: 20, color: AppColors.border),
                          _buildRow('Payment Method', transaction.paymentMethod),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Actions
                    IjevoButton(
                      text: 'Send Again',
                      onPressed: () {
                        Navigator.of(context).pop();
                        ref.read(transferProvider.notifier).setSendAmount(transaction.sendAmount);
                        context.push('/send/recipient');
                      },
                    ),
                    const SizedBox(height: 12),
                    IjevoButton(
                      text: 'Share / Download PDF Receipt',
                      isOutlined: true,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('PDF Receipt downloaded to device. 📄'),
                            backgroundColor: AppColors.navy,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? valueColor, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

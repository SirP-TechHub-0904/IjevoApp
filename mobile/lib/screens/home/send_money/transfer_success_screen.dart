import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../models/transaction_model.dart';
import '../../../providers/activity_provider.dart';
import '../../../providers/transfer_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/ijevo_button.dart';

class TransferSuccessScreen extends ConsumerStatefulWidget {
  const TransferSuccessScreen({super.key});

  @override
  ConsumerState<TransferSuccessScreen> createState() => _TransferSuccessScreenState();
}

class _TransferSuccessScreenState extends ConsumerState<TransferSuccessScreen> {
  late final TransactionModel _createdTx;

  @override
  void initState() {
    super.initState();
    final transfer = ref.read(transferProvider);
    final refNum = 'IJ-${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, '0')}-${(1000 + DateTime.now().millisecond)}';

    _createdTx = TransactionModel(
      id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
      referenceNumber: refNum,
      recipientName: transfer.selectedRecipient?.fullName ?? 'Recipient',
      recipientInstitution: transfer.selectedRecipient?.institutionName ?? 'Bank',
      recipientAccount: transfer.selectedRecipient?.accountNumber ?? '•••• 1234',
      countryCode: transfer.selectedCountry.code,
      sendAmount: transfer.sendAmount,
      sendCurrency: transfer.sendCurrency,
      payoutAmount: transfer.payoutAmount,
      payoutCurrency: transfer.selectedCountry.currencyCode,
      exchangeRate: transfer.rate,
      fee: transfer.fee,
      createdAt: DateTime.now(),
      status: TransactionStatus.delivered,
      paymentMethod: transfer.paymentMethod,
    );

    // Save transaction to activity state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activityProvider.notifier).addTransaction(_createdTx);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0.00');
    final payoutFormatted =
        '${_createdTx.payoutCurrency} ${currencyFormat.format(_createdTx.payoutAmount)}';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          context.go('/home');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                const Spacer(),

                // Animated Success Checkmark
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                Text('Transfer Sent!', style: AppTextStyles.h1),
                const SizedBox(height: 8),
                Text(
                  payoutFormatted,
                  style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  'to ${_createdTx.recipientName}',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),

                const SizedBox(height: 32),

                // Status Timeline Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildTimelineItem(
                        title: 'Transfer initiated',
                        time: DateFormat('h:mm a').format(_createdTx.createdAt),
                        isDone: true,
                        isLast: false,
                      ),
                      _buildTimelineItem(
                        title: 'Payment authorized via ${_createdTx.paymentMethod}',
                        time: DateFormat('h:mm a').format(_createdTx.createdAt),
                        isDone: true,
                        isLast: false,
                      ),
                      _buildTimelineItem(
                        title: 'Arriving in recipient bank account',
                        time: 'Within 5 minutes ⚡',
                        isDone: true,
                        isLast: true,
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Action Buttons
                IjevoButton(
                  text: 'Back to Home',
                  onPressed: () {
                    ref.read(transferProvider.notifier).reset();
                    context.go('/home');
                  },
                ),
                const SizedBox(height: 12),
                IjevoButton(
                  text: 'View Transfer Receipt',
                  isOutlined: true,
                  onPressed: () {
                    context.push('/activity');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String time,
    required bool isDone,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isDone ? AppColors.primary : AppColors.border,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 12, color: Colors.white),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 36,
                color: isDone ? AppColors.primary : AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              if (!isLast) const SizedBox(height: 14),
            ],
          ),
        ),
      ],
    );
  }
}

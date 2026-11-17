import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../models/transaction_model.dart';
import '../../providers/activity_provider.dart';
import '../../providers/transfer_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/flag_avatar.dart';
import 'receipt_modal.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activity = ref.watch(activityProvider);
    final transactions = activity.filteredTransactions;
    final recipients = activity.savedRecipients;
    final currencyFormat = NumberFormat('#,##0.00');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Activity', style: AppTextStyles.h2),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined, color: AppColors.textPrimary),
            onPressed: () => context.push('/activity/statement'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                ref.read(activityProvider.notifier).setSearchQuery(val);
              },
              decoration: const InputDecoration(
                hintText: 'Search transfers by name or reference...',
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
              ),
            ),
          ),

          // Horizontal Recent Recipients Carousel
          if (recipients.isNotEmpty) ...[
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: recipients.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return InkWell(
                      onTap: () => context.push('/send/recipient'),
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                            ),
                            child: const Icon(Icons.add, color: AppColors.primary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Send New',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final r = recipients[index - 1];
                  return InkWell(
                    onTap: () {
                      ref.read(transferProvider.notifier).selectRecipient(r);
                      context.push('/send/confirm');
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: const BoxDecoration(
                                color: AppColors.navy,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                r.displayInitials,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: FlagAvatar(countryCode: r.countryCode, size: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 64,
                          child: Text(
                            r.fullName.split(' ').first,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 24, color: AppColors.borderLight),
          ],

          // Transaction List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'PAST TRANSFERS',
                style: AppTextStyles.label.copyWith(fontSize: 11, letterSpacing: 0.8),
              ),
            ),
          ),

          Expanded(
            child: transactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.history, size: 54, color: AppColors.textMuted),
                        const SizedBox(height: 12),
                        Text('No transfers found', style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: transactions.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      indent: 72,
                      color: AppColors.borderLight,
                    ),
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      final isDelivered = tx.status == TransactionStatus.delivered ||
                          tx.status == TransactionStatus.succeeded;
                      final dateStr = DateFormat('MMM d').format(tx.createdAt);

                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        leading: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isDelivered ? AppColors.primaryLight : AppColors.surfaceSecondary,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            isDelivered ? Icons.arrow_outward : Icons.access_time,
                            color: isDelivered ? AppColors.primary : AppColors.warning,
                            size: 22,
                          ),
                        ),
                        title: Text(
                          tx.recipientName,
                          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '${tx.recipientInstitution} • $dateStr',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '-£${currencyFormat.format(tx.sendAmount)}',
                              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '+${tx.payoutCurrency} ${currencyFormat.format(tx.payoutAmount)}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        onTap: () => ReceiptModal.show(context, tx),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

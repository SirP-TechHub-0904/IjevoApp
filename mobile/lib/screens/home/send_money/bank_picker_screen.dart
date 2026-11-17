import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../providers/transfer_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/back_circle_button.dart';
import '../../../widgets/ijevo_button.dart';

class BankPickerScreen extends ConsumerStatefulWidget {
  const BankPickerScreen({super.key});

  @override
  ConsumerState<BankPickerScreen> createState() => _BankPickerScreenState();
}

class _BankPickerScreenState extends ConsumerState<BankPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<Map<String, String>> _ukBanks = [
    {'name': 'Lloyds Bank', 'logo': '🏦'},
    {'name': 'Barclays', 'logo': '🦅'},
    {'name': 'NatWest', 'logo': '🔺'},
    {'name': 'Monzo', 'logo': '🟠'},
    {'name': 'Revolut', 'logo': '⚡'},
    {'name': 'HSBC UK', 'logo': '🔴'},
    {'name': 'Santander UK', 'logo': '🔥'},
    {'name': 'Starling Bank', 'logo': '🔵'},
    {'name': 'Halifax', 'logo': '✖️'},
    {'name': 'Bank of Scotland', 'logo': '🏴󠁧󠁢󠁳󠁣󠁴󠁿'},
    {'name': 'TSB', 'logo': '🔷'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _authorizeWithBank(String bankName) {
    final transfer = ref.read(transferProvider);
    final currencyFormat = NumberFormat('#,##0.00');
    final amountFormatted = '£${currencyFormat.format(transfer.sendAmount)}';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_open, color: AppColors.primary, size: 32),
              ),
              const SizedBox(height: 16),
              Text(
                'Authorize payment via $bankName',
                textAlign: TextAlign.center,
                style: AppTextStyles.h2,
              ),
              const SizedBox(height: 8),
              Text(
                'You will approve a single instant payment of $amountFormatted directly within your $bankName banking app. No card details shared.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              IjevoButton(
                text: 'Approve in $bankName',
                onPressed: () {
                  Navigator.pop(ctx);
                  context.pushReplacement('/send/success');
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Cancel', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _ukBanks.where((b) {
      if (_query.isEmpty) return true;
      return b['name']!.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Select Your Bank', style: AppTextStyles.h3),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _query = val),
              decoration: const InputDecoration(
                hintText: 'Search UK banks...',
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(
                height: 1,
                indent: 68,
                color: AppColors.borderLight,
              ),
              itemBuilder: (context, index) {
                final bank = filtered[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      bank['logo']!,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                  title: Text(
                    bank['name']!,
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Instant Open Banking',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
                  onTap: () => _authorizeWithBank(bank['name']!),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

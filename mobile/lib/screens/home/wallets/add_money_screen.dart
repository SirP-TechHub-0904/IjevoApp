import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/notification_provider.dart';
import '../../../providers/wallet_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/back_circle_button.dart';
import '../../../widgets/ijevo_button.dart';

class AddMoneyScreen extends ConsumerStatefulWidget {
  final String walletId;

  const AddMoneyScreen({
    super.key,
    this.walletId = 'w_gbp',
  });

  @override
  ConsumerState<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends ConsumerState<AddMoneyScreen> {
  final TextEditingController _amountController = TextEditingController(text: '100');
  String _selectedMethod = 'Instant Bank Transfer';
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onAddMoney(String walletCurrencySymbol, String walletName) async {
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    if (amount <= 0) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    ref.read(walletProvider.notifier).addFunds(widget.walletId, amount);
    ref.read(notificationProvider.notifier).addNotification(
      title: 'Wallet Funded! 💳',
      message: '$walletCurrencySymbol${amount.toStringAsFixed(2)} was successfully added to your $walletName.',
      type: 'transfer',
      route: '/home',
    );

    setState(() => _isLoading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added $walletCurrencySymbol${amount.toStringAsFixed(2)} to $walletName!'),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);
    final wallet = walletState.wallets.firstWhere(
      (w) => w.id == widget.walletId,
      orElse: () => walletState.wallets.first,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Top Up ${wallet.currencyCode} Wallet', style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enter amount to add to ${wallet.currencyName}', style: AppTextStyles.label),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(wallet.currencySymbol, style: AppTextStyles.currencyValue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: AppTextStyles.currencyValue,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: '0.00',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Text('Select payment source', style: AppTextStyles.label),
            const SizedBox(height: 12),

            _buildMethodTile(
              title: 'Instant Bank Transfer',
              subtitle: 'Free • Connect via Open Banking',
              icon: Icons.account_balance,
            ),
            const SizedBox(height: 10),
            _buildMethodTile(
              title: 'Debit Card (•••• 9021)',
              subtitle: 'Free • Visa debit',
              icon: Icons.credit_card,
            ),

            const SizedBox(height: 32),
            IjevoButton(
              text: 'Top Up ${wallet.currencyCode} Now',
              isLoading: _isLoading,
              onPressed: () => _onAddMoney(wallet.currencySymbol, wallet.currencyName),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildMethodTile({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedMethod == title;
    return InkWell(
      onTap: () => setState(() => _selectedMethod = title),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.textPrimary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
          ],
        ),
      ),
    );
  }
}

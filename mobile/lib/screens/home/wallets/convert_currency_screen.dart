import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../providers/wallet_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/back_circle_button.dart';
import '../../../widgets/ijevo_button.dart';

class ConvertCurrencyScreen extends ConsumerStatefulWidget {
  const ConvertCurrencyScreen({super.key});

  @override
  ConsumerState<ConvertCurrencyScreen> createState() => _ConvertCurrencyScreenState();
}

class _ConvertCurrencyScreenState extends ConsumerState<ConvertCurrencyScreen> {
  final TextEditingController _amountController = TextEditingController(text: '50');
  double _amount = 50.0;
  final double _rate = 1840.0; // GBP to NGN
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _onConvert() async {
    final wallets = ref.read(walletProvider);
    final gbp = wallets.gbpWallet;
    if (gbp == null || gbp.balance < _amount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Insufficient GBP balance for this conversion.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));

    final success = ref.read(walletProvider.notifier).convertFunds(
          fromCurrency: 'GBP',
          toCurrency: 'NGN',
          fromAmount: _amount,
          rate: _rate,
        );

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully converted £${_amount.toStringAsFixed(2)} to NGN! 🎉'),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallets = ref.watch(walletProvider);
    final gbp = wallets.gbpWallet;
    final ngn = wallets.ngnWallet;
    final currencyFormat = NumberFormat('#,##0.00');
    final convertedAmount = _amount * _rate;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Convert Currency', style: AppTextStyles.h3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // From Currency Card
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('From', style: AppTextStyles.bodySmall),
                      Text(
                        'Balance: £${currencyFormat.format(gbp?.balance ?? 0)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSecondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Text('🇬🇧', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 6),
                            Text('GBP', style: AppTextStyles.h3),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          textAlign: TextAlign.end,
                          style: AppTextStyles.currencyValue,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: '0.00',
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (val) {
                            setState(() {
                              _amount = double.tryParse(val) ?? 0.0;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Swap Rate Badge in Center
            Transform.translate(
              offset: const Offset(0, 0),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sync_alt, color: AppColors.primary, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '1 GBP = ₦${currencyFormat.format(_rate)} NGN',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // To Currency Card
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('To', style: AppTextStyles.bodySmall),
                      Text(
                        'Balance: ₦${currencyFormat.format(ngn?.balance ?? 0)}',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSecondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Text('🇳🇬', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 6),
                            Text('NGN', style: AppTextStyles.h3),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          currencyFormat.format(convertedAmount),
                          textAlign: TextAlign.end,
                          style: AppTextStyles.currencyValue.copyWith(color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle_outline, size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  'Zero conversion fee • Guaranteed rate',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),

            const SizedBox(height: 32),
            IjevoButton(
              text: 'Convert £${_amount.toStringAsFixed(2)} to NGN',
              isLoading: _isLoading,
              onPressed: _amount > 0 ? _onConvert : null,
            ),
          ],
        ),
      ),
    );
  }
}

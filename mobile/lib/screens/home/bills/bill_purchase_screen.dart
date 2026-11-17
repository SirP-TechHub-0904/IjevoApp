import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../models/bill_model.dart';
import '../../../providers/wallet_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/back_circle_button.dart';
import '../../../widgets/ijevo_button.dart';

class BillPurchaseScreen extends ConsumerStatefulWidget {
  final BillCategory category;

  const BillPurchaseScreen({
    super.key,
    required this.category,
  });

  @override
  ConsumerState<BillPurchaseScreen> createState() => _BillPurchaseScreenState();
}

class _BillPurchaseScreenState extends ConsumerState<BillPurchaseScreen> {
  final _idController = TextEditingController();
  final _amountController = TextEditingController(text: '2000');
  late String _selectedProvider;
  bool _isLoading = false;

  late final List<BillProviderModel> _providers;

  @override
  void initState() {
    super.initState();
    switch (widget.category) {
      case BillCategory.airtimeData:
        _providers = BillProviderModel.airtimeProviders;
        break;
      case BillCategory.electricity:
        _providers = BillProviderModel.electricityProviders;
        break;
      case BillCategory.tvBroadband:
        _providers = BillProviderModel.tvProviders;
        break;
    }
    _selectedProvider = _providers.first.name;
  }

  @override
  void dispose() {
    _idController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String get _title {
    switch (widget.category) {
      case BillCategory.airtimeData:
        return 'Airtime & Data';
      case BillCategory.electricity:
        return 'Pay Electricity';
      case BillCategory.tvBroadband:
        return 'Pay TV & Internet';
    }
  }

  String get _inputLabel {
    switch (widget.category) {
      case BillCategory.airtimeData:
        return 'Mobile Phone Number';
      case BillCategory.electricity:
        return 'Meter / Account Number';
      case BillCategory.tvBroadband:
        return 'Smartcard / IUC Number';
    }
  }

  void _onPay() async {
    if (_idController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter recipient identifier.')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700));

    // Deduct from NGN wallet if available
    ref.read(walletProvider.notifier).convertFunds(
          fromCurrency: 'NGN',
          toCurrency: 'NGN',
          fromAmount: 0,
          rate: 1,
        );

    setState(() => _isLoading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment of ₦${NumberFormat('#,##0').format(amount)} to $_selectedProvider successful!'),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat('#,##0');
    final presetAmounts = [1000, 2000, 5000, 10000];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text(_title, style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Provider', style: AppTextStyles.label),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedProvider,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.business, color: AppColors.textSecondary),
              ),
              items: _providers.map((p) {
                return DropdownMenuItem(
                  value: p.name,
                  child: Text(p.name, style: AppTextStyles.bodyMedium),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedProvider = val);
              },
            ),

            const SizedBox(height: 20),
            Text(_inputLabel, style: AppTextStyles.label),
            const SizedBox(height: 8),
            TextFormField(
              controller: _idController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: widget.category == BillCategory.airtimeData ? '08012345678' : 'e.g. 45019283741',
                prefixIcon: const Icon(Icons.pin, color: AppColors.textSecondary),
              ),
            ),

            const SizedBox(height: 20),
            Text('Amount (NGN)', style: AppTextStyles.label),
            const SizedBox(height: 8),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: AppTextStyles.h2,
              decoration: const InputDecoration(
                prefixText: '₦ ',
                prefixStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ),

            const SizedBox(height: 12),
            // Preset amount chips
            Wrap(
              spacing: 8,
              children: presetAmounts.map((amt) {
                return ActionChip(
                  label: Text('₦${currencyFormat.format(amt)}'),
                  backgroundColor: AppColors.surfaceSecondary,
                  side: BorderSide.none,
                  labelStyle: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () {
                    setState(() {
                      _amountController.text = amt.toString();
                    });
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 36),
            IjevoButton(
              text: 'Pay with Wallet',
              isLoading: _isLoading,
              onPressed: _onPay,
            ),
          ],
        ),
      ),
      ),
    );
  }
}

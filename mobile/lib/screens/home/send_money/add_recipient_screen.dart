import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../models/recipient_model.dart';
import '../../../providers/activity_provider.dart';
import '../../../providers/transfer_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/back_circle_button.dart';
import '../../../widgets/ijevo_button.dart';

class AddRecipientScreen extends ConsumerStatefulWidget {
  const AddRecipientScreen({super.key});

  @override
  ConsumerState<AddRecipientScreen> createState() => _AddRecipientScreenState();
}

class _AddRecipientScreenState extends ConsumerState<AddRecipientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _accountController = TextEditingController();
  String _selectedBank = 'Access Bank';
  RecipientType _type = RecipientType.bankAccount;
  bool _isLoading = false;

  final List<String> _nigerianBanks = [
    'Access Bank',
    'Guaranty Trust Bank (GTBank)',
    'Zenith Bank',
    'United Bank for Africa (UBA)',
    'First Bank of Nigeria',
    'Kuda Microfinance Bank',
    'Moniepoint MFB',
    'OPay Digital Services',
    'PalmPay',
    'Stanbic IBTC Bank',
    'Sterling Bank',
    'Fidelity Bank',
    'Wema Bank / ALAT',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  void _onSaveRecipient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final country = ref.read(transferProvider).selectedCountry;
    final newRecipient = RecipientModel(
      id: 'rec_${DateTime.now().millisecondsSinceEpoch}',
      fullName: _nameController.text.trim(),
      countryCode: country.code,
      currencyCode: country.currencyCode,
      type: _type,
      institutionName: _selectedBank,
      accountNumber: _accountController.text.trim(),
    );

    ref.read(activityProvider.notifier).addRecipient(newRecipient);
    ref.read(transferProvider.notifier).selectRecipient(newRecipient);

    setState(() => _isLoading = false);
    if (mounted) {
      context.pushReplacement('/send/confirm');
    }
  }

  @override
  Widget build(BuildContext context) {
    final country = ref.watch(transferProvider).selectedCountry;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Add Recipient in ${country.name}', style: AppTextStyles.h3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Payout Method Selector Tabs
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _type = RecipientType.bankAccount),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _type == RecipientType.bankAccount ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: _type == RecipientType.bankAccount
                                ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Bank Account',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: _type == RecipientType.bankAccount ? FontWeight.w600 : FontWeight.w400,
                              color: _type == RecipientType.bankAccount ? AppColors.textPrimary : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() => _type = RecipientType.mobileMoney),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _type == RecipientType.mobileMoney ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: _type == RecipientType.mobileMoney
                                ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Mobile Money',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: _type == RecipientType.mobileMoney ? FontWeight.w600 : FontWeight.w400,
                              color: _type == RecipientType.mobileMoney ? AppColors.textPrimary : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Text('Select Institution / Bank', style: AppTextStyles.label),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedBank,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.account_balance_outlined, color: AppColors.textSecondary),
                ),
                items: _nigerianBanks.map((bank) {
                  return DropdownMenuItem(
                    value: bank,
                    child: Text(bank, style: AppTextStyles.bodyMedium),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedBank = val);
                },
              ),

              const SizedBox(height: 20),
              Text(
                _type == RecipientType.bankAccount ? 'Account Number (10 digits)' : 'Mobile Phone Number',
                style: AppTextStyles.label,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _accountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: _type == RecipientType.bankAccount ? '0123456789' : '+234 801 234 5678',
                  prefixIcon: Icon(
                    _type == RecipientType.bankAccount ? Icons.numbers : Icons.phone_android,
                    color: AppColors.textSecondary,
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please enter account number';
                  if (val.trim().length < 8) return 'Account number is too short';
                  return null;
                },
              ),

              const SizedBox(height: 20),
              Text('Recipient Full Legal Name', style: AppTextStyles.label),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'e.g. Babatunde Adeyemi',
                  prefixIcon: Icon(Icons.person_outline, color: AppColors.textSecondary),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please enter legal name';
                  return null;
                },
              ),

              const SizedBox(height: 32),
              IjevoButton(
                text: 'Save & Continue',
                isLoading: _isLoading,
                onPressed: _onSaveRecipient,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/wallet_model.dart';
import '../../../providers/notification_provider.dart';
import '../../../providers/wallet_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_text_styles.dart';
import '../../../widgets/back_circle_button.dart';
import '../../../widgets/flag_avatar.dart';

class AddWalletScreen extends ConsumerStatefulWidget {
  const AddWalletScreen({super.key});

  @override
  ConsumerState<AddWalletScreen> createState() => _AddWalletScreenState();
}

class _AddWalletScreenState extends ConsumerState<AddWalletScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<WalletModel> _availableWallets = const [
    WalletModel(id: 'w_eur', currencyCode: 'EUR', currencySymbol: '€', currencyName: 'Euro', countryCode: 'EU', balance: 0.0),
    WalletModel(id: 'w_usd', currencyCode: 'USD', currencySymbol: '\$', currencyName: 'US Dollar', countryCode: 'US', balance: 0.0),
    WalletModel(id: 'w_kes', currencyCode: 'KES', currencySymbol: 'KSh', currencyName: 'Kenyan Shilling', countryCode: 'KE', balance: 0.0),
    WalletModel(id: 'w_ugx', currencyCode: 'UGX', currencySymbol: 'USh', currencyName: 'Ugandan Shilling', countryCode: 'UG', balance: 0.0),
    WalletModel(id: 'w_tzs', currencyCode: 'TZS', currencySymbol: 'TSh', currencyName: 'Tanzanian Shilling', countryCode: 'TZ', balance: 0.0),
    WalletModel(id: 'w_xaf', currencyCode: 'XAF', currencySymbol: 'FCFA', currencyName: 'Central African Franc', countryCode: 'CM', balance: 0.0),
    WalletModel(id: 'w_xof', currencyCode: 'XOF', currencySymbol: 'CFA', currencyName: 'West African Franc', countryCode: 'SN', balance: 0.0),
    WalletModel(id: 'w_inr', currencyCode: 'INR', currencySymbol: '₹', currencyName: 'Indian Rupee', countryCode: 'IN', balance: 0.0),
    WalletModel(id: 'w_pkr', currencyCode: 'PKR', currencySymbol: '₨', currencyName: 'Pakistani Rupee', countryCode: 'PK', balance: 0.0),
    WalletModel(id: 'w_bdt', currencyCode: 'BDT', currencySymbol: '৳', currencyName: 'Bangladeshi Taka', countryCode: 'BD', balance: 0.0),
    WalletModel(id: 'w_php', currencyCode: 'PHP', currencySymbol: '₱', currencyName: 'Philippine Peso', countryCode: 'PH', balance: 0.0),
    WalletModel(id: 'w_brl', currencyCode: 'BRL', currencySymbol: 'R\$', currencyName: 'Brazilian Real', countryCode: 'BR', balance: 0.0),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final existingWallets = ref.watch(walletProvider).wallets;
    final existingCodes = existingWallets.map((w) => w.currencyCode).toSet();

    final filtered = _availableWallets.where((w) {
      if (existingCodes.contains(w.currencyCode)) return false;
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return w.currencyName.toLowerCase().contains(q) ||
          w.currencyCode.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: BackCircleButton(),
        ),
        title: Text('Choose a wallet to add', style: AppTextStyles.h3),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _query = val),
              decoration: const InputDecoration(
                hintText: 'Search currency or country...',
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
                final wallet = filtered[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: FlagAvatar(countryCode: wallet.countryCode, size: 40),
                  title: Text(
                    wallet.currencyName,
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    '${wallet.currencyCode} (${wallet.currencySymbol})',
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '+ Add',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  onTap: () {
                    ref.read(walletProvider.notifier).addNewWallet(wallet);
                    ref.read(notificationProvider.notifier).addNotification(
                      title: 'New Wallet Created! 🌍',
                      message: 'Your ${wallet.currencyName} (${wallet.currencyCode}) multi-currency wallet is now active.',
                      type: 'transfer',
                      route: '/home',
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${wallet.currencyName} (${wallet.currencyCode}) wallet added!'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

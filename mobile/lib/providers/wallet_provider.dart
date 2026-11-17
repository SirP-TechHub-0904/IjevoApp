import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/wallet_model.dart';

class WalletState {
  final List<WalletModel> wallets;
  final bool isLoading;

  const WalletState({
    required this.wallets,
    this.isLoading = false,
  });

  WalletModel? get gbpWallet => wallets.cast<WalletModel?>().firstWhere(
        (w) => w?.currencyCode == 'GBP',
        orElse: () => null,
      );

  WalletModel? get ngnWallet => wallets.cast<WalletModel?>().firstWhere(
        (w) => w?.currencyCode == 'NGN',
        orElse: () => null,
      );

  WalletState copyWith({
    List<WalletModel>? wallets,
    bool? isLoading,
  }) {
    return WalletState(
      wallets: wallets ?? this.wallets,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class WalletNotifier extends StateNotifier<WalletState> {
  WalletNotifier()
      : super(
          const WalletState(
            wallets: [
              WalletModel(
                id: 'w_gbp',
                currencyCode: 'GBP',
                currencySymbol: '£',
                currencyName: 'British Pound',
                countryCode: 'GB',
                balance: 345.50,
                isDefault: true,
              ),
              WalletModel(
                id: 'w_ngn',
                currencyCode: 'NGN',
                currencySymbol: '₦',
                currencyName: 'Nigerian Naira',
                countryCode: 'NG',
                balance: 420000.00,
                isDefault: false,
              ),
              WalletModel(
                id: 'w_ghs',
                currencyCode: 'GHS',
                currencySymbol: 'GH₵',
                currencyName: 'Ghanaian Cedi',
                countryCode: 'GH',
                balance: 0.00,
                isDefault: false,
              ),
            ],
          ),
        );

  void addFunds(String walletId, double amount) {
    state = state.copyWith(
      wallets: state.wallets.map((w) {
        if (w.id == walletId) {
          return w.copyWith(balance: w.balance + amount);
        }
        return w;
      }).toList(),
    );
  }

  bool convertFunds({
    required String fromCurrency,
    required String toCurrency,
    required double fromAmount,
    required double rate,
  }) {
    final fromWallet = state.wallets.firstWhere((w) => w.currencyCode == fromCurrency);
    if (fromWallet.balance < fromAmount) return false;

    final toAmount = fromAmount * rate;

    state = state.copyWith(
      wallets: state.wallets.map((w) {
        if (w.currencyCode == fromCurrency) {
          return w.copyWith(balance: w.balance - fromAmount);
        }
        if (w.currencyCode == toCurrency) {
          return w.copyWith(balance: w.balance + toAmount);
        }
        return w;
      }).toList(),
    );
    return true;
  }

  void addNewWallet(WalletModel newWallet) {
    if (!state.wallets.any((w) => w.currencyCode == newWallet.currencyCode)) {
      state = state.copyWith(wallets: [...state.wallets, newWallet]);
    }
  }
}

final walletProvider = StateNotifierProvider<WalletNotifier, WalletState>((ref) {
  return WalletNotifier();
});

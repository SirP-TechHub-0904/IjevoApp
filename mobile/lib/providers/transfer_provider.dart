import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/country_model.dart';
import '../models/recipient_model.dart';

class TransferState {
  final double sendAmount;
  final String sendCurrency;
  final CountryModel selectedCountry;
  final RecipientModel? selectedRecipient;
  final String? promoCode;
  final double discount;
  final String paymentMethod; // e.g. "Lloyds Bank PLC (•••• 5591)", "Visa Debit Card (•••• 9021)", "GBP Wallet"
  final String? paymentMethodSubtitle;
  final String? paymentMethodBadge;
  final String paymentMethodType; // 'bank', 'card', 'wallet', 'instant'

  const TransferState({
    required this.sendAmount,
    this.sendCurrency = 'GBP',
    required this.selectedCountry,
    this.selectedRecipient,
    this.promoCode,
    this.discount = 0.0,
    this.paymentMethod = 'GBP Wallet',
    this.paymentMethodSubtitle = 'Available balance: £345.50 • Instant debit',
    this.paymentMethodBadge = 'Active Wallet',
    this.paymentMethodType = 'wallet',
  });

  double get rate => selectedCountry.rateToGbp;
  double get payoutAmount => (sendAmount * rate);
  double get fee => 0.0; // Zero transfer fees!

  TransferState copyWith({
    double? sendAmount,
    String? sendCurrency,
    CountryModel? selectedCountry,
    RecipientModel? selectedRecipient,
    String? promoCode,
    double? discount,
    String? paymentMethod,
    String? paymentMethodSubtitle,
    String? paymentMethodBadge,
    String? paymentMethodType,
  }) {
    return TransferState(
      sendAmount: sendAmount ?? this.sendAmount,
      sendCurrency: sendCurrency ?? this.sendCurrency,
      selectedCountry: selectedCountry ?? this.selectedCountry,
      selectedRecipient: selectedRecipient ?? this.selectedRecipient,
      promoCode: promoCode ?? this.promoCode,
      discount: discount ?? this.discount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentMethodSubtitle: paymentMethodSubtitle ?? this.paymentMethodSubtitle,
      paymentMethodBadge: paymentMethodBadge ?? this.paymentMethodBadge,
      paymentMethodType: paymentMethodType ?? this.paymentMethodType,
    );
  }
}

class TransferNotifier extends StateNotifier<TransferState> {
  TransferNotifier()
      : super(
          TransferState(
            sendAmount: 100.0,
            selectedCountry: CountryModel.supportedCountries.first, // Nigeria by default
            selectedRecipient: RecipientModel.sampleRecipients.first,
          ),
        );

  void setSendAmount(double amount) {
    state = state.copyWith(sendAmount: amount);
  }

  void setPayoutAmount(double payoutAmount) {
    if (state.rate > 0) {
      state = state.copyWith(sendAmount: (payoutAmount / state.rate).roundToDouble());
    }
  }

  void selectCountry(CountryModel country) {
    state = state.copyWith(selectedCountry: country);
  }

  void selectRecipient(RecipientModel recipient) {
    state = state.copyWith(selectedRecipient: recipient);
  }

  void applyPromoCode(String code) {
    if (code.toUpperCase() == 'IJEVO5') {
      state = state.copyWith(promoCode: code.toUpperCase(), discount: 5.0);
    } else {
      state = state.copyWith(promoCode: code.toUpperCase(), discount: 2.0);
    }
  }

  void selectPaymentMethod(
    String method, {
    String? subtitle,
    String? badge,
    String? type,
  }) {
    state = state.copyWith(
      paymentMethod: method,
      paymentMethodSubtitle: subtitle,
      paymentMethodBadge: badge,
      paymentMethodType: type ?? 'bank',
    );
  }

  void reset() {
    state = TransferState(
      sendAmount: 100.0,
      selectedCountry: CountryModel.supportedCountries.first,
      selectedRecipient: RecipientModel.sampleRecipients.first,
    );
  }
}

final transferProvider = StateNotifierProvider<TransferNotifier, TransferState>((ref) {
  return TransferNotifier();
});

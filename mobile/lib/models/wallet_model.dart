class WalletModel {
  final String id;
  final String currencyCode;
  final String currencySymbol;
  final String currencyName;
  final String countryCode;
  final double balance;
  final bool isDefault;

  const WalletModel({
    required this.id,
    required this.currencyCode,
    required this.currencySymbol,
    required this.currencyName,
    required this.countryCode,
    required this.balance,
    this.isDefault = false,
  });

  WalletModel copyWith({
    String? id,
    String? currencyCode,
    String? currencySymbol,
    String? currencyName,
    String? countryCode,
    double? balance,
    bool? isDefault,
  }) {
    return WalletModel(
      id: id ?? this.id,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      currencyName: currencyName ?? this.currencyName,
      countryCode: countryCode ?? this.countryCode,
      balance: balance ?? this.balance,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

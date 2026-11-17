class CountryModel {
  final String code; // ISO 2-letter, e.g. 'NG', 'GH', 'KE'
  final String name;
  final String currencyCode; // 'NGN', 'GHS'
  final String currencySymbol; // '₦', 'GH₵'
  final double rateToGbp; // e.g. 1840.00
  final String flagEmoji;
  final bool isPopular;

  const CountryModel({
    required this.code,
    required this.name,
    required this.currencyCode,
    required this.currencySymbol,
    required this.rateToGbp,
    required this.flagEmoji,
    this.isPopular = false,
  });

  static const List<CountryModel> supportedCountries = [
    CountryModel(
      code: 'NG',
      name: 'Nigeria',
      currencyCode: 'NGN',
      currencySymbol: '₦',
      rateToGbp: 1840.00,
      flagEmoji: '🇳🇬',
      isPopular: true,
    ),
    CountryModel(
      code: 'GH',
      name: 'Ghana',
      currencyCode: 'GHS',
      currencySymbol: 'GH₵',
      rateToGbp: 19.80,
      flagEmoji: '🇬🇭',
      isPopular: true,
    ),
    CountryModel(
      code: 'KE',
      name: 'Kenya',
      currencyCode: 'KES',
      currencySymbol: 'KSh',
      rateToGbp: 168.50,
      flagEmoji: '🇰🇪',
      isPopular: true,
    ),
    CountryModel(
      code: 'UG',
      name: 'Uganda',
      currencyCode: 'UGX',
      currencySymbol: 'USh',
      rateToGbp: 4680.00,
      flagEmoji: '🇺🇬',
      isPopular: true,
    ),
    CountryModel(
      code: 'ZA',
      name: 'South Africa',
      currencyCode: 'ZAR',
      currencySymbol: 'R',
      rateToGbp: 22.90,
      flagEmoji: '🇿🇦',
    ),
    CountryModel(
      code: 'CM',
      name: 'Cameroon',
      currencyCode: 'XAF',
      currencySymbol: 'FCFA',
      rateToGbp: 785.00,
      flagEmoji: '🇨🇲',
    ),
    CountryModel(
      code: 'CI',
      name: 'Ivory Coast',
      currencyCode: 'XOF',
      currencySymbol: 'CFA',
      rateToGbp: 785.00,
      flagEmoji: '🇨🇮',
    ),
    CountryModel(
      code: 'SN',
      name: 'Senegal',
      currencyCode: 'XOF',
      currencySymbol: 'CFA',
      rateToGbp: 785.00,
      flagEmoji: '🇸🇳',
    ),
    CountryModel(
      code: 'BD',
      name: 'Bangladesh',
      currencyCode: 'BDT',
      currencySymbol: '৳',
      rateToGbp: 153.20,
      flagEmoji: '🇧🇩',
    ),
    CountryModel(
      code: 'PK',
      name: 'Pakistan',
      currencyCode: 'PKR',
      currencySymbol: '₨',
      rateToGbp: 355.00,
      flagEmoji: '🇵🇰',
    ),
    CountryModel(
      code: 'IN',
      name: 'India',
      currencyCode: 'INR',
      currencySymbol: '₹',
      rateToGbp: 107.50,
      flagEmoji: '🇮🇳',
    ),
  ];
}

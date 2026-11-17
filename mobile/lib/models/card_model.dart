class SavedCardModel {
  final String id;
  final String cardNumber; // e.g. "4532890123459021"
  final String cardholderName;
  final String expiryDate; // e.g. "09/28"
  final String brand; // "Visa", "Mastercard"
  final bool isDefault;

  const SavedCardModel({
    required this.id,
    required this.cardNumber,
    required this.cardholderName,
    required this.expiryDate,
    required this.brand,
    this.isDefault = false,
  });

  String get last4 {
    final cleaned = cardNumber.replaceAll(' ', '');
    return cleaned.length >= 4 ? cleaned.substring(cleaned.length - 4) : cleaned;
  }

  String get maskedNumber {
    return '•••• •••• •••• $last4';
  }

  static const List<SavedCardModel> initialCards = [
    SavedCardModel(
      id: 'card_1',
      cardNumber: '4532890123459021',
      cardholderName: 'IJEOMA UCHE',
      expiryDate: '09/28',
      brand: 'Visa',
      isDefault: true,
    ),
  ];
}

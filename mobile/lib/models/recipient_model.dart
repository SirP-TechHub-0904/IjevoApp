enum RecipientType { bankAccount, mobileMoney }

class RecipientModel {
  final String id;
  final String fullName;
  final String countryCode;
  final String currencyCode;
  final RecipientType type;
  final String institutionName; // e.g. "Access Bank", "MTN Mobile Money", "Kuda"
  final String accountNumber; // or phone number
  final String? routingCode; // Sort code or branch code
  final String? initials;

  const RecipientModel({
    required this.id,
    required this.fullName,
    required this.countryCode,
    required this.currencyCode,
    required this.type,
    required this.institutionName,
    required this.accountNumber,
    this.routingCode,
    this.initials,
  });

  String get displayInitials {
    if (initials != null && initials!.isNotEmpty) return initials!;
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '??';
  }

  static const List<RecipientModel> sampleRecipients = [
    RecipientModel(
      id: 'rec_1',
      fullName: 'Amina Bello',
      countryCode: 'NG',
      currencyCode: 'NGN',
      type: RecipientType.bankAccount,
      institutionName: 'Access Bank',
      accountNumber: '0123456789',
      initials: 'AB',
    ),
    RecipientModel(
      id: 'rec_2',
      fullName: 'Chidi Okafor',
      countryCode: 'NG',
      currencyCode: 'NGN',
      type: RecipientType.bankAccount,
      institutionName: 'GTBank',
      accountNumber: '0987654321',
      initials: 'CO',
    ),
    RecipientModel(
      id: 'rec_3',
      fullName: 'Kwame Mensah',
      countryCode: 'GH',
      currencyCode: 'GHS',
      type: RecipientType.mobileMoney,
      institutionName: 'MTN MoMo',
      accountNumber: '+233 24 123 4567',
      initials: 'KM',
    ),
    RecipientModel(
      id: 'rec_4',
      fullName: 'Zainab Danjuma',
      countryCode: 'NG',
      currencyCode: 'NGN',
      type: RecipientType.bankAccount,
      institutionName: 'Kuda Bank',
      accountNumber: '2001122334',
      initials: 'ZD',
    ),
  ];
}

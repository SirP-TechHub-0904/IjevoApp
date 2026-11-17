enum TransactionStatus { pending, delivered, succeeded, failed }

class TransactionModel {
  final String id;
  final String referenceNumber;
  final String recipientName;
  final String recipientInstitution;
  final String recipientAccount;
  final String countryCode;
  final double sendAmount;
  final String sendCurrency;
  final double payoutAmount;
  final String payoutCurrency;
  final double exchangeRate;
  final double fee;
  final DateTime createdAt;
  final TransactionStatus status;
  final String paymentMethod; // e.g. "Instant Bank Transfer", "Ijevo GBP Wallet"

  const TransactionModel({
    required this.id,
    required this.referenceNumber,
    required this.recipientName,
    required this.recipientInstitution,
    required this.recipientAccount,
    required this.countryCode,
    required this.sendAmount,
    required this.sendCurrency,
    required this.payoutAmount,
    required this.payoutCurrency,
    required this.exchangeRate,
    required this.fee,
    required this.createdAt,
    required this.status,
    required this.paymentMethod,
  });

  String get recipientInitials {
    final parts = recipientName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return recipientName.isNotEmpty ? recipientName[0].toUpperCase() : '??';
  }

  static List<TransactionModel> sampleTransactions = [
    TransactionModel(
      id: 'tx_101',
      referenceNumber: 'IJ-202611-9481',
      recipientName: 'Amina Bello',
      recipientInstitution: 'Access Bank',
      recipientAccount: '•••• 6789',
      countryCode: 'NG',
      sendAmount: 150.00,
      sendCurrency: 'GBP',
      payoutAmount: 276000.00,
      payoutCurrency: 'NGN',
      exchangeRate: 1840.00,
      fee: 0.00,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      status: TransactionStatus.delivered,
      paymentMethod: 'Instant Bank Transfer',
    ),
    TransactionModel(
      id: 'tx_102',
      referenceNumber: 'IJ-202611-8842',
      recipientName: 'Chidi Okafor',
      recipientInstitution: 'GTBank',
      recipientAccount: '•••• 4321',
      countryCode: 'NG',
      sendAmount: 50.00,
      sendCurrency: 'GBP',
      payoutAmount: 92000.00,
      payoutCurrency: 'NGN',
      exchangeRate: 1840.00,
      fee: 0.00,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
      status: TransactionStatus.succeeded,
      paymentMethod: 'Ijevo GBP Wallet',
    ),
    TransactionModel(
      id: 'tx_103',
      referenceNumber: 'IJ-202611-7391',
      recipientName: 'Kwame Mensah',
      recipientInstitution: 'MTN MoMo',
      recipientAccount: '•••• 4567',
      countryCode: 'GH',
      sendAmount: 100.00,
      sendCurrency: 'GBP',
      payoutAmount: 1980.00,
      payoutCurrency: 'GHS',
      exchangeRate: 19.80,
      fee: 0.00,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      status: TransactionStatus.succeeded,
      paymentMethod: 'Instant Bank Transfer',
    ),
    TransactionModel(
      id: 'tx_104',
      referenceNumber: 'IJ-202611-6204',
      recipientName: 'Zainab Danjuma',
      recipientInstitution: 'Kuda Bank',
      recipientAccount: '•••• 2334',
      countryCode: 'NG',
      sendAmount: 25.00,
      sendCurrency: 'GBP',
      payoutAmount: 46000.00,
      payoutCurrency: 'NGN',
      exchangeRate: 1840.00,
      fee: 0.00,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      status: TransactionStatus.delivered,
      paymentMethod: 'Debit Card (•••• 9021)',
    ),
  ];
}

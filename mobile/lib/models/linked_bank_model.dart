class LinkedBankModel {
  final String id;
  final String bankName;
  final String sortCode;
  final String accountNumber; // e.g. "•••• 5591"
  final bool isConnected;
  final bool isDefault;

  const LinkedBankModel({
    required this.id,
    required this.bankName,
    required this.sortCode,
    required this.accountNumber,
    this.isConnected = true,
    this.isDefault = false,
  });

  static const List<LinkedBankModel> initialBanks = [
    LinkedBankModel(
      id: 'bank_lloyds',
      bankName: 'Lloyds Bank PLC',
      sortCode: '30-94-81',
      accountNumber: '•••• 5591',
      isConnected: true,
      isDefault: true,
    ),
  ];
}

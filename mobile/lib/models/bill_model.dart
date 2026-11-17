enum BillCategory { airtimeData, electricity, tvBroadband }

class BillProviderModel {
  final String id;
  final String name;
  final BillCategory category;
  final String icon; // Asset or icon identifier
  final String countryCode;

  const BillProviderModel({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    this.countryCode = 'NG',
  });

  static const List<BillProviderModel> airtimeProviders = [
    BillProviderModel(id: 'mtn', name: 'MTN Nigeria', category: BillCategory.airtimeData, icon: 'mtn'),
    BillProviderModel(id: 'airtel', name: 'Airtel Nigeria', category: BillCategory.airtimeData, icon: 'airtel'),
    BillProviderModel(id: 'glo', name: 'Glo Nigeria', category: BillCategory.airtimeData, icon: 'glo'),
    BillProviderModel(id: '9mobile', name: '9mobile', category: BillCategory.airtimeData, icon: '9mobile'),
  ];

  static const List<BillProviderModel> electricityProviders = [
    BillProviderModel(id: 'ikedc', name: 'Ikeja Electric (IKEDC)', category: BillCategory.electricity, icon: 'ikedc'),
    BillProviderModel(id: 'ekedc', name: 'Eko Electric (EKEDC)', category: BillCategory.electricity, icon: 'ekedc'),
    BillProviderModel(id: 'aedc', name: 'Abuja Electricity (AEDC)', category: BillCategory.electricity, icon: 'aedc'),
    BillProviderModel(id: 'ibedc', name: 'Ibadan Electricity (IBEDC)', category: BillCategory.electricity, icon: 'ibedc'),
  ];

  static const List<BillProviderModel> tvProviders = [
    BillProviderModel(id: 'dstv', name: 'DStv Nigeria', category: BillCategory.tvBroadband, icon: 'dstv'),
    BillProviderModel(id: 'gotv', name: 'GOtv Nigeria', category: BillCategory.tvBroadband, icon: 'gotv'),
    BillProviderModel(id: 'startimes', name: 'StarTimes', category: BillCategory.tvBroadband, icon: 'startimes'),
    BillProviderModel(id: 'showmax', name: 'Showmax', category: BillCategory.tvBroadband, icon: 'showmax'),
  ];
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String type; // 'transfer', 'card', 'referral', 'security', 'rate'
  final String? route;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    required this.type,
    this.route,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    bool? isRead,
    String? type,
    String? route,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
      route: route ?? this.route,
    );
  }

  static List<AppNotification> sampleNotifications = [
    AppNotification(
      id: 'notif_1',
      title: 'Transfer Delivered!',
      message: '₦184,000.00 was successfully delivered to Amina Bello (Access Bank).',
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      isRead: false,
      type: 'transfer',
      route: '/activity',
    ),
    AppNotification(
      id: 'notif_2',
      title: '£20 Referral Reward Added!',
      message: 'Your friend Chidi completed their first transfer. £20.00 has been credited to your GBP wallet.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
      type: 'referral',
      route: '/referrals',
    ),
    AppNotification(
      id: 'notif_3',
      title: 'New Debit Card Linked',
      message: 'Your Visa Debit Card ending in •••• 9021 is verified and ready for instant transfers.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      type: 'card',
      route: '/send/payment-method',
    ),
    AppNotification(
      id: 'notif_4',
      title: 'Security Alert: Login from Android',
      message: 'Successful biometric sign-in detected from Redmi Note on 17 Nov at 13:05.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
      type: 'security',
      route: '/account/settings',
    ),
    AppNotification(
      id: 'notif_5',
      title: 'Rate Alert: GBP/NGN reaches ₦1,840',
      message: 'The GBP to NGN exchange rate increased today. Send money now with zero transfer fees.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
      type: 'rate',
      route: '/home',
    ),
  ];
}

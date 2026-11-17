import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';
import '../services/local_notification_service.dart';

class NotificationState {
  final List<AppNotification> items;

  const NotificationState({required this.items});

  int get unreadCount => items.where((n) => !n.isRead).length;
  List<AppNotification> get unreadItems => items.where((n) => !n.isRead).toList();
  List<AppNotification> get readItems => items.where((n) => n.isRead).toList();

  NotificationState copyWith({List<AppNotification>? items}) {
    return NotificationState(items: items ?? this.items);
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier()
      : super(NotificationState(items: AppNotification.sampleNotifications));

  void markAsRead(String id) {
    state = state.copyWith(
      items: state.items.map((n) {
        if (n.id == id) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList(),
    );
  }

  void markAllAsRead() {
    state = state.copyWith(
      items: state.items.map((n) => n.copyWith(isRead: true)).toList(),
    );
  }

  void toggleRead(String id) {
    state = state.copyWith(
      items: state.items.map((n) {
        if (n.id == id) {
          return n.copyWith(isRead: !n.isRead);
        }
        return n;
      }).toList(),
    );
  }

  void addNotification({
    required String title,
    required String message,
    required String type,
    String? route,
  }) {
    final newNotif = AppNotification(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      message: message,
      timestamp: DateTime.now(),
      isRead: false,
      type: type,
      route: route,
    );
    state = state.copyWith(items: [newNotif, ...state.items]);

    // Also fire real phone notification banner with sound and vibration
    LocalNotificationService().showNotification(
      title: title,
      body: message,
      payload: route,
    );
  }

  void deleteNotification(String id) {
    state = state.copyWith(
      items: state.items.where((n) => n.id != id).toList(),
    );
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier();
});

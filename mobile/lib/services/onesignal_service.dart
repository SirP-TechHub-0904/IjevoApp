import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../router/app_router.dart';

/// Centralized OneSignal Service Wrapper
/// Isolates all direct OneSignal SDK calls per integration guidelines.
class OneSignalService {
  static final OneSignalService _instance = OneSignalService._internal();
  factory OneSignalService() => _instance;
  OneSignalService._internal();

  static const String appId = 'c2867478-2d11-4b24-b213-2ec0e81ba02b';

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  void initialize([String? customAppId]) {
    if (_isInitialized) return;

    final targetAppId = customAppId ?? appId;

    // Set log level for debugging (remove in production)
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    // Initialize OneSignal
    OneSignal.initialize(targetAppId);
    _isInitialized = true;
    debugPrint('OneSignal initialized with App ID: $targetAppId');
  }

  void login(String externalId) {
    OneSignal.login(externalId);
  }

  void logout() {
    OneSignal.logout();
  }

  void setEmail(String email) {
    OneSignal.User.addEmail(email);
  }

  void setSmsNumber(String number) {
    OneSignal.User.addSms(number);
  }

  void setTag(String key, String value) {
    OneSignal.User.addTagWithKey(key, value);
  }

  Future<bool> requestPermission() async {
    return await OneSignal.Notifications.requestPermission(true);
  }

  void setLogLevel(OSLogLevel level) {
    OneSignal.Debug.setLogLevel(level);
  }

  void setNotificationClickListener(void Function(OSNotificationClickEvent) handler) {
    OneSignal.Notifications.addClickListener(handler);
  }

  void setNotificationForegroundListener(void Function(OSNotificationWillDisplayEvent) handler) {
    OneSignal.Notifications.addForegroundWillDisplayListener(handler);
  }

  String? get pushSubscriptionId => OneSignal.User.pushSubscription.id;

  void addPushSubscriptionObserver(void Function(OSPushSubscriptionChangedState) observer) {
    OneSignal.User.pushSubscription.addObserver(observer);
  }
}

// ---------------------------------------------------------------------------
// Push Subscription Verification Scaffolding
// ---------------------------------------------------------------------------

bool _dialogShown = false;

/// A real, server-assigned subscription ID is non-empty and not the local- placeholder
bool isRegisteredSubscription(String? id) =>
    id != null && id.isNotEmpty && !id.startsWith('local-');

void maybeShowIntegrationCompleteDialog([BuildContext? context, String? subscriptionId]) {
  if (isRegisteredSubscription(subscriptionId) && !_dialogShown) {
    _dialogShown = true;
    // Wait for the next microtask/frame to ensure Navigator is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showIntegrationCompleteDialog(context);
    });
  }
}

void setupPushSubscriptionObserver([BuildContext? context]) {
  final service = OneSignalService();
  service.addPushSubscriptionObserver((state) {
    maybeShowIntegrationCompleteDialog(context, state.current.id);
  });

  // Evaluate current value immediately in case assigned before observer attached
  maybeShowIntegrationCompleteDialog(context, service.pushSubscriptionId);
}

void showIntegrationCompleteDialog([BuildContext? context]) {
  final targetContext = context ?? rootNavigatorKey.currentContext;
  if (targetContext == null) return;

  showDialog(
    context: targetContext,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: const Text('Your OneSignal SDK integration is complete!'),
      content: const Text(
        'You can now send Push Notifications & In-App Messages through OneSignal. Tap below to enable push notifications.',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(ctx);
            OneSignalService().requestPermission();
          },
          child: const Text('Got it'),
        ),
      ],
    ),
  );
}

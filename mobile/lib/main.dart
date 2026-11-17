import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';
import 'services/local_notification_service.dart';
import 'services/onesignal_service.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';
import 'widgets/app_lifecycle_lock_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistent device storage
  await StorageService.init();

  // Initialize OneSignal SDK before runApp() per integration requirements
  OneSignalService().initialize();
  await LocalNotificationService().init();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  runApp(
    const ProviderScope(
      child: IjevoMobileApp(),
    ),
  );
}

class IjevoMobileApp extends ConsumerWidget {
  const IjevoMobileApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Ijevo Remit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      builder: (context, child) {
        return AppLifecycleLockWrapper(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

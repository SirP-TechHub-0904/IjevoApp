import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/bill_model.dart';
import '../services/storage_service.dart';
import '../screens/account/account_screen.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/account/help_center_screen.dart';
import '../screens/account/legal_screen.dart';
import '../screens/account/legal_webview_screen.dart';
import '../screens/account/payment_methods_manage_screen.dart';
import '../screens/account/personal_details_screen.dart';
import '../screens/account/recipients_manage_screen.dart';
import '../screens/account/settings_screen.dart';
import '../screens/activity/activity_screen.dart';
import '../screens/activity/download_statement_screen.dart';
import '../screens/auth/change_password_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/onboarding_screen.dart';
import '../screens/auth/reset_password_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/verify_email_screen.dart';
import '../screens/cards/cards_hub_screen.dart';
import '../screens/home/bills/bill_purchase_screen.dart';
import '../screens/home/bills/bills_hub_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/send_money/add_recipient_screen.dart';
import '../screens/home/send_money/bank_picker_screen.dart';
import '../screens/home/send_money/choose_country_screen.dart';
import '../screens/home/send_money/choose_recipient_screen.dart';
import '../screens/home/send_money/confirm_transfer_screen.dart';
import '../screens/home/send_money/link_card_screen.dart';
import '../screens/home/send_money/payment_method_screen.dart';
import '../screens/home/send_money/transfer_success_screen.dart';
import '../screens/home/wallets/add_money_screen.dart';
import '../screens/home/wallets/add_wallet_screen.dart';
import '../screens/home/wallets/convert_currency_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/referrals/referrals_screen.dart';
import '../screens/shell/main_shell_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _rootNavigatorKey = rootNavigatorKey;
final GlobalKey<NavigatorState> _shellNavigatorHome = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorActivity = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorReferrals = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorAccount = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/splash',
  redirect: (context, state) {
    final path = state.uri.path;

    // Allow splash screen to display on launch
    if (path == '/splash') return null;

    final hasSeen = StorageService.hasSeenOnboarding;
    final isLoggedIn = StorageService.isLoggedIn;

    final isAuthRoute = path == '/onboarding' ||
        path == '/login' ||
        path == '/signup' ||
        path == '/verify-email' ||
        path == '/forgot-password' ||
        path == '/reset-password';

    // 1. First-time launcher: force onboarding
    if (!hasSeen) {
      if (!isAuthRoute) return '/onboarding';
      return null;
    }

    // 2. Not logged in: prevent entering main app
    if (!isLoggedIn) {
      if (!isAuthRoute) return '/login';
      return null;
    }

    // 3. Already logged in: navigating back to login or onboarding pushes to home
    if (isLoggedIn && (path == '/login' || path == '/onboarding')) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) {
        final email = state.extra as String? ?? 'ijeoma.uche@example.com';
        return VerifyEmailScreen(email: email);
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/reset-password',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        final target = extra['target'] as String? ?? 'your email/phone';
        return ResetPasswordScreen(target: target);
      },
    ),
    GoRoute(
      path: '/change-password',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: '/account/change-password',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ChangePasswordScreen(),
    ),

    // Stateful Nested Shell for 4 Bottom Tabs
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellScreen(navigationShell: navigationShell);
      },
      branches: [
        // Tab 1: Home
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHome,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // Tab 2: Activity
        StatefulShellBranch(
          navigatorKey: _shellNavigatorActivity,
          routes: [
            GoRoute(
              path: '/activity',
              builder: (context, state) => const ActivityScreen(),
            ),
          ],
        ),

        // Tab 3: Referrals
        StatefulShellBranch(
          navigatorKey: _shellNavigatorReferrals,
          routes: [
            GoRoute(
              path: '/referrals',
              builder: (context, state) => const ReferralsScreen(),
            ),
          ],
        ),

        // Tab 4: Account
        StatefulShellBranch(
          navigatorKey: _shellNavigatorAccount,
          routes: [
            GoRoute(
              path: '/account',
              builder: (context, state) => const AccountScreen(),
            ),
          ],
        ),
      ],
    ),

    // Send Money Flow Sub-routes
    GoRoute(
      path: '/send/country',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ChooseCountryScreen(),
    ),
    GoRoute(
      path: '/send/recipient',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ChooseRecipientScreen(),
    ),
    GoRoute(
      path: '/send/add-recipient',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AddRecipientScreen(),
    ),
    GoRoute(
      path: '/send/confirm',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ConfirmTransferScreen(),
    ),
    GoRoute(
      path: '/send/payment-method',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PaymentMethodScreen(),
    ),
    GoRoute(
      path: '/send/link-card',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LinkCardScreen(),
    ),
    GoRoute(
      path: '/send/bank-picker',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const BankPickerScreen(),
    ),
    GoRoute(
      path: '/send/success',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TransferSuccessScreen(),
    ),
    GoRoute(
      path: '/activity/statement',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const DownloadStatementScreen(),
    ),

    // Wallets Sub-routes
    GoRoute(
      path: '/wallets/convert',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ConvertCurrencyScreen(),
    ),
    GoRoute(
      path: '/wallets/add-money',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final walletId = state.extra is String ? state.extra as String : 'w_gbp';
        return AddMoneyScreen(walletId: walletId);
      },
    ),
    GoRoute(
      path: '/wallets/add-wallet',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const AddWalletScreen(),
    ),

    // Bills Sub-routes
    GoRoute(
      path: '/bills',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const BillsHubScreen(),
    ),
    GoRoute(
      path: '/bills/purchase',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final category = state.extra as BillCategory? ?? BillCategory.airtimeData;
        return BillPurchaseScreen(category: category);
      },
    ),

    // Cards Hub Sub-route
    GoRoute(
      path: '/cards',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const CardsHubScreen(),
    ),

    // Account Sub-routes
    GoRoute(
      path: '/account/personal-details',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PersonalDetailsScreen(),
    ),
    GoRoute(
      path: '/account/recipients',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RecipientsManageScreen(),
    ),
    GoRoute(
      path: '/account/payment-methods',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PaymentMethodsManageScreen(),
    ),
    GoRoute(
      path: '/account/settings',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/account/help',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const HelpCenterScreen(),
    ),
    GoRoute(
      path: '/account/legal',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LegalScreen(),
    ),
    GoRoute(
      path: '/notifications',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/account/legal/view',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, String>? ?? {};
        final title = extra['title'] ?? 'Legal Document';
        final slug = extra['slug'] ?? 'terms';
        return LegalWebViewScreen(title: title, slug: slug);
      },
    ),
  ],
);

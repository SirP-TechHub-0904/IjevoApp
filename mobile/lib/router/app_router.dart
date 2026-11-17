import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/bill_model.dart';
import '../screens/account/account_screen.dart';
import '../screens/account/help_center_screen.dart';
import '../screens/account/legal_screen.dart';
import '../screens/account/payment_methods_manage_screen.dart';
import '../screens/account/personal_details_screen.dart';
import '../screens/account/recipients_manage_screen.dart';
import '../screens/account/settings_screen.dart';
import '../screens/activity/activity_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/cards/cards_hub_screen.dart';
import '../screens/home/bills/bill_purchase_screen.dart';
import '../screens/home/bills/bills_hub_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/home/send_money/add_recipient_screen.dart';
import '../screens/home/send_money/bank_picker_screen.dart';
import '../screens/home/send_money/choose_country_screen.dart';
import '../screens/home/send_money/choose_recipient_screen.dart';
import '../screens/home/send_money/confirm_transfer_screen.dart';
import '../screens/home/send_money/payment_method_screen.dart';
import '../screens/home/send_money/transfer_success_screen.dart';
import '../screens/home/wallets/add_money_screen.dart';
import '../screens/home/wallets/add_wallet_screen.dart';
import '../screens/home/wallets/convert_currency_screen.dart';
import '../screens/referrals/referrals_screen.dart';
import '../screens/shell/main_shell_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorHome = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorActivity = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorReferrals = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorAccount = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
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
      path: '/send/bank-picker',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const BankPickerScreen(),
    ),
    GoRoute(
      path: '/send/success',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const TransferSuccessScreen(),
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
      builder: (context, state) => const AddMoneyScreen(),
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
  ],
);

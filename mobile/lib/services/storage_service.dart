import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static const String _keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyBiometricsEnabled = 'biometrics_enabled';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyAutoLockTimeout = 'auto_lock_timeout';
  static const String _keyLastActiveTimestamp = 'last_active_timestamp';
  static const String _keyUserFullName = 'user_full_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyUserPassword = 'user_password';
  static const String _keyHasPromptedPostSignup = 'has_prompted_post_signup';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('StorageService must be initialized before use.');
    }
    return _prefs!;
  }

  // -------------------------------------------------------------
  // Onboarding & Auth State
  // -------------------------------------------------------------
  static bool get hasSeenOnboarding => _prefs?.getBool(_keyHasSeenOnboarding) ?? false;
  static Future<void> setHasSeenOnboarding(bool val) async {
    await _prefs?.setBool(_keyHasSeenOnboarding, val);
  }

  static bool get isLoggedIn => hasSeenOnboarding && (_prefs?.getBool(_keyIsLoggedIn) ?? false);
  static Future<void> setIsLoggedIn(bool val) async {
    await _prefs?.setBool(_keyIsLoggedIn, val);
  }

  // -------------------------------------------------------------
  // Security & Biometrics
  // -------------------------------------------------------------
  static bool get biometricsEnabled => _prefs?.getBool(_keyBiometricsEnabled) ?? false;
  static Future<void> setBiometricsEnabled(bool val) async {
    await _prefs?.setBool(_keyBiometricsEnabled, val);
  }

  // -------------------------------------------------------------
  // Notifications
  // -------------------------------------------------------------
  static bool get notificationsEnabled => _prefs?.getBool(_keyNotificationsEnabled) ?? false;
  static Future<void> setNotificationsEnabled(bool val) async {
    await _prefs?.setBool(_keyNotificationsEnabled, val);
  }

  static bool get hasPromptedPostSignup => _prefs?.getBool(_keyHasPromptedPostSignup) ?? false;
  static Future<void> setHasPromptedPostSignup(bool val) async {
    await _prefs?.setBool(_keyHasPromptedPostSignup, val);
  }

  // -------------------------------------------------------------
  // Auto-Lock Timeout Preference
  // Values: 'immediately', '15_minutes', '1_hour', '1_day', '7_days'
  // -------------------------------------------------------------
  static String get autoLockTimeout => _prefs?.getString(_keyAutoLockTimeout) ?? 'immediately';
  static Future<void> setAutoLockTimeout(String val) async {
    await _prefs?.setString(_keyAutoLockTimeout, val);
  }

  // -------------------------------------------------------------
  // Last Active Timestamp (Epoch ms)
  // -------------------------------------------------------------
  static int get lastActiveTimestamp => _prefs?.getInt(_keyLastActiveTimestamp) ?? 0;
  static Future<void> setLastActiveTimestamp(int val) async {
    await _prefs?.setInt(_keyLastActiveTimestamp, val);
  }

  // -------------------------------------------------------------
  // User Profile Caching
  // -------------------------------------------------------------
  static String get userFullName => _prefs?.getString(_keyUserFullName) ?? 'Ijeoma Uche';
  static Future<void> setUserFullName(String val) async {
    await _prefs?.setString(_keyUserFullName, val);
  }

  static String get userEmail => _prefs?.getString(_keyUserEmail) ?? 'ijeoma.uche@example.com';
  static Future<void> setUserEmail(String val) async {
    await _prefs?.setString(_keyUserEmail, val);
  }

  static String get userPhone => _prefs?.getString(_keyUserPhone) ?? '+44 7911 123456';
  static Future<void> setUserPhone(String val) async {
    await _prefs?.setString(_keyUserPhone, val);
  }

  static String get userPassword => _prefs?.getString(_keyUserPassword) ?? 'SecretPass123!';
  static Future<void> setUserPassword(String val) async {
    await _prefs?.setString(_keyUserPassword, val);
  }

  // -------------------------------------------------------------
  // Clear Session (Logout)
  // -------------------------------------------------------------
  static Future<void> clearSession() async {
    await _prefs?.setBool(_keyIsLoggedIn, false);
    await _prefs?.remove(_keyLastActiveTimestamp);
  }

  // -------------------------------------------------------------
  // Reset Everything (Simulate Fresh Install / Clear Data)
  // -------------------------------------------------------------
  static Future<void> resetAll() async {
    await _prefs?.clear();
  }
}

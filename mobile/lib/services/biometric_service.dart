import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> canCheckBiometrics() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return canCheck || isDeviceSupported;
    } catch (e) {
      debugPrint('Biometric canCheck error: $e');
      return false;
    }
  }

  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('Biometric getAvailable error: $e');
      return [];
    }
  }

  static Future<bool> authenticate({
    String reason = 'Scan your fingerprint or Face ID to unlock Ijevo',
  }) async {
    try {
      final authenticated = await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true, // Strictly physical biometrics only (no device lock PIN / Pattern)
          useErrorDialogs: true,
        ),
      );
      return authenticated;
    } catch (e) {
      debugPrint('Biometric authentication error: $e');
      return false;
    }
  }
}

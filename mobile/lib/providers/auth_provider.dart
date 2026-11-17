import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

class UserProfile {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;
  final String address;
  final String city;
  final String postcode;
  final String country;
  final String referralCode;
  final double referralEarnings;
  final bool biometricsEnabled;
  final bool pushNotifications;
  final bool smsNotifications;
  final bool whatsappNotifications;
  final bool emailNotifications;

  // Persistent Auth & Onboarding State
  final bool hasSeenOnboarding;
  final bool isLoggedIn;
  final String autoLockTimeout; // 'immediately', '15_minutes', '1_hour', '1_day', '7_days'

  // Avatar / Picture customizations
  final String avatarType; // 'initials', 'icon', 'photo'
  final String avatarIconName; // 'person', 'shield', 'diamond', 'rocket', etc.
  final int avatarBgColor; // color value, e.g. 0xFF0B192C
  final String? avatarPhotoPath;

  // Verification & Compliance reviews
  final String? pendingNameChange;
  final String? nameChangeDocType;
  final String? nameChangeStatus; // null or 'Under Review'

  final String? pendingDobChange;
  final String? dobChangeDocType;
  final String? dobChangeStatus; // null or 'Under Review'

  final String? pendingAddressChange;
  final String? addressChangeStatus;

  const UserProfile({
    this.fullName = 'Ijeoma Uche',
    this.email = 'ijeoma.uche@example.com',
    this.phoneNumber = '+44 7911 123456',
    this.dateOfBirth = '14/05/1992',
    this.address = '42 Highfield Road',
    this.city = 'London',
    this.postcode = 'E14 9GE',
    this.country = 'United Kingdom',
    this.referralCode = 'IJEOMA20',
    this.referralEarnings = 60.00,
    this.biometricsEnabled = false,
    this.pushNotifications = false,
    this.smsNotifications = true,
    this.whatsappNotifications = false,
    this.emailNotifications = true,
    this.hasSeenOnboarding = false,
    this.isLoggedIn = false,
    this.autoLockTimeout = 'immediately',
    this.avatarType = 'initials',
    this.avatarIconName = 'person',
    this.avatarBgColor = 0xFF0B192C,
    this.avatarPhotoPath,
    this.pendingNameChange,
    this.nameChangeDocType,
    this.nameChangeStatus,
    this.pendingDobChange,
    this.dobChangeDocType,
    this.dobChangeStatus,
    this.pendingAddressChange,
    this.addressChangeStatus,
  });

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : 'IU';
  }

  UserProfile copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? dateOfBirth,
    String? address,
    String? city,
    String? postcode,
    String? country,
    String? referralCode,
    double? referralEarnings,
    bool? biometricsEnabled,
    bool? pushNotifications,
    bool? smsNotifications,
    bool? whatsappNotifications,
    bool? emailNotifications,
    bool? hasSeenOnboarding,
    bool? isLoggedIn,
    String? autoLockTimeout,
    String? avatarType,
    String? avatarIconName,
    int? avatarBgColor,
    String? avatarPhotoPath,
    String? pendingNameChange,
    String? nameChangeDocType,
    String? nameChangeStatus,
    String? pendingDobChange,
    String? dobChangeDocType,
    String? dobChangeStatus,
    String? pendingAddressChange,
    String? addressChangeStatus,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      address: address ?? this.address,
      city: city ?? this.city,
      postcode: postcode ?? this.postcode,
      country: country ?? this.country,
      referralCode: referralCode ?? this.referralCode,
      referralEarnings: referralEarnings ?? this.referralEarnings,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      whatsappNotifications: whatsappNotifications ?? this.whatsappNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      autoLockTimeout: autoLockTimeout ?? this.autoLockTimeout,
      avatarType: avatarType ?? this.avatarType,
      avatarIconName: avatarIconName ?? this.avatarIconName,
      avatarBgColor: avatarBgColor ?? this.avatarBgColor,
      avatarPhotoPath: avatarPhotoPath ?? this.avatarPhotoPath,
      pendingNameChange: pendingNameChange ?? this.pendingNameChange,
      nameChangeDocType: nameChangeDocType ?? this.nameChangeDocType,
      nameChangeStatus: nameChangeStatus ?? this.nameChangeStatus,
      pendingDobChange: pendingDobChange ?? this.pendingDobChange,
      dobChangeDocType: dobChangeDocType ?? this.dobChangeDocType,
      dobChangeStatus: dobChangeStatus ?? this.dobChangeStatus,
      pendingAddressChange: pendingAddressChange ?? this.pendingAddressChange,
      addressChangeStatus: addressChangeStatus ?? this.addressChangeStatus,
    );
  }
}

class AuthNotifier extends StateNotifier<UserProfile> {
  AuthNotifier()
      : super(
          UserProfile(
            fullName: StorageService.userFullName,
            email: StorageService.userEmail,
            phoneNumber: StorageService.userPhone,
            biometricsEnabled: StorageService.biometricsEnabled,
            pushNotifications: StorageService.notificationsEnabled,
            autoLockTimeout: StorageService.autoLockTimeout,
            hasSeenOnboarding: StorageService.hasSeenOnboarding,
            isLoggedIn: StorageService.isLoggedIn,
          ),
        );

  // -------------------------------------------------------------
  // Onboarding & Authentication Lifecycle
  // -------------------------------------------------------------
  Future<void> completeOnboarding() async {
    await StorageService.setHasSeenOnboarding(true);
    state = state.copyWith(hasSeenOnboarding: true);
  }

  Future<void> login({String? email, String? password}) async {
    await StorageService.setIsLoggedIn(true);
    await StorageService.setLastActiveTimestamp(DateTime.now().millisecondsSinceEpoch);
    state = state.copyWith(
      isLoggedIn: true,
      email: email ?? StorageService.userEmail,
      fullName: StorageService.userFullName,
      phoneNumber: StorageService.userPhone,
    );
  }

  Future<void> signup({
    required String name,
    required String email,
    required String phone,
  }) async {
    await StorageService.setUserFullName(name);
    await StorageService.setUserEmail(email);
    await StorageService.setUserPhone(phone);
    await StorageService.setHasSeenOnboarding(true);
    await StorageService.setIsLoggedIn(true);
    await StorageService.setLastActiveTimestamp(DateTime.now().millisecondsSinceEpoch);

    state = state.copyWith(
      fullName: name,
      email: email,
      phoneNumber: phone,
      hasSeenOnboarding: true,
      isLoggedIn: true,
    );
  }

  Future<void> logout() async {
    await StorageService.clearSession();
    state = state.copyWith(isLoggedIn: false);
  }

  Future<void> resetAllForTesting() async {
    await StorageService.resetAll();
    state = const UserProfile(
      hasSeenOnboarding: false,
      isLoggedIn: false,
    );
  }

  // -------------------------------------------------------------
  // Auto-Lock & Session Timing
  // -------------------------------------------------------------
  Future<void> setAutoLockTimeout(String val) async {
    await StorageService.setAutoLockTimeout(val);
    state = state.copyWith(autoLockTimeout: val);
  }

  bool isLockExpired() {
    final timeout = state.autoLockTimeout;
    final lastActive = StorageService.lastActiveTimestamp;
    if (lastActive == 0) return timeout == 'immediately';

    final elapsedMs = DateTime.now().millisecondsSinceEpoch - lastActive;

    switch (timeout) {
      case 'immediately':
        return true;
      case '15_minutes':
        return elapsedMs >= 15 * 60 * 1000;
      case '1_hour':
        return elapsedMs >= 60 * 60 * 1000;
      case '1_day':
        return elapsedMs >= 24 * 60 * 60 * 1000;
      case '7_days':
        return elapsedMs >= 7 * 24 * 60 * 60 * 1000;
      default:
        return true;
    }
  }

  void recordActiveTime() {
    StorageService.setLastActiveTimestamp(DateTime.now().millisecondsSinceEpoch);
  }

  // -------------------------------------------------------------
  // Settings & Toggles
  // -------------------------------------------------------------
  void toggleBiometrics(bool val) {
    StorageService.setBiometricsEnabled(val);
    state = state.copyWith(biometricsEnabled: val);
  }

  void togglePush(bool val) {
    StorageService.setNotificationsEnabled(val);
    state = state.copyWith(pushNotifications: val);
  }

  void toggleSms(bool val) {
    state = state.copyWith(smsNotifications: val);
  }

  void toggleWhatsapp(bool val) {
    state = state.copyWith(whatsappNotifications: val);
  }

  void toggleEmail(bool val) {
    state = state.copyWith(emailNotifications: val);
  }

  // -------------------------------------------------------------
  // Avatar & Profile
  // -------------------------------------------------------------
  void setAvatarIcon({required String iconName, required int bgColor}) {
    state = state.copyWith(
      avatarType: 'icon',
      avatarIconName: iconName,
      avatarBgColor: bgColor,
      avatarPhotoPath: null,
    );
  }

  void setAvatarPhoto(String path) {
    state = state.copyWith(
      avatarType: 'photo',
      avatarPhotoPath: path,
    );
  }

  void resetAvatar() {
    state = state.copyWith(
      avatarType: 'initials',
      avatarBgColor: 0xFF0B192C,
      avatarPhotoPath: null,
    );
  }

  void requestNameChange({
    required String newName,
    required String documentType,
  }) {
    state = state.copyWith(
      pendingNameChange: newName,
      nameChangeDocType: documentType,
      nameChangeStatus: 'Under Review',
    );
  }

  void requestDobChange({
    required String newDob,
    required String documentType,
  }) {
    state = state.copyWith(
      pendingDobChange: newDob,
      dobChangeDocType: documentType,
      dobChangeStatus: 'Under Review',
    );
  }

  void updateName(String name) {
    StorageService.setUserFullName(name);
    state = state.copyWith(fullName: name);
  }

  void updateEmail(String email) {
    StorageService.setUserEmail(email);
    state = state.copyWith(email: email);
  }

  void updatePhone(String phone) {
    StorageService.setUserPhone(phone);
    state = state.copyWith(phoneNumber: phone);
  }

  void updateAddress({
    required String address,
    required String city,
    required String postcode,
  }) {
    state = state.copyWith(
      address: address,
      city: city,
      postcode: postcode,
      addressChangeStatus: 'Verified',
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, UserProfile>((ref) {
  return AuthNotifier();
});

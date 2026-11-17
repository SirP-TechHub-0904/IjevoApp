import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    this.biometricsEnabled = true,
    this.pushNotifications = true,
    this.smsNotifications = true,
    this.whatsappNotifications = false,
    this.emailNotifications = true,
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
    );
  }
}

class AuthNotifier extends StateNotifier<UserProfile> {
  AuthNotifier() : super(const UserProfile());

  void updateName(String name) {
    state = state.copyWith(fullName: name);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePhone(String phone) {
    state = state.copyWith(phoneNumber: phone);
  }

  void updateAddress({required String address, required String city, required String postcode}) {
    state = state.copyWith(address: address, city: city, postcode: postcode);
  }

  void toggleBiometrics(bool val) {
    state = state.copyWith(biometricsEnabled: val);
  }

  void togglePush(bool val) {
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
}

final authProvider = StateNotifierProvider<AuthNotifier, UserProfile>((ref) {
  return AuthNotifier();
});

class PhoneCountry {
  final String name;
  final String code; // ISO 2-letter
  final String dialCode;

  const PhoneCountry({
    required this.name,
    required this.code,
    required this.dialCode,
  });
}

const List<PhoneCountry> kPhoneCountries = [
  // United Kingdom & Ireland
  PhoneCountry(name: 'United Kingdom', code: 'GB', dialCode: '+44'),
  PhoneCountry(name: 'Ireland', code: 'IE', dialCode: '+353'),

  // European Countries
  PhoneCountry(name: 'Germany', code: 'DE', dialCode: '+49'),
  PhoneCountry(name: 'France', code: 'FR', dialCode: '+33'),
  PhoneCountry(name: 'Netherlands', code: 'NL', dialCode: '+31'),
  PhoneCountry(name: 'Belgium', code: 'BE', dialCode: '+32'),
  PhoneCountry(name: 'Spain', code: 'ES', dialCode: '+34'),
  PhoneCountry(name: 'Italy', code: 'IT', dialCode: '+39'),
  PhoneCountry(name: 'Portugal', code: 'PT', dialCode: '+351'),
  PhoneCountry(name: 'Switzerland', code: 'CH', dialCode: '+41'),
  PhoneCountry(name: 'Austria', code: 'AT', dialCode: '+43'),
  PhoneCountry(name: 'Poland', code: 'PL', dialCode: '+48'),
  PhoneCountry(name: 'Sweden', code: 'SE', dialCode: '+46'),
  PhoneCountry(name: 'Norway', code: 'NO', dialCode: '+47'),
  PhoneCountry(name: 'Denmark', code: 'DK', dialCode: '+45'),
  PhoneCountry(name: 'Finland', code: 'FI', dialCode: '+358'),
  PhoneCountry(name: 'Greece', code: 'GR', dialCode: '+30'),
  PhoneCountry(name: 'Czech Republic', code: 'CZ', dialCode: '+420'),
  PhoneCountry(name: 'Romania', code: 'RO', dialCode: '+40'),
  PhoneCountry(name: 'Hungary', code: 'HU', dialCode: '+36'),

  // North America
  PhoneCountry(name: 'United States', code: 'US', dialCode: '+1'),
  PhoneCountry(name: 'Canada', code: 'CA', dialCode: '+1'),

  // Africa
  PhoneCountry(name: 'Nigeria', code: 'NG', dialCode: '+234'),
  PhoneCountry(name: 'Ghana', code: 'GH', dialCode: '+233'),
  PhoneCountry(name: 'Kenya', code: 'KE', dialCode: '+254'),
  PhoneCountry(name: 'South Africa', code: 'ZA', dialCode: '+27'),
  PhoneCountry(name: 'Uganda', code: 'UG', dialCode: '+256'),
  PhoneCountry(name: 'Cameroon', code: 'CM', dialCode: '+237'),
];

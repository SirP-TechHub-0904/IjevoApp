# Ijevo Mobile Application

The official cross-platform mobile client for **Ijevo**, built with Flutter.

---

## 📱 Features

- **Multi-Currency Wallets**: Manage GBP, EUR, CAD, and NGN balances in real-time.
- **Instant Cross-Border Transfers**: Send money to Nigerian banks, mobile money, and global accounts.
- **Open Banking & Card Debits**: Fast 1-tap funding with UK Open Banking and 3D Secure debit cards.
- **Biometric Authentication**: Secure unlock with Face ID, Touch ID, and Android Biometrics with configurable auto-lock timeouts.
- **Native Receipt Sharing**: Generates clean, high-resolution `.png` transaction slips and launches the system share sheet for WhatsApp/Telegram chat bubble previews.
- **Push & Local Notifications**: Integrated OneSignal push messaging and in-app transaction notifications.

---

## 🛠️ Tech Stack & Architecture

- **Framework**: Flutter 3.x (Dart 3.x)
- **State Management**: Riverpod (`flutter_riverpod: ^2.5.1`)
- **Navigation**: GoRouter (`go_router: ^14.1.4`)
- **Biometrics & Security**: `local_auth: ^2.2.0`, `flutter_secure_storage: ^9.2.2`
- **Push Notifications**: `onesignal_flutter: 5.5.2`
- **Local Alerts**: `flutter_local_notifications: ^21.0.0`
- **File & Sharing**: `share_plus: ^9.0.0`, `path_provider: ^2.1.6`

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.24.0 or later)
- Android Studio / Android SDK (API 34+)
- Xcode 15+ (for iOS builds)

### Installation
```bash
flutter pub get
```

### Running on Device / Emulator
```bash
# Debug mode on connected device
flutter run

# Target specific device
flutter run -d <DEVICE_ID>
```

---

## 📦 Building for Release

### Android APK (Standalone Installable)
```powershell
flutter build apk --release --target-platform android-arm64
```
Output: `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`

### Android App Bundle (Google Play Store)
```powershell
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS Archive (Apple App Store / TestFlight)
```bash
cd ios && pod install && cd ..
flutter build ipa --release
```
Output: `build/ios/ipa/Ijevo.ipa`

---

## 📄 License & Brand Guidelines

Proprietary software. © 2026 **Ijevo Remittance Ltd**.  
See the root [README.md](../README.md) and [BRAND_GUIDELINES.md](../brand%20images/BRAND_GUIDELINES.md) for full project specifications.

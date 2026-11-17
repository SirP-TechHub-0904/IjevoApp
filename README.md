# Ijevo — Next-Generation Global Remittance & Multi-Currency Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.24+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![.NET](https://img.shields.io/badge/.NET-8.0%20%2F%209.0-512BD4?logo=dotnet&logoColor=white)](https://dotnet.microsoft.com)
[![Angular](https://img.shields.io/badge/Angular-18+-DD0031?logo=angular&logoColor=white)](https://angular.io)
[![License](https://img.shields.io/badge/License-Proprietary-00B074.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web-0B192C.svg)](#)

**Ijevo** is an institutional-grade, cross-border remittance and multi-currency banking platform engineered to deliver instant, low-cost money transfers across the UK, Europe, North America, and African corridors (Nigeria, Ghana, Kenya, and beyond).

---

## 🏛️ Ecosystem Architecture

The Ijevo ecosystem is organized as a unified monorepo comprising three principal engineering layers:

```
IjevoApp/
├── mobile/                  # Cross-Platform Flutter Mobile Application (iOS & Android)
├── backend/                 # ASP.NET Core 8/9 Clean Architecture Web API & SignalR Hubs
│   └── src/
│       ├── Core/            # Domain Entities, Interfaces, Enums & Value Objects
│       ├── Infrastructure/  # Entity Framework Core, SQL Server/PostgreSQL, Redis
│       ├── Presentation/    # REST APIs, Real-time WebSockets, Controllers
│       └── Shared/          # Security, AES-256 GCM encryption, Validation
├── web/
│   ├── website/             # Public Angular SSR Landing Website & SEO Marketing Engine
│   └── portal/              # Xintra Enterprise Angular Admin Dashboard & Rails Monitor
├── brand images/            # Vector Brand Guidelines, Master PSDs & Official Assets
└── README.md                # Comprehensive System Specification & Deployment Guide
```

---

## 📱 Mobile Application Architecture (`/mobile`)

The mobile client is built on **Flutter 3.x** utilizing an enterprise reactive state architecture:

- **State Management:** Riverpod 2.x (`flutter_riverpod`) with immutable state notifiers and automatic dependency disposal.
- **Routing & Deep Linking:** Declarative routing via `go_router` supporting authentication redirects and protected shell navigation.
- **Security & Biometrics:** Hardware-backed biometric authentication (Face ID, Touch ID, Android BiometricPrompt) powered by `local_auth` and AES-encrypted keychain via `flutter_secure_storage`.
- **Auto-Lock Mechanism:** Configurable idle inactivity auto-lock (immediate, 15m, 1h, 1d) via `AppLifecycleLockWrapper`.
- **Push & Local Notifications:** Dual-tier architecture using OneSignal SDK for server-driven remote push alerts + `flutter_local_notifications` with custom channels for real-time transactional heads-up banners.
- **Payment & Remittance Rails:**
  - Multi-Currency Wallets: Instant balance management and conversion across GBP, EUR, CAD, and NGN.
  - Linked Bank (Open Banking): 1-tap UK bank debit payments.
  - Debit/Credit Cards: 3D Secure card funding.
- **Receipt Engine:** High-density native image receipt generator (`ReceiptImageService`) rendering crisp 900x1120 `.png` slips attached directly to iOS/Android native share drawers for instant WhatsApp/chat bubble preview.

---

## 🚀 iOS App Store Publishing Guide (Apple App Store)

### 1. Prerequisites
- An active [Apple Developer Program](https://developer.apple.com/programs/) account ($99/year).
- macOS workstation with **Xcode 15+** installed.
- App Bundle Identifier: `com.ijevo.ijevoMobile`.

### 2. Configure App Store Connect
1. Log in to [App Store Connect](https://appstoreconnect.apple.com).
2. Navigate to **My Apps** > **+** > **New App**.
   - **Platform:** iOS
   - **Name:** Ijevo: Fast Money Transfer
   - **Primary Language:** English (UK)
   - **Bundle ID:** Select `com.ijevo.ijevoMobile` (created in Developer Portal).
   - **SKU:** `ijevo-mobile-ios`
   - **User Access:** Full Access

### 3. Permissions & Privacy Manifest Verification
The iOS project is already pre-configured with Apple compliance requirements:
- **`Info.plist` Usage Descriptions:**
  - `NSFaceIDUsageDescription`: Declared for biometric wallet security.
  - `NSPhotoLibraryAddUsageDescription`: Declared for saving transaction receipt images.
- **`PrivacyInfo.xcprivacy` (Mandatory since May 2024):**
  - Located at `mobile/ios/Runner/PrivacyInfo.xcprivacy` declaring UserDefaults (`CA92.1`), FileTimestamp (`C617.1`), SystemBootTime (`35F9.1`), and DiskSpace (`E174.1`).

### 4. Code Signing in Xcode
1. Open `mobile/ios/Runner.xcworkspace` in Xcode.
2. Select the top-level **Runner** project in the navigator.
3. Under **Signing & Capabilities**:
   - Check **Automatically manage signing**.
   - Select your registered **Team**.
   - Confirm Bundle Identifier is `com.ijevo.ijevoMobile`.
4. Ensure the **Push Notifications** and **Background Modes** (Remote notifications) capabilities are added if using APNs credentials with OneSignal.

### 5. Build and Archive
From your terminal in the `mobile` directory:
```bash
# Clean and install iOS Pods
flutter clean
flutter pub get
cd ios
pod install
cd ..

# Build release IPA archive
flutter build ipa --release
```

### 6. Upload to TestFlight & App Store
Option A: **Via Xcode Organizer**
1. In Xcode, select **Product** > **Archive**.
2. Once the archive appears in the Organizer window, click **Distribute App**.
3. Select **App Store Connect** > **Upload** > Follow on-screen signing checks.

Option B: **Via Transporter (Fastest CLI/GUI)**
1. Locate the built archive at `mobile/build/ios/ipa/Ijevo.ipa`.
2. Open the **Transporter** app (free on Mac App Store).
3. Drag `Ijevo.ipa` into Transporter and click **Deliver**.

### 7. App Store Review Financial Declarations
When submitting for review, provide the following in App Store Connect:
- **Category:** Finance.
- **Financial Services Verification:** Under App Review Information, state that Ijevo operates regulated money transmission through authorized payment institutions and compliant banking partners.
- **Demo Account:** Provide test login credentials (e.g. `tester@ijevo.com` / test password and test PIN/OTP) so Apple App Reviewers can sign in and test the wallet interface.

---

## 🤖 Google Play Store Publishing Guide (Android)

### 1. Generate a Release Upload Keystore
If you have not yet created a production release keystore, run:
```powershell
keytool -genkey -v -keystore C:\Users\JURAY\ijevo-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias ijevo-key
```

### 2. Configure `key.properties`
Create `mobile/android/key.properties` (this file is ignored by Git):
```properties
storePassword=<YOUR_STORE_PASSWORD>
keyPassword=<YOUR_KEY_PASSWORD>
keyAlias=ijevo-key
storeFile=C:/Users/JURAY/ijevo-release-key.jks
```

### 3. Build Production Android App Bundle (.aab)
Google Play requires **Android App Bundle (.aab)** format:
```powershell
cd mobile
flutter clean
flutter pub get
flutter build appbundle --release
```
The output will be created at:
```text
mobile/build/app/outputs/bundle/release/app-release.aab
```

### 4. Build Standalone Installable APK (For Direct Testing & Distribution)
To build a universal APK that can be sideloaded directly by testers without the Play Store:
```powershell
cd mobile
flutter build apk --release --target-platform android-arm64
```
Output:
```text
mobile/build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

---

## 🖥️ Backend Web API Architecture (`/backend`)

The backend services run on **ASP.NET Core 8/9** following Clean Architecture principles:

- **`Ijevo.Core`:** Domain entities (`User`, `Wallet`, `Transaction`, `Recipient`, `ExchangeRate`), Enums, and Repository interfaces.
- **`Ijevo.Infrastructure`:** Entity Framework Core persistence with DbContext migrations, Redis distributed caching, and third-party payment rail integrations.
- **`Ijevo.Presentation` (`Ijevo.Api`):**
  - RESTful endpoints for Authentication, Multi-Currency Ledger, and Beneficiaries.
  - **`TransferHub`:** Real-time SignalR WebSocket hub pushing live transaction status updates (`initiated` -> `processing` -> `delivered`).
- **`Ijevo.Shared`:** AES-256 GCM encryption services for sensitive card/bank details, HMAC signature verification, and standard response envelopes.

### Running Backend Locally:
```bash
cd backend/src/Presentation/Ijevo.Api
dotnet restore
dotnet run
```
API Documentation will be available at `https://localhost:7001/swagger`.

---

## 🌐 Web Platforms (`/web`)

### 1. Public Marketing Website (`/web/website`)
- Built with **Angular 18+** with Server-Side Rendering (SSR).
- Optimized for Core Web Vitals, dynamic OpenGraph social metadata, and automated search engine sitemaps.
- Responsive across mobile, tablet, and ultra-wide desktops.

```bash
cd web/website
npm install
npm run start
```

### 2. Administration & Compliance Portal (`/web/portal`)
- Built on the **Xintra Enterprise Angular** template design system.
- Real-time ledger monitoring, suspicious transaction flags, fee matrix configuration, and user KYC tier management.

```bash
cd web/portal
npm install
npm run start
```

---

## 🔒 Security & Compliance Standards

- **Data Encryption:** All sensitive personal Identifiable Information (PII) and card tokens are encrypted at rest using AES-256 and transmitted exclusively over TLS 1.3.
- **Zero-Logging of Card Numbers:** Full primary account numbers (PAN) are never stored in databases; only masked references and payment gateway tokens are retained.
- **Regulatory Declarations:** Fully prepared for submission under FCA, FinCEN, and Central Bank remittance regulations with integrated transaction reference numbers and session audit trails.

---

## 👥 Authors & Brand Rights

© 2026 **Ijevo Remittance Ltd**. All Rights Reserved.  
Official brand assets, typography specifications, and color tokens are maintained in [BRAND_GUIDELINES.md](brand%20images/BRAND_GUIDELINES.md).

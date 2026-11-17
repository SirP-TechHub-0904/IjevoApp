# Ijevo Official Brand Identity & Design System Specification

## 1. Official Color Palette & Development Tokens

The Ijevo palette balances institutional financial trust with modern digital speed and clarity.

| Role | Color Name | Hex Code | RGB | Dev Usage |
| :--- | :--- | :--- | :--- | :--- |
| **Primary (Brand)** | **Electric Emerald** | `#00D084` | `rgb(0, 208, 132)` | Main action color: "Send Money" buttons, active icons, transfer success states. |
| **Secondary (Security)** | **Atlantic Midnight Navy** | `#0B192C` | `rgb(11, 25, 44)` | Dark mode headers, cards, navigation bars, and premium backgrounds. |
| **Neutral Dark** | **Pitch Black** | `#000000` | `rgb(0, 0, 0)` | Primary text on white backgrounds, deep contrast canvas. |
| **Neutral Light** | **Crisp White** | `#FFFFFF` | `rgb(255, 255, 255)` | Primary text on dark backgrounds, cards, form input backgrounds. |
| **Surface Dark** | **Deep Surface Navy** | `#14243A` | `rgb(20, 36, 58)` | Elevated transaction cards, dialog sheets, and bottom nav in dark mode. |
| **Surface Light** | **Soft Cloud Gray** | `#F8FAFC` | `rgb(248, 250, 252)` | Default background canvas for mobile screens and web portal in light mode. |
| **Border & Divider** | **Subtle Slate** | `#E2E8F0` | `rgb(226, 232, 240)` | Card borders, text field outlines, list dividers. |
| **Error / Alert** | **Crimson Alert** | `#EF4444` | `rgb(239, 68, 68)` | Payment failed, declined cards, validation errors. |

---

## 2. Official Typography Specification

* **Primary Typeface:** **Century Gothic** (Installed system default) or **Poppins** (Google Fonts)
* **Weight:** **Bold (700)**
* **Letter Case:** Strictly **all lowercase** (`ijevo`)
* **Tracking / Letter Spacing:** `-10` to `0` (tight, cohesive modern tech spacing)
* **Text Color Rule:**
  * On Light / White Backgrounds: **Solid Black** (`#000000`) or Deep Navy (`#0B192C`)
  * On Dark / Black Backgrounds: **Crisp White** (`#FFFFFF`)

---

## 3. Ready-To-Use Code Implementation

### A. Flutter (`mobile/lib/theme/app_colors.dart`)
```dart
import 'package:flutter/material.dart';

class AppColors {
  // Core Brand
  static const Color primaryGreen = Color(0xFF00D084);
  static const Color darkNavy = Color(0xFF0B192C);
  
  // Surfaces & Backgrounds
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0B192C);
  static const Color cardDark = Color(0xFF14243A);
  static const Color cardLight = Colors.white;

  // Typography
  static const Color textLight = Colors.white;
  static const Color textDark = Color(0xFF000000);
  static const Color textMuted = Color(0xFF64748B);

  // Borders & States
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color success = Color(0xFF00D084);
  static const Color error = Color(0xFFEF4444);
}
```

### B. Angular / CSS Design Tokens (`web/website/src/styles.scss` & `web/admin/`)
```scss
:root {
  /* Core Brand */
  --ijevo-primary: #00D084;
  --ijevo-navy: #0B192C;

  /* Surfaces & Backgrounds */
  --ijevo-bg-light: #F8FAFC;
  --ijevo-bg-dark: #0B192C;
  --ijevo-surface-dark: #14243A;
  --ijevo-surface-light: #FFFFFF;

  /* Typography */
  --ijevo-text-primary: #000000;
  --ijevo-text-inverse: #FFFFFF;
  --ijevo-text-muted: #64748B;

  /* Borders & States */
  --ijevo-border: #E2E8F0;
  --ijevo-success: #00D084;
  --ijevo-error: #EF4444;
}
```

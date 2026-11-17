import 'package:flutter/material.dart';

class AppColors {
  // Primary Ijevo Brand Colors
  static const Color primary = Color(0xFF00D084); // Ijevo Emerald Green
  static const Color primaryDark = Color(0xFF00B371);
  static const Color primaryLight = Color(0xFFE6FAF3);
  
  // Secondary / Deep Accents
  static const Color navy = Color(0xFF0B192C);
  static const Color navyCard = Color(0xFF14243A);
  
  // Backgrounds & Neutrals
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color surfaceSecondary = Color(0xFFF1F5F9);
  
  // Typography
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textWhite = Colors.white;
  
  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  
  // Status Colors
  static const Color success = Color(0xFF00D084);
  static const Color successLight = Color(0xFFE6FAF3);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFEFF6FF);

  // Gradient for calculator hero card
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE8FAF2),
      Color(0xFFF8FAFC),
    ],
  );
}

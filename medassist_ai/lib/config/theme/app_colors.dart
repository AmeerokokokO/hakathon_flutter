import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color secondaryGreen = Color(0xFF43A047);
  static const Color accentTeal = Color(0xFF00C9A7);

  // Light Theme Colors
  static const Color backgroundLight = Color(0xFFF8FBFF);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFF5F7FA);
  static const Color textPrimaryLight = Color(0xFF1A1F36);
  static const Color textSecondaryLight = Color(0xFF6B7280);

  // Dark Theme Colors
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF334155);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E88E5), Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF43A047), Color(0xFF388E3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF00C9A7), Color(0xFF00B894)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Neumorphic Shadow Colors
  static Color lightShadowLight = Colors.white;
  static Color darkShadowLight = Colors.black.withOpacity(0.15);
  static Color lightShadowDark = Colors.white.withOpacity(0.05);
  static Color darkShadowDark = Colors.black.withOpacity(0.5);
}

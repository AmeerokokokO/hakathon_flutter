import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Light Theme Text Styles
  static TextStyle lightH1 = GoogleFonts.cairo(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: const Color(0xFF1A1F36),
    height: 1.2,
  );

  static TextStyle lightH2 = GoogleFonts.cairo(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: const Color(0xFF1A1F36),
    height: 1.3,
  );

  static TextStyle lightH3 = GoogleFonts.cairo(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: const Color(0xFF1A1F36),
    height: 1.4,
  );

  static TextStyle lightBodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF1A1F36),
    height: 1.5,
  );

  static TextStyle lightBodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF6B7280),
    height: 1.5,
  );

  static TextStyle lightBodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF6B7280),
    height: 1.5,
  );

  static TextStyle lightCaption = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF9CA3AF),
    height: 1.4,
  );

  static TextStyle lightButton = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  // Dark Theme Text Styles
  static TextStyle darkH1 = GoogleFonts.cairo(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: const Color(0xFFF1F5F9),
    height: 1.2,
  );

  static TextStyle darkH2 = GoogleFonts.cairo(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: const Color(0xFFF1F5F9),
    height: 1.3,
  );

  static TextStyle darkH3 = GoogleFonts.cairo(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: const Color(0xFFF1F5F9),
    height: 1.4,
  );

  static TextStyle darkBodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: const Color(0xFFF1F5F9),
    height: 1.5,
  );

  static TextStyle darkBodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF94A3B8),
    height: 1.5,
  );

  static TextStyle darkBodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF94A3B8),
    height: 1.5,
  );

  static TextStyle darkCaption = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF64748B),
    height: 1.4,
  );

  static TextStyle darkButton = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );
}

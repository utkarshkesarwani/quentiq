import 'package:flutter/material.dart';

abstract final class AppColors {
  static const deepBlue = Color(0xFF1A2B6B);
  static const deepBlueLight = Color(0xFF2D4A9E);
  static const purple = Color(0xFF6C4DFF);
  static const purpleSoft = Color(0xFF9B7BFF);
  static const accentGlow = Color(0xFF7C5CFF);

  static const lightBg = Color(0xFFF8F9FC);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightText = Color(0xFF0F172A);
  static const lightMuted = Color(0xFF64748B);
  static const lightBorder = Color(0xFFE8ECF4);

  static const darkBg = Color(0xFF0B0F1A);
  static const darkSurface = Color(0xFF141B2D);
  static const darkCard = Color(0xFF1A2238);
  static const darkText = Color(0xFFF1F5F9);
  static const darkMuted = Color(0xFF94A3B8);
  static const darkBorder = Color(0xFF2A3548);

  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);

  static const gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [deepBlue, purple],
  );

  static const gradientGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4F46E5), Color(0xFF9333EA)],
  );

  static const categoryPlumbing = Color(0xFF0EA5E9);
  static const categoryElectrical = Color(0xFFF59E0B);
  static const categoryCleaning = Color(0xFF10B981);
  static const categoryWater = Color(0xFF3B82F6);
  static const categoryMaintenance = Color(0xFF8B5CF6);
}

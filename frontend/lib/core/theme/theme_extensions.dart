import 'package:flutter/material.dart';
import 'package:quentiq/core/theme/app_colors.dart';

extension ThemeX on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get surfaceColor =>
      isDark ? AppColors.darkCard : AppColors.lightSurface;

  Color get bgColor => isDark ? AppColors.darkBg : AppColors.lightBg;

  Color get textPrimary =>
      isDark ? AppColors.darkText : AppColors.lightText;

  Color get textMuted =>
      isDark ? AppColors.darkMuted : AppColors.lightMuted;

  Color get borderColor =>
      isDark ? AppColors.darkBorder : AppColors.lightBorder;

  List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: isDark
              ? Colors.black.withValues(alpha: 0.35)
              : AppColors.deepBlue.withValues(alpha: 0.06),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];
}

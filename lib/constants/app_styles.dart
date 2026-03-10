import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  // === Text Styles ===

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 22,
    height: 2.0,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 18,
    height: 1.9,
    color: AppColors.textPrimary,
  );

  static const TextStyle quranText = TextStyle(
    fontFamily: 'Uthmanic',
    fontSize: 28,
    height: 2.4,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  static const TextStyle lateefStyle = TextStyle(
    fontFamily: 'Lateef',
    fontSize: 22,
    height: 2.0,
    color: AppColors.textPrimary,
  );

  // === Decorations ===

  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowLight,
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );

  static BoxDecoration accentCardDecoration = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: AppColors.accent.withOpacity(0.18), width: 1),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowLight,
        blurRadius: 16,
        offset: const Offset(0, 6),
      ),
    ],
  );

  // === Spacing ===

  static const EdgeInsets paddingAll = EdgeInsets.all(16);
  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets paddingVertical = EdgeInsets.symmetric(vertical: 16);
}
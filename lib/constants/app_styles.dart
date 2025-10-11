import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  // Text Styles with Amiri font (for general UI)
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
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

  // Athkar text styles - using Amiri for better readability
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 24,
    height: 2.2,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 20,
    height: 2.0,
    color: AppColors.textPrimary,
  );

  // For Quranic verses - use Uthmanic font
  static const TextStyle quranText = TextStyle(
    fontFamily: 'Uthmanic',
    fontSize: 28,
    height: 2.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Amiri',
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  // Alternative font style using Lateef
  static const TextStyle lateefStyle = TextStyle(
    fontFamily: 'Lateef',
    fontSize: 22,
    height: 2.0,
    color: AppColors.textPrimary,
  );

  // Card Decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.cardBackground,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Padding
  static const EdgeInsets paddingAll = EdgeInsets.all(16);
  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets paddingVertical = EdgeInsets.symmetric(vertical: 16);
}
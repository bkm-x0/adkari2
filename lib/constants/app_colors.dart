import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Islamic Green & Gold
  static const Color primary = Color(0xFF006B3F);
  static const Color primaryLight = Color(0xFF00A65A);
  static const Color primaryDark = Color(0xFF004D2E);
  
  // Accent Colors - Gold
  static const Color accent = Color(0xFFD4AF37);
  static const Color accentLight = Color(0xFFFFD700);
  static const Color accentDark = Color(0xFFB8960F);
  
  // Background Colors - Modern gradient
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Colors.white;
  static const Color surface = Color(0xFFFFFFFF);
  
  // Gradient colors
  static const Color gradientStart = Color(0xFF006B3F);
  static const Color gradientEnd = Color(0xFF00A65A);
  
  // Quran specific colors
  static const Color quranBackground = Color(0xFFFFFDF7);
  static const Color quranBorder = Color(0xFFD4AF37);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);
  static const Color textWhite = Colors.white;
  
  // Counter Colors
  static const Color counterActive = Color(0xFF00A65A);
  static const Color counterInactive = Color(0xFFE0E0E0);
  static const Color counterCompleted = Color(0xFF4CAF50);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF29B6F6);
  
  // Shadow colors
  static Color shadowLight = Colors.black.withOpacity(0.08);
  static Color shadowMedium = Colors.black.withOpacity(0.12);
  
  // Gradient
  static LinearGradient primaryGradient = const LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static LinearGradient goldGradient = const LinearGradient(
    colors: [accentDark, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Primary Colors
  static const Color primaryBlue = Color(0xFF0d47a1);
  static const Color primaryTeal = Color(0xFF006064);
  
  // Accent Colors
  static const Color accentTeal = Color(0xFF26a69a);
  static const Color accentCyan = Color(0xFF00acc1);
  
  // Background Colors
  
  // Text Colors
  
  // UI Colors
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;
  
  // Main colors used in the app
  
  // Gradients
 

  
  static const List<Color> gradientColors = [primaryDark, primaryBlue, primaryTeal];
  static const List<Color> cardGradient = [accentTeal, accentCyan];
  
}
 

  

import 'package:flutter/material.dart';

class AppColors {
  // Primary — deep emerald teal
  static const Color primary = Color(0xFF1A6B5A);
  static const Color primaryLight = Color(0xFF2E8B76);
  static const Color primaryDark = Color(0xFF0E4A3E);

  // Accent — warm antique gold
  static const Color accent = Color(0xFFC9A84C);
  static const Color accentLight = Color(0xFFE5CA72);
  static const Color accentDark = Color(0xFFA68A30);

  // Backgrounds — warm cream tones
  static const Color background = Color(0xFFFAF7F2);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F1EA);

  // Gradient colors
  static const Color gradientStart = Color(0xFF1A6B5A);
  static const Color gradientEnd = Color(0xFF2E8B76);

  // Quran
  static const Color quranBackground = Color(0xFFFFF9EF);
  static const Color quranBorder = Color(0xFFC9A84C);

  // Text
  static const Color textPrimary = Color(0xFF2D2D2D);
  static const Color textSecondary = Color(0xFF7A7A7A);
  static const Color textLight = Color(0xFFAEAEAE);
  static const Color textWhite = Colors.white;

  // Counter
  static const Color counterActive = Color(0xFF2E8B76);
  static const Color counterInactive = Color(0xFFE8E3DA);
  static const Color counterCompleted = Color(0xFF43A088);

  // Status
  static const Color success = Color(0xFF43A088);
  static const Color warning = Color(0xFFE8A838);
  static const Color error = Color(0xFFD9534F);
  static const Color info = Color(0xFF5BB8D4);

  // Shadows — warm-tone
  static Color shadowLight = const Color(0xFF8B7D6B).withOpacity(0.08);
  static Color shadowMedium = const Color(0xFF8B7D6B).withOpacity(0.14);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [gradientStart, gradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [accentDark, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF0E4A3E), Color(0xFF1A6B5A), Color(0xFF2E8B76)],
  );

  // Aliases kept for compatibility
  static const Color primaryBlue = Color(0xFF1A6B5A);
  static const Color primaryTeal = Color(0xFF0E4A3E);
  static const Color accentTeal = Color(0xFF2E8B76);
  static const Color accentCyan = Color(0xFF43A088);
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;

  static const List<Color> gradientColors = [primaryDark, primaryBlue, primaryTeal];
  static const List<Color> cardGradient = [accentTeal, accentCyan];
}

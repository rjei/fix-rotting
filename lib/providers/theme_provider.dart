import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF0593C6);
  static const Color accent = Color(0xFFD83995);
  static const Color accentDark = Color(0xFFB02073);
  static const Color accentLight = Color(0xFFFDE8F3);

  static const Color bgLight = Color(0xFFFCFFFF);
  static const Color bgDark = Color(0xFF121824);
  static const Color bgDarkGradientEnd = Color(0xFF1E293B);

  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1A2333);
  static const Color cardBorderLight = Color(0xFFE5F1F6);
  static const Color cardBorderDark = Color(0xFF28364C);

  static const Color textPrimaryLight = Color(0xFF152536);
  static const Color textPrimaryDark = Color(0xFFF1F6FA);
  static const Color textMutedLight = Color(0xFF7A8D9E);
  static const Color textMutedDark = Color(0xFF8B9FB3);

  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0xFFEAFBF3);
  static const Color warning = Color(0xFFF59E0B);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color flame = Color(0xFFFF5252);
  static const Color gem = Color(0xFFD946EF);
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  ThemeData get lightTheme {
    final base = ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bgLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.cardLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimaryLight,
        displayColor: AppColors.textPrimaryLight,
      ),
    );
  }

  ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bgDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.cardDark,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme).apply(
        bodyColor: AppColors.textPrimaryDark,
        displayColor: AppColors.textPrimaryDark,
      ),
    );
  }
}

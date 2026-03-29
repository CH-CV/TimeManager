import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryLight = Color(0xFF2563EB);
  static const Color primaryDark = Color(0xFF3B82F6);

  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF1A1A1A);

  static const Color cardLight = Color(0xFFF8FAFC);
  static const Color cardDark = Color(0xFF262626);

  static const Color textLight = Color(0xFF1E293B);
  static const Color textDark = Color(0xFFF1F5F9);

  static const Color success = Color(0xFF22C55E);
  static const Color successDark = Color(0xFF4ADE80);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningDark = Color(0xFFFBBF24);

  static const Color error = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFF87171);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryLight,
        surface: AppColors.backgroundLight,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.textLight,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textLight),
        bodyMedium: TextStyle(color: AppColors.textLight),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryDark,
        surface: AppColors.backgroundDark,
        error: AppColors.errorDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textDark,
        elevation: 0,
        centerTitle: true,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textDark),
        bodyMedium: TextStyle(color: AppColors.textDark),
      ),
    );
  }
}

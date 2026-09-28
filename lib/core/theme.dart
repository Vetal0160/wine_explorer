import 'package:flutter/material.dart';

class AppTheme {
  // Основные цвета: глубокий бордовый и теплый золотой/кремовый
  static const Color wineRed = Color(0xFF58111A);
  static const Color wineAccent = Color(0xFF8B263E);
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color backgroundColor = Color(0xFFFAF7F5);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: wineRed,
        primary: wineRed,
        secondary: goldAccent,
        surface: backgroundColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: wineRed,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
    );
  }
}
import 'package:flutter/material.dart';

class AppTheme {
  // Colores Premium
  static const Color primaryColor = Color(0xFF00F2FF); // Electric Cyan
  static const Color secondaryColor = Color(0xFF6366F1); // Indigo
  static const Color surfaceDark = Color(0xFF0F172A); // Slate 900
  static const Color backgroundDark = Color(0xFF020617); // Slate 950

  // 🌙 MODO OSCURO PREMIUM
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.black,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        error: Color(0xFFFF3B30),
        background: backgroundDark,
        surface: surfaceDark,
        onSurface: Colors.white,
        outline: Color(0xFF1E293B),
      ),
      textTheme: _getTextTheme(),
      elevatedButtonTheme: _buttonTheme,
      inputDecorationTheme: _inputTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundDark.withValues(alpha: 0.8),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF1E293B), width: 1),
        ),
      ),
    );
  }

  // ☀️ MODO CLARO PREMIUM
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      colorScheme: const ColorScheme.light(
        primary: Colors.black,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        error: Color(0xFFFF3B30),
        background: Color(0xFFF8FAFC),
        surface: Colors.white,
        onSurface: Colors.black,
        outline: Color(0xFFE2E8F0),
      ),
      textTheme: _getTextTheme(isDark: false),
      elevatedButtonTheme: _buttonTheme,
      inputDecorationTheme: _inputTheme(isDark: false),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF8FAFC).withValues(alpha: 0.8),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
    );
  }

  static TextTheme _getTextTheme({bool isDark = true}) {
    final textColor = isDark ? Colors.white : AppColors.slate.shade900;
    final secondaryColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textColor, letterSpacing: -1),
      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor, letterSpacing: -0.5),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: textColor, height: 1.5),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: secondaryColor),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor, letterSpacing: 0.5),
    );
  }

  static ElevatedButtonThemeData get _buttonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        minimumSize: const Size(88, 48),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  static InputDecorationTheme _inputTheme({bool isDark = true}) {
    final borderColor = isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);
    final focusColor = isDark ? primaryColor : Colors.black;
    final fillColor = isDark ? surfaceDark : Colors.white;

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: focusColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      labelStyle: TextStyle(fontSize: 14, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
      floatingLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: focusColor),
    );
  }
}

class AppColors {
  static const MaterialColor slate = MaterialColor(
    0xFF64748B,
    <int, Color>{
      50: Color(0xFFF8FAFC),
      100: Color(0xFFF1F5F9),
      200: Color(0xFFE2E8F0),
      300: Color(0xFFCBD5E1),
      400: Color(0xFF94A3B8),
      500: Color(0xFF64748B),
      600: Color(0xFF475569),
      700: Color(0xFF334155),
      800: Color(0xFF1E293B),
      900: Color(0xFF0F172A),
      950: Color(0xFF020617),
    },
  );
}

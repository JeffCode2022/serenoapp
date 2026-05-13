import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 🌙 MODO OSCURO MINIMALISTA (Estilo Threads/X)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.black, // Fondo puro negro
      colorScheme: const ColorScheme.dark(
        primary: Colors.white, // Acento principal blanco
        onPrimary: Colors.black,
        secondary: Color(0xFF1DA1F2), // Azul social (similar a X)
        onSecondary: Colors.white,
        error: Color(0xFFFF3B30), // Rojo intenso estilo iOS para SOS
        background: Colors.black,
        surface: Color(0xFF121212), // Tarjetas gris muy oscuro
        onSurface: Colors.white,
        outline: Color(0xFF2C2C2C), // Bordes sutiles
      ),
      textTheme: _getTextTheme(),
      elevatedButtonTheme: _buttonTheme,
      inputDecorationTheme: _inputTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1A1A1A), // Gris muy oscuro, pero resalta del negro
        elevation: 4,
        shadowColor: Colors.black45,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide.none, // Sin borde, pura sombra
        ),
      ),
    );
  }

  // ☀️ MODO CLARO MINIMALISTA
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(
        primary: Colors.black,
        onPrimary: Colors.white,
        secondary: Color(0xFF1DA1F2),
        onSecondary: Colors.white,
        error: Color(0xFFFF3B30),
        background: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        outline: Color(0xFFE5E5E5),
      ),
      textTheme: _getTextTheme(isDark: false),
      elevatedButtonTheme: _buttonTheme,
      inputDecorationTheme: _inputTheme(isDark: false),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide.none,
        ),
      ),
    );
  }

  static TextTheme _getTextTheme({bool isDark = true}) {
    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryColor = isDark ? const Color(0xFF71767B) : const Color(0xFF536471); // Grises estilo X

    return TextTheme(
      displayLarge: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: textColor, letterSpacing: -1),
      headlineMedium: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: textColor, letterSpacing: -0.5),
      bodyLarge: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400, color: textColor, height: 1.4),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: secondaryColor),
      labelLarge: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: textColor),
    );
  }

  static ElevatedButtonThemeData get _buttonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), // Botones de píldora
        minimumSize: const Size(double.infinity, 52), 
      ),
    );
  }

  static InputDecorationTheme _inputTheme({bool isDark = true}) {
    final borderColor = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE5E5E5);
    final focusColor = isDark ? Colors.white : Colors.black;
    final textColor = isDark ? Colors.white : Colors.black;

    return InputDecorationTheme(
      filled: true,
      fillColor: Colors.transparent, // Inputs transparentes
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
        borderSide: BorderSide(color: focusColor, width: 2), // Borde más grueso al escribir
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      labelStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400, color: isDark ? const Color(0xFF71767B) : const Color(0xFF536471)),
      floatingLabelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: focusColor),
    );
  }
}

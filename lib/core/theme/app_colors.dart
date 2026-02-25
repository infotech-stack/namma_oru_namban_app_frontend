import 'package:flutter/material.dart';

class AppTheme {
  // 🔥 Brand Colors
  static const Color primaryColor = Color(0xFF9B26B6);
  static const Color secondaryColor = Colors.white;

  // 🔘 Grey Scale (Global)
  static const Color greyLight = Color(0xFFF2F2F2);
  static const Color greyMedium = Color(0xFF9E9E9E);
  static const Color greyDark = Color(0xFF616161);

  // ================= RED COLORS =================

  // Light Mode
  static const Color redLight = Color(0xFFFFEBEE); // soft red bg
  static const Color red = Color(0xFFE53935); // primary red
  static const Color redDark = Color(0xFFB71C1C); // dark red

  // ================= GREEN COLORS =================

  // Light Mode
  static const Color greenLight = Color(0xFFE8F5E9); // soft green bg
  static const Color green = Color(0xFF43A047); // primary green
  static const Color greenDark = Color(0xFF1B5E20); // dark green

  // ================= LIGHT COLORS =================
  static const Color lightBackground = Colors.white;
  static const Color lightText = Colors.black;
  static const Color lightCard = Color(0xFFF5F5F5);
  static const Color lightBorder = Color(0xFFE0E0E0);

  // ================= DARK COLORS =================
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkText = Colors.white;
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkBorder = Color(0xFF2C2C2C);
  static const Color darkSecondaryColor = Color(0xFF1E1E1E);

  // ================= LIGHT THEME =================
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: lightBackground,

    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: lightCard,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.black,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: lightText),
      bodyMedium: TextStyle(color: lightText),
      bodySmall: TextStyle(color: greyDark),

      titleLarge: TextStyle(color: lightText, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: lightText),
      titleSmall: TextStyle(color: lightText),

      labelLarge: TextStyle(color: lightText),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: greyLight,
      hintStyle: const TextStyle(color: greyMedium),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor),
      ),
    ),

    dividerColor: greyMedium,
    cardColor: lightCard,
  );

  // ================= DARK THEME =================
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackground,

    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: darkSecondaryColor,
      surface: darkCard,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onSurface: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: darkText),
      bodyMedium: TextStyle(color: darkText),
      bodySmall: TextStyle(color: greyMedium),

      titleLarge: TextStyle(color: darkText, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(color: darkText),
      titleSmall: TextStyle(color: darkText),

      labelLarge: TextStyle(color: darkText),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCard,
      hintStyle: const TextStyle(color: greyMedium),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor),
      ),
    ),

    dividerColor: greyDark,
    cardColor: darkCard,
  );
}

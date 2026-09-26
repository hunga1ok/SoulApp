import 'package:flutter/material.dart';

abstract final class SoulColors {
  static const paper = Color(0xFFFFFAF7);
  static const surface = Color(0xFFFFFEFD);
  static const plum = Color(0xFF593C54);
  static const muted = Color(0xFF887985);
  static const rose = Color(0xFFFAE8E7);
  static const lilac = Color(0xFFEEE1F2);
  static const lilacStrong = Color(0xFF9F769D);
  static const line = Color(0xFFF0E2E3);
}

abstract final class SoulSpace {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

final soulTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: SoulColors.paper,
  colorScheme: const ColorScheme.light(
    primary: SoulColors.lilacStrong,
    onPrimary: Colors.white,
    surface: SoulColors.surface,
    onSurface: SoulColors.plum,
    outline: SoulColors.line,
  ),
  textTheme: const TextTheme(
    displaySmall: TextStyle(
      color: SoulColors.plum,
      fontFamily: 'serif',
      fontSize: 31,
      height: 1.05,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      color: SoulColors.plum,
      fontFamily: 'serif',
      fontSize: 25,
      height: 1.12,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      color: SoulColors.plum,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: TextStyle(color: SoulColors.plum, fontSize: 16, height: 1.45),
    bodyMedium: TextStyle(color: SoulColors.muted, fontSize: 14, height: 1.4),
    labelLarge: TextStyle(fontWeight: FontWeight.w700),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: SoulColors.paper,
    foregroundColor: SoulColors.plum,
    elevation: 0,
    scrolledUnderElevation: 0,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: SoulColors.surface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: SoulSpace.md,
      vertical: SoulSpace.md,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: SoulColors.line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: SoulColors.line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: SoulColors.lilacStrong, width: 1.5),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size.fromHeight(52),
      backgroundColor: SoulColors.lilacStrong,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(fontWeight: FontWeight.w700),
    ),
  ),
);

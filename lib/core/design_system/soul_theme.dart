import 'package:flutter/material.dart';

import '../../features/mood/mood_theme.dart';

/// Colors from the prototype brand system (`styles.css`, "Soul brand system").
abstract final class SoulColors {
  static const paper = Color(0xFFFFFAF7);
  static const surface = Color(0xFFFFFEFD);
  static const plum = Color(0xFF593C54);
  static const muted = Color(0xFF887985);
  static const rose = Color(0xFFFAE8E7);
  static const lilac = Color(0xFFEEE1F2);
  static const lilacStrong = Color(0xFF9F769D);
  static const line = Color(0xFFF0E2E3);
  static const gold = Color(0xFFD99C4B);
  static const error = Color(0xFFA24A5E);

  static const ctaStart = Color(0xFF895D81);
  static const ctaEnd = Color(0xFFAA7188);
  static const softFill = Color(0xFFF5E8F0);
  static const softInk = Color(0xFF88576D);

  static const selectedFill = Color(0xFFF4E6F3);
  static const selectedBorder = Color(0xFFD6BDD9);
  static const selectedInk = Color(0xFF805C89);
  static const inputBorder = Color(0xFFDEDCE5);

  static const iconTileStart = Color(0xFFFAE4E6);
  static const iconTileEnd = Color(0xFFE9DFF3);
  static const progressStart = Color(0xFFE2A15C);
  static const progressEnd = Color(0xFFC77B91);

  /// Journal sticky note: warm-white ruled paper, never the old yellow.
  static const notePaper = Color(0xFFFFFDF8);
  static const noteRule = Color(0xFFD9E7ED);
  static const noteBorder = Color(0xFFF3E8E4);
  static const noteTape = Color(0xAAEDC6CC);
  static const noteDate = Color(0xFFA36E78);
  static const noteInk = Color(0xFF614456);
}

abstract final class SoulSpace {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

abstract final class SoulRadius {
  static const iconTile = 11.0;
  static const button = 14.0;
  static const input = 15.0;
  static const row = 16.0;
  static const card = 22.0;
  static const sheet = 28.0;
  static const stickyNote = BorderRadius.only(
    topLeft: Radius.circular(7),
    topRight: Radius.circular(22),
    bottomRight: Radius.circular(16),
    bottomLeft: Radius.circular(19),
  );
}

abstract final class SoulShadows {
  static const card = [
    BoxShadow(color: Color(0x12865061), blurRadius: 22, offset: Offset(0, 8)),
  ];
  static const button = [
    BoxShadow(color: Color(0x38935972), blurRadius: 16, offset: Offset(0, 8)),
  ];
  static const stickyNote = [
    BoxShadow(color: Color(0x1C8E5B69), blurRadius: 18, offset: Offset(0, 9)),
  ];
}

abstract final class SoulSizes {
  /// Minimum interactive target (REQ-UX-004).
  static const minTouchTarget = 48.0;
  static const buttonHeight = 52.0;
  static const iconTile = 34.0;
  static const progressHeight = 7.0;
}

/// Serif for emotional display headings; controls and body use the platform
/// sans-serif. Brand fonts (Playfair Display, DM Sans) are not bundled yet.
abstract final class SoulTypography {
  static const serif = 'serif';
  static const serifFallback = ['Georgia', 'Noto Serif'];
}

ThemeData buildSoulTheme([SoulMood? mood]) {
  final config = mood != null ? moodConfigOf(mood) : null;
  final scaffoldBg = config?.scaffoldBackground ?? SoulColors.paper;
  final primary = config?.primary ?? SoulColors.lilacStrong;
  final surface = config?.surface ?? SoulColors.surface;
  final outline = config?.outline ?? SoulColors.line;

  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: scaffoldBg,
    materialTapTargetSize: MaterialTapTargetSize.padded,
    colorScheme: ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      surface: surface,
      onSurface: SoulColors.plum,
      outline: outline,
      error: SoulColors.error,
    ),
    textTheme: const TextTheme(
      displaySmall: TextStyle(
        color: SoulColors.plum,
        fontFamily: SoulTypography.serif,
        fontFamilyFallback: SoulTypography.serifFallback,
        fontSize: 31,
        height: 1.08,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: TextStyle(
        color: SoulColors.plum,
        fontFamily: SoulTypography.serif,
        fontFamilyFallback: SoulTypography.serifFallback,
        fontSize: 25,
        height: 1.12,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: SoulColors.plum,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        color: SoulColors.plum,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: TextStyle(color: SoulColors.plum, fontSize: 16, height: 1.45),
      bodyMedium: TextStyle(color: SoulColors.muted, fontSize: 14, height: 1.4),
      labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: scaffoldBg,
      foregroundColor: SoulColors.plum,
      elevation: 0,
      scrolledUnderElevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: SoulSpace.md,
        vertical: SoulSpace.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SoulRadius.input),
        borderSide: const BorderSide(color: SoulColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SoulRadius.input),
        borderSide: const BorderSide(color: SoulColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SoulRadius.input),
        borderSide: const BorderSide(color: SoulColors.lilacStrong, width: 1.5),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: SoulColors.surface,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(SoulRadius.sheet),
        ),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: SoulColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SoulRadius.sheet),
      ),
    ),
  );
}

final soulTheme = buildSoulTheme();

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// Supported emotion states that map directly to visual palettes and soundscapes.
enum SoulMood {
  peaceful('peaceful'),
  grateful('grateful'),
  energized('energized'),
  relieved('relieved'),
  reflective('reflective');

  const SoulMood(this.id);
  final String id;

  static SoulMood fromId(String? id) {
    if (id == null) return SoulMood.peaceful;
    return SoulMood.values.firstWhere(
      (m) => m.id == id,
      orElse: () => SoulMood.peaceful,
    );
  }

  static SoulMood? tryParse(String? id) {
    if (id == null) return null;
    for (final m in SoulMood.values) {
      if (m.id == id) return m;
    }
    return null;
  }
}

/// Visual and acoustic characteristics associated with an emotion.
class MoodThemeConfig {
  const MoodThemeConfig({
    required this.mood,
    required this.emoji,
    required this.primary,
    required this.accent,
    required this.scaffoldBackground,
    required this.surface,
    required this.outline,
    required this.glow,
    required this.soundscapeAsset,
    required this.soundscapeTitle,
  });

  final SoulMood mood;
  final String emoji;
  final Color primary;
  final Color accent;
  final Color scaffoldBackground;
  final Color surface;
  final Color outline;
  final Color glow;
  final String soundscapeAsset;
  final String soundscapeTitle;

  String localizedLabel(AppLocalizations l10n) {
    switch (mood) {
      case SoulMood.peaceful:
        return l10n.moodPeaceful;
      case SoulMood.grateful:
        return l10n.moodGrateful;
      case SoulMood.energized:
        return l10n.moodEnergized;
      case SoulMood.relieved:
        return l10n.moodRelieved;
      case SoulMood.reflective:
        return l10n.moodReflective;
    }
  }

  String localizedDesc(AppLocalizations l10n) {
    switch (mood) {
      case SoulMood.peaceful:
        return l10n.moodPeacefulDesc;
      case SoulMood.grateful:
        return l10n.moodGratefulDesc;
      case SoulMood.energized:
        return l10n.moodEnergizedDesc;
      case SoulMood.relieved:
        return l10n.moodRelievedDesc;
      case SoulMood.reflective:
        return l10n.moodReflectiveDesc;
    }
  }
}

final moodThemeConfigs = {
  SoulMood.peaceful: const MoodThemeConfig(
    mood: SoulMood.peaceful,
    emoji: '🕊️',
    primary: Color(0xFF7E6179),
    accent: Color(0xFFF3EAF4),
    scaffoldBackground: Color(0xFFFAF7F9),
    surface: Color(0xFFFDFBFD),
    outline: Color(0xFFEFE2F0),
    glow: Color(0xFFE2D0E4),
    soundscapeAsset: 'assets/audio/music/so-11-warm-felt-piano.m4a',
    soundscapeTitle: 'Warm Felt Piano (432Hz)',
  ),
  SoulMood.grateful: const MoodThemeConfig(
    mood: SoulMood.grateful,
    emoji: '🌸',
    primary: Color(0xFFA25974),
    accent: Color(0xFFFCECF1),
    scaffoldBackground: Color(0xFFFFF6F8),
    surface: Color(0xFFFFFAFB),
    outline: Color(0xFFF7DDE6),
    glow: Color(0xFFF2C2D4),
    soundscapeAsset: 'assets/audio/music/so-18-heart-space.m4a',
    soundscapeTitle: 'Heart Space (528Hz)',
  ),
  SoulMood.energized: const MoodThemeConfig(
    mood: SoulMood.energized,
    emoji: '☀️',
    primary: Color(0xFFA8702D),
    accent: Color(0xFFFDF2E2),
    scaffoldBackground: Color(0xFFFCF8F2),
    surface: Color(0xFFFFFDF9),
    outline: Color(0xFFF5E4CE),
    glow: Color(0xFFEED0A8),
    soundscapeAsset: 'assets/audio/music/so-13-golden-flow.m4a',
    soundscapeTitle: 'Golden Flow',
  ),
  SoulMood.relieved: const MoodThemeConfig(
    mood: SoulMood.relieved,
    emoji: '🍃',
    primary: Color(0xFF4C7B65),
    accent: Color(0xFFEBF5EF),
    scaffoldBackground: Color(0xFFF4F9F6),
    surface: Color(0xFFF9FCFA),
    outline: Color(0xFFDEEDE4),
    glow: Color(0xFFC7E2D2),
    soundscapeAsset: 'assets/audio/music/so-16-open-sky-handpan.m4a',
    soundscapeTitle: 'Open Sky Handpan',
  ),
  SoulMood.reflective: const MoodThemeConfig(
    mood: SoulMood.reflective,
    emoji: '🌙',
    primary: Color(0xFF4E6386),
    accent: Color(0xFFEDF2F9),
    scaffoldBackground: Color(0xFFF3F6FA),
    surface: Color(0xFFF9FAFD),
    outline: Color(0xFFDFE6F2),
    glow: Color(0xFFC8D5EA),
    soundscapeAsset: 'assets/audio/music/so-20-dreamy-ethereal.m4a',
    soundscapeTitle: 'Dreamy Ethereal',
  ),
};

MoodThemeConfig moodConfigOf(SoulMood mood) =>
    moodThemeConfigs[mood] ?? moodThemeConfigs[SoulMood.peaceful]!;

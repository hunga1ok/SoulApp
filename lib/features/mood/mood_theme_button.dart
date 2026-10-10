import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../l10n/app_localizations.dart';
import 'mood_theme_switcher_sheet.dart';

/// Top bar button displaying the current mood emoji.
/// Positioned next to the volume button; tapping opens [MoodThemeSwitcherSheet].
class MoodThemeButton extends ConsumerWidget {
  const MoodThemeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(appStateProvider);
    final mood = state.currentMood;
    final config = moodConfigOf(mood);

    return IconButton(
      tooltip: l10n.moodThemeButtonTooltip,
      onPressed: () => MoodThemeSwitcherSheet.show(context),
      icon: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: config.accent,
          border: Border.all(
            color: config.primary.withValues(alpha: 0.35),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: config.primary.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(config.emoji, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}

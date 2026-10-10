import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../core/design_system/design_system.dart';
import '../../l10n/app_localizations.dart';

class MoodThemeSwitcherSheet extends ConsumerWidget {
  const MoodThemeSwitcherSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const MoodThemeSwitcherSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(appStateProvider);
    final activeMood = state.currentMood;

    return Padding(
      padding: EdgeInsets.only(
        left: SoulSpace.md,
        right: SoulSpace.md,
        top: SoulSpace.sm,
        bottom: MediaQuery.paddingOf(context).bottom + SoulSpace.md,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.moodThemeSheetTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: SoulColors.plum,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  tooltip: l10n.close,
                  icon: const Icon(
                    Icons.close_rounded,
                    color: SoulColors.muted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SoulSpace.xxs),
            Text(
              l10n.moodThemeSheetSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: SoulColors.muted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: SoulSpace.md),
            for (final mood in SoulMood.values) ...[
              _MoodOptionCard(
                mood: mood,
                isSelected: mood == activeMood,
                onTap: () async {
                  await state.saveSelectedMood(mood.id);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    final config = moodConfigOf(mood);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: SoulColors.plum,
                        content: Text(
                          l10n.moodThemeChangedToast(
                            config.localizedLabel(l10n),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        duration: const Duration(milliseconds: 2200),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: SoulSpace.xs),
            ],
          ],
        ),
      ),
    );
  }
}

class _MoodOptionCard extends StatelessWidget {
  const _MoodOptionCard({
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  final SoulMood mood;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final config = moodConfigOf(mood);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SoulRadius.row),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.symmetric(
          horizontal: SoulSpace.md,
          vertical: SoulSpace.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? config.accent : SoulColors.surface,
          borderRadius: BorderRadius.circular(SoulRadius.row),
          border: Border.all(
            color: isSelected ? config.primary : config.outline,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: config.primary.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                  : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: config.accent,
                border: Border.all(color: config.outline, width: 1),
              ),
              alignment: Alignment.center,
              child: Text(config.emoji, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: SoulSpace.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    config.localizedLabel(l10n),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: SoulColors.plum,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    config.localizedDesc(l10n),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: SoulColors.muted,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: SoulSpace.xs),
            // Palette preview dots
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ColorDot(color: config.primary),
                const SizedBox(width: 4),
                _ColorDot(color: config.accent),
                const SizedBox(width: 4),
                _ColorDot(color: config.scaffoldBackground),
              ],
            ),
            const SizedBox(width: SoulSpace.xs),
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: isSelected ? config.primary : SoulColors.muted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: SoulColors.line, width: 0.5),
      ),
    );
  }
}

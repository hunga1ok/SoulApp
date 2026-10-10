import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/audio/audio_playback_controller.dart';
import '../../core/design_system/design_system.dart';
import '../../data/content/audio_catalog.dart';
import '../../data/content/card_catalog.dart';
import '../../data/content/content_repository.dart';
import '../../data/repositories/card_draw_repository.dart';
import '../../data/repositories/gratitude_repository.dart';
import '../../l10n/app_localizations.dart';
import '../journal/journal_note_models.dart';
import '../profile/home_widget_screen.dart';
import '../vision/vision_controllers.dart';
import '../vision/vision_statement.dart';
import 'gratitude_practice_screen.dart';

class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  var _smallActionDone = false;
  String? _selectedMood;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(appStateProvider);
    final name = state.preferredName ?? '…';
    final soundEnabled = state.soundEnabled;
    final audio = ref.watch(audioPlaybackProvider);
    final track = ref.watch(audioCatalogProvider).valueOrNull?.asset('SO-11');
    final todayEntries =
        ref.watch(todayGratitudeEntriesProvider).valueOrNull ?? [];
    final activeVisions = ref.watch(visionsProvider).valueOrNull ?? [];
    final isGratitudeDone = todayEntries.isNotEmpty;
    final drawState = ref.watch(cardDrawProvider);
    final cardCatalog = ref.watch(cardCatalogProvider).valueOrNull;

    final currentDay = ref.watch(currentJourneyDayProvider).valueOrNull ?? 1;
    final dayTheme = JourneyDayThemes.getTitle(
      currentDay,
      state.locale ?? SoulLocale.vi,
    );

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        SoulSpace.lg,
        SoulSpace.sm,
        SoulSpace.lg,
        SoulSpace.xl,
      ),
      children: [
        // Greeting Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.welcome(name),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: SoulSpace.xxs),
                  Text(
                    l10n.todayGreeting,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: SoulColors.muted),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: SoulSpace.lg),

        // 1. Hero Journey Card: Day X of 28 (Widget Task hàng ngày)
        if (isGratitudeDone)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => GratitudePracticeScreen(dayNumber: currentDay),
                ),
              ).then((_) {
                ref.invalidate(currentJourneyDayProvider);
                ref.invalidate(todayGratitudeEntriesProvider);
                ref.invalidate(recentGratitudeEntriesProvider);
              });
            },
            borderRadius: BorderRadius.circular(SoulRadius.card),
            child: Container(
              decoration: BoxDecoration(
                color: SoulColors.surface,
                borderRadius: BorderRadius.circular(SoulRadius.card),
                border: Border.all(
                  color: SoulColors.lilac.withValues(alpha: 0.8),
                ),
                boxShadow: [
                  BoxShadow(
                    color: SoulColors.plum.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: SoulSpace.md,
                vertical: SoulSpace.sm + 4,
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: SoulColors.lilac,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: SoulColors.lilacStrong,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: SoulSpace.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: SoulSpace.xs + 2,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: SoulColors.softFill,
                                borderRadius: BorderRadius.circular(
                                  SoulRadius.button,
                                ),
                              ),
                              child: Text(
                                l10n.dayProgress(currentDay).toUpperCase(),
                                style: Theme.of(
                                  context,
                                ).textTheme.labelSmall?.copyWith(
                                  color: SoulColors.plum,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                l10n.todayPracticeCompleted,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(
                                  context,
                                ).textTheme.labelSmall?.copyWith(
                                  color: SoulColors.lilacStrong,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '$dayTheme · ${l10n.gratitudeCardTapToReview}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: SoulColors.plum,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: SoulSpace.xs),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: SoulColors.softInk,
                  ),
                ],
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: SoulColors.surface,
              borderRadius: BorderRadius.circular(SoulRadius.card),
              border: Border.all(color: SoulColors.line),
              boxShadow: [
                BoxShadow(
                  color: SoulColors.plum.withValues(alpha: 0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(SoulSpace.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SoulSpace.sm,
                    vertical: SoulSpace.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: SoulColors.lilac,
                    borderRadius: BorderRadius.circular(SoulRadius.button),
                  ),
                  child: MediaQuery.withClampedTextScaling(
                    maxScaleFactor: 1.3,
                    child: Text(
                      l10n.dayProgress(currentDay).toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: SoulColors.plum,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: SoulSpace.md),
                Text(
                  dayTheme,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: SoulSpace.xs),
                Text(
                  l10n.todayJourneyHeroSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: SoulColors.softInk.withValues(alpha: 0.8),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: SoulSpace.lg),
                SoulButton(
                  label: l10n.todayStartPractice,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                GratitudePracticeScreen(dayNumber: currentDay),
                      ),
                    ).then((_) {
                      ref.invalidate(currentJourneyDayProvider);
                      ref.invalidate(todayGratitudeEntriesProvider);
                      ref.invalidate(recentGratitudeEntriesProvider);
                    });
                  },
                ),
              ],
            ),
          ),
        const SizedBox(height: SoulSpace.md),

        // 2. Rút thẻ thông điệp (Soul Card Message) - Đưa lên ngay dưới widget task
        InkWell(
          onTap: () => context.go('/app/cards'),
          borderRadius: BorderRadius.circular(SoulRadius.card),
          child: SoulCard(
            color: SoulColors.surface,
            padding: const EdgeInsets.all(SoulSpace.md),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E5F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: SoulColors.plum,
                    size: 22,
                  ),
                ),
                const SizedBox(width: SoulSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.todayCardDrawBanner,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: SoulColors.muted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        drawState.todayEntries.isNotEmpty && cardCatalog != null
                            ? (() {
                              final latest = drawState.todayEntries.first;
                              final d = cardCatalog.deck(latest.deckId);
                              final c = d?.cards.firstWhere(
                                (item) => item.id == latest.cardId,
                                orElse: () => d.cards.first,
                              );
                              return c?.text ?? l10n.soulCardsSubtitle;
                            })()
                            : (drawState.canDraw
                                ? l10n.dailyDrawRemaining(
                                  drawState.remainingDraws,
                                )
                                : l10n.dailyDrawLimitReached),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: SoulColors.softInk,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: SoulSpace.xs),
                const Icon(Icons.chevron_right, color: SoulColors.muted),
              ],
            ),
          ),
        ),
        const SizedBox(height: SoulSpace.sm),

        // 3. Little Corner (Góc nhỏ) - Đưa lên trên hành động
        InkWell(
          onTap: () => context.push('/comfort-zone'),
          borderRadius: BorderRadius.circular(SoulRadius.card),
          child: SoulCard(
            color: SoulColors.surface,
            padding: const EdgeInsets.all(SoulSpace.md),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.cottage_rounded,
                    color: Color(0xFF2E7D32),
                    size: 22,
                  ),
                ),
                const SizedBox(width: SoulSpace.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.comfortZoneTitle,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: SoulColors.muted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.comfortZoneBannerSubtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: SoulColors.softInk,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: SoulSpace.xs),
                const Icon(Icons.chevron_right, color: SoulColors.muted),
              ],
            ),
          ),
        ),
        const SizedBox(height: SoulSpace.xl),

        // 4. Mood Check-in: Cảm xúc của bạn lúc này
        Text(
          l10n.moodCheckInTitle,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: SoulSpace.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _MoodChip(
                label: l10n.moodPeaceful,
                selected: _selectedMood == l10n.moodPeaceful,
                onTap: () => setState(() => _selectedMood = l10n.moodPeaceful),
              ),
              _MoodChip(
                label: l10n.moodGrateful,
                selected: _selectedMood == l10n.moodGrateful,
                onTap: () => setState(() => _selectedMood = l10n.moodGrateful),
              ),
              _MoodChip(
                label: l10n.moodEnergized,
                selected: _selectedMood == l10n.moodEnergized,
                onTap: () => setState(() => _selectedMood = l10n.moodEnergized),
              ),
              _MoodChip(
                label: l10n.moodRelieved,
                selected: _selectedMood == l10n.moodRelieved,
                onTap: () => setState(() => _selectedMood = l10n.moodRelieved),
              ),
              _MoodChip(
                label: l10n.moodReflective,
                selected: _selectedMood == l10n.moodReflective,
                onTap:
                    () => setState(() => _selectedMood = l10n.moodReflective),
              ),
            ],
          ),
        ),
        const SizedBox(height: SoulSpace.xl),

        // 5. Today's Rhythm Section (Hành động & Nhịp điệu hôm nay)
        Text(
          l10n.todayRhythm,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: SoulSpace.sm),

        // Morning Soundscape
        SoulAudioRow(
          title: l10n.morningGratitude,
          subtitle:
              track?.delivery == AudioDelivery.published
                  ? l10n.neutralInstrumentalFiveMinutes
                  : l10n.audioPending,
          isPlaying:
              audio.isPlaying &&
              audio.assetPath == 'assets/audio/music/so-11-warm-felt-piano.m4a',
          onPlayPause:
              soundEnabled && track?.delivery == AudioDelivery.published
                  ? () => ref
                      .read(audioPlaybackProvider)
                      .toggleAsset(
                        'assets/audio/music/so-11-warm-felt-piano.m4a',
                        title: l10n.morningGratitude,
                        subtitle: l10n.neutralInstrumentalFiveMinutes,
                      )
                  : null,
        ),
        const SizedBox(height: SoulSpace.sm),

        // One Small Action
        InkWell(
          onTap: () => setState(() => _smallActionDone = !_smallActionDone),
          borderRadius: BorderRadius.circular(SoulRadius.card),
          child: SoulCard(
            color: _smallActionDone ? SoulColors.lilac : SoulColors.surface,
            padding: const EdgeInsets.all(SoulSpace.md),
            child: Row(
              children: [
                Icon(
                  _smallActionDone
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color:
                      _smallActionDone
                          ? SoulColors.lilacStrong
                          : SoulColors.muted,
                ),
                const SizedBox(width: SoulSpace.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.oneSmallAction,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: SoulColors.muted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.smallActionText,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: SoulColors.softInk,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: SoulSpace.sm),

        // Evening Reflection Preview
        SoulCard(
          color: SoulColors.surface,
          padding: const EdgeInsets.all(SoulSpace.md),
          child: Row(
            children: [
              const Icon(
                Icons.nightlight_round,
                color: SoulColors.plum,
                size: 24,
              ),
              const SizedBox(width: SoulSpace.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.eveningReflectionTitle,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: SoulColors.muted,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.eveningReflectionBody,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: SoulColors.softInk,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: SoulSpace.sm),

        // 6. Home Screen Widget
        InkWell(
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HomeWidgetScreen()),
              ),
          borderRadius: BorderRadius.circular(SoulRadius.card),
          child: SoulCard(
            color: SoulColors.surface,
            padding: const EdgeInsets.all(SoulSpace.md),
            child: Row(
              children: [
                const Icon(
                  Icons.widgets_outlined,
                  color: SoulColors.plum,
                  size: 24,
                ),
                const SizedBox(width: SoulSpace.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.homeWidgetTitle,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: SoulColors.muted,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.homeWidgetBannerSubtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: SoulColors.softInk,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: SoulSpace.xs),
                const Icon(Icons.chevron_right, color: SoulColors.muted),
              ],
            ),
          ),
        ),
        const SizedBox(height: SoulSpace.xl),

        // Vision Spotlight
        Text(
          l10n.yourVisions,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: SoulSpace.sm),
        if (activeVisions.isNotEmpty)
          InkWell(
            onTap: () => context.go('/app/vision/${activeVisions.first.id}'),
            borderRadius: BorderRadius.circular(SoulRadius.card),
            child: SoulCard(
              color: SoulColors.surface,
              padding: const EdgeInsets.all(SoulSpace.md),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: SoulColors.plum,
                    size: 32,
                  ),
                  const SizedBox(width: SoulSpace.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          resolveVisionStatement(
                            vision: activeVisions.first,
                            catalog:
                                ref
                                    .watch(activeVisionCatalogProvider)
                                    .valueOrNull,
                            locale: state.locale ?? SoulLocale.vi,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.visionSoundtrack,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: SoulColors.muted),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: SoulColors.muted,
                  ),
                ],
              ),
            ),
          )
        else
          SoulCard(
            color: SoulColors.surface,
            padding: const EdgeInsets.all(SoulSpace.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.spa_outlined,
                      color: SoulColors.muted,
                      size: 28,
                    ),
                    const SizedBox(width: SoulSpace.sm),
                    Expanded(
                      child: Text(
                        l10n.visionEmptyTitle,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SoulSpace.xs),
                Text(
                  l10n.visionEmptyBody,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: SoulColors.muted),
                ),
                const SizedBox(height: SoulSpace.sm),
                SoulButton(
                  label: l10n.createVision,
                  variant: SoulButtonVariant.secondary,
                  onPressed: () => context.go('/app/vision'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _MoodChip extends StatelessWidget {
  const _MoodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: SoulSpace.xs),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: SoulColors.lilac,
        checkmarkColor: SoulColors.plum,
        backgroundColor: SoulColors.surface,
        side: BorderSide(color: selected ? SoulColors.plum : SoulColors.line),
        labelStyle: TextStyle(
          color: selected ? SoulColors.plum : SoulColors.softInk,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}

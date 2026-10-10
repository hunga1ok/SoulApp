import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/audio/audio_playback_controller.dart';
import '../../core/design_system/design_system.dart';
import '../../core/platform/home_widget_service.dart';
import '../../data/content/audio_catalog.dart';
import '../../data/content/comfort_zone_catalog.dart';
import '../../data/content/content_repository.dart';
import '../../data/repositories/comfort_zone_repository.dart';
import '../../l10n/app_localizations.dart';
import '../profile/home_widget_screen.dart';
import 'comfort_scene_canvas.dart';

class ComfortZoneHubScreen extends ConsumerStatefulWidget {
  const ComfortZoneHubScreen({super.key});

  @override
  ConsumerState<ComfortZoneHubScreen> createState() =>
      _ComfortZoneHubScreenState();
}

class _ComfortZoneHubScreenState extends ConsumerState<ComfortZoneHubScreen> {
  static const _filterAll = 'all';
  static const _filterFavorites = 'favorites';

  String _selectedFilter = _filterAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(appStateProvider);
    final locale = state.locale ?? SoulLocale.vi;
    final audio = ref.watch(audioPlaybackProvider);
    final audioCatalog = ref.watch(audioCatalogProvider).valueOrNull;
    final catalogAsync = ref.watch(comfortZoneCatalogProvider);
    final prefsState = ref.watch(comfortZonePreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.comfortZoneTitle,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            tooltip: l10n.homeWidgetTitle,
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => const HomeWidgetScreen(
                          initialMode: HomeWidgetMode.comfortZone,
                        ),
                  ),
                ),
            icon: const Icon(Icons.widgets_outlined),
          ),
          IconButton(
            tooltip: state.soundEnabled ? l10n.soundOn : l10n.soundOff,
            onPressed: () async {
              final enabled = !state.soundEnabled;
              await state.setSoundEnabled(enabled);
              if (!enabled) await ref.read(audioPlaybackProvider).stop();
            },
            icon: Icon(
              state.soundEnabled
                  ? Icons.volume_up_outlined
                  : Icons.volume_off_outlined,
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SafeArea(top: false, child: SoulMiniPlayer()),
      body: catalogAsync.when(
        loading: () => const SoulLoadingState(),
        error:
            (err, _) => SoulErrorState(
              message: l10n.somethingWentWrong,
              onRetry: () => ref.invalidate(comfortZoneCatalogProvider),
            ),
        data: (catalog) {
          final lastVisited =
              prefsState.lastVisitedSceneId != null
                  ? catalog.scene(prefsState.lastVisitedSceneId!)
                  : null;

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              SoulSpace.lg,
              SoulSpace.xs,
              SoulSpace.lg,
              SoulSpace.xl,
            ),
            children: [
              Text(
                l10n.comfortZoneSubtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: SoulColors.softInk),
              ),
              const SizedBox(height: SoulSpace.md),

              // Quick return to recently visited space
              if (lastVisited != null && _selectedFilter == _filterAll) ...[
                _buildRecentSpaceBanner(context, l10n, lastVisited),
                const SizedBox(height: SoulSpace.md),
              ],

              // Category Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChipItem(
                      label: l10n.comfortZoneAllSpaces(catalog.scenes.length),
                      selected: _selectedFilter == _filterAll,
                      onTap: () => setState(() => _selectedFilter = _filterAll),
                    ),
                    _FilterChipItem(
                      label:
                          '❤️ ${l10n.comfortZoneFavorites}${prefsState.favoriteSceneIds.isNotEmpty ? ' (${prefsState.favoriteSceneIds.length})' : ''}',
                      selected: _selectedFilter == _filterFavorites,
                      onTap:
                          () => setState(
                            () => _selectedFilter = _filterFavorites,
                          ),
                    ),
                    for (final category in catalog.categories)
                      _FilterChipItem(
                        label:
                            '${category.icon} ${category.number}. ${category.title}',
                        selected: _selectedFilter == category.id,
                        onTap:
                            () => setState(() => _selectedFilter = category.id),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: SoulSpace.lg),

              // Content sections based on selected filter
              if (_selectedFilter == _filterFavorites) ...[
                if (prefsState.favoriteSceneIds.isEmpty)
                  SoulEmptyState(
                    title: l10n.comfortZoneFavorites,
                    message: l10n.comfortZoneFavoritesEmpty,
                    icon: Icons.favorite_border_rounded,
                  )
                else
                  for (final scene in catalog.scenes.where(
                    (s) => prefsState.isFavorite(s.id),
                  )) ...[
                    _ComfortSceneCard(
                      scene: scene,
                      category: catalog.category(scene.categoryId),
                      isFavorite: true,
                      locale: locale,
                      audio: audio,
                      audioCatalog: audioCatalog,
                      soundEnabled: state.soundEnabled,
                      onToggleFavorite:
                          () => ref
                              .read(comfortZonePreferencesProvider.notifier)
                              .toggleFavorite(scene.id),
                      onOpenRoom:
                          () => context.push('/comfort-zone/${scene.id}'),
                      onTogglePlay:
                          () => _toggleSceneAudio(
                            scene,
                            locale,
                            audioCatalog,
                            audio,
                            state,
                          ),
                    ),
                    const SizedBox(height: SoulSpace.md),
                  ],
              ] else ...[
                for (final category in catalog.categories)
                  if (_selectedFilter == _filterAll ||
                      _selectedFilter == category.id) ...[
                    _buildCategoryHeader(
                      context,
                      l10n,
                      category,
                      catalog.scenesForCategory(category.id).length,
                    ),
                    const SizedBox(height: SoulSpace.sm),
                    for (final scene in catalog.scenesForCategory(
                      category.id,
                    )) ...[
                      _ComfortSceneCard(
                        scene: scene,
                        category: category,
                        isFavorite: prefsState.isFavorite(scene.id),
                        locale: locale,
                        audio: audio,
                        audioCatalog: audioCatalog,
                        soundEnabled: state.soundEnabled,
                        onToggleFavorite:
                            () => ref
                                .read(comfortZonePreferencesProvider.notifier)
                                .toggleFavorite(scene.id),
                        onOpenRoom:
                            () => context.push('/comfort-zone/${scene.id}'),
                        onTogglePlay:
                            () => _toggleSceneAudio(
                              scene,
                              locale,
                              audioCatalog,
                              audio,
                              state,
                            ),
                      ),
                      const SizedBox(height: SoulSpace.md),
                    ],
                    const SizedBox(height: SoulSpace.md),
                  ],
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _toggleSceneAudio(
    ComfortZoneScene scene,
    SoulLocale locale,
    AudioCatalog? audioCatalog,
    AudioPlaybackController audio,
    AppState state,
  ) async {
    final asset = audioCatalog?.asset(scene.primarySoundId);
    final path = asset?.pathFor(locale);
    if (asset == null || path == null) return;

    if (!state.soundEnabled) {
      await state.setSoundEnabled(true);
    }
    await ref
        .read(comfortZonePreferencesProvider.notifier)
        .markVisited(scene.id);
    await audio.playTrack(
      path: path,
      title: '${scene.numberBadge}. ${scene.localizedTitle}',
      subtitle: asset.displayLabelFor(locale),
      isAsset: true,
      loop: true,
    );
  }

  Widget _buildRecentSpaceBanner(
    BuildContext context,
    AppLocalizations l10n,
    ComfortZoneScene scene,
  ) {
    return InkWell(
      onTap: () => context.push('/comfort-zone/${scene.id}'),
      borderRadius: BorderRadius.circular(SoulRadius.card),
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SoulRadius.card),
          border: Border.all(color: SoulColors.line),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ComfortSceneCanvas(scene: scene, isPlaying: false),
            Container(
              color: Colors.black.withValues(alpha: 0.32),
              padding: const EdgeInsets.symmetric(
                horizontal: SoulSpace.md,
                vertical: SoulSpace.sm,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SoulSpace.xs,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(SoulRadius.button),
                    ),
                    child: Text(
                      scene.numberBadge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: SoulSpace.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.comfortZoneRecentSpace.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          scene.bilingualSubheader,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryHeader(
    BuildContext context,
    AppLocalizations l10n,
    ComfortZoneCategory category,
    int count,
  ) {
    return Container(
      padding: const EdgeInsets.all(SoulSpace.md),
      decoration: BoxDecoration(
        color: SoulColors.softFill,
        borderRadius: BorderRadius.circular(SoulRadius.card),
        border: Border.all(color: SoulColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(category.icon, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: SoulSpace.xs),
              Expanded(
                child: Text(
                  '${category.number}. ${category.title}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: SoulColors.plum,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SoulSpace.xs,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: SoulColors.surface,
                  borderRadius: BorderRadius.circular(SoulRadius.button),
                ),
                child: Text(
                  l10n.comfortZoneScenesCount(count),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: SoulColors.plum,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            category.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: SoulColors.softInk,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ComfortSceneCard extends StatelessWidget {
  const _ComfortSceneCard({
    required this.scene,
    required this.category,
    required this.isFavorite,
    required this.locale,
    required this.audio,
    required this.audioCatalog,
    required this.soundEnabled,
    required this.onToggleFavorite,
    required this.onOpenRoom,
    required this.onTogglePlay,
  });

  final ComfortZoneScene scene;
  final ComfortZoneCategory? category;
  final bool isFavorite;
  final SoulLocale locale;
  final AudioPlaybackController audio;
  final AudioCatalog? audioCatalog;
  final bool soundEnabled;
  final VoidCallback onToggleFavorite;
  final VoidCallback onOpenRoom;
  final VoidCallback onTogglePlay;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryAsset = audioCatalog?.asset(scene.primarySoundId);
    final guidedAsset = audioCatalog?.asset(scene.guidedAudioId);
    final primaryPath = primaryAsset?.pathFor(locale);
    final guidedPath = guidedAsset?.pathFor(locale);

    final isScenePlaying =
        audio.isPlaying &&
        ((primaryPath != null && audio.assetPath == primaryPath) ||
            (guidedPath != null && audio.assetPath == guidedPath));

    return InkWell(
      onTap: onOpenRoom,
      borderRadius: BorderRadius.circular(SoulRadius.card),
      child: Container(
        decoration: BoxDecoration(
          color: SoulColors.surface,
          borderRadius: BorderRadius.circular(SoulRadius.card),
          border: Border.all(
            color: isScenePlaying ? SoulColors.plum : SoulColors.line,
            width: isScenePlaying ? 1.5 : 1.0,
          ),
          boxShadow: SoulShadows.card,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Animated scene illustration header
            SizedBox(
              height: 196,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ComfortSceneCanvas(scene: scene, isPlaying: true),
                  // Top row: Number badge + Category tag + Favorite button
                  Positioned(
                    top: SoulSpace.xs,
                    left: SoulSpace.sm,
                    right: SoulSpace.xs,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: SoulSpace.sm,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(
                              SoulRadius.button,
                            ),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.28),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                scene.numberBadge,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12,
                                  letterSpacing: 0.6,
                                ),
                              ),
                              if (category != null) ...[
                                const SizedBox(width: 6),
                                Text(
                                  category!.icon,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (isScenePlaying)
                          Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.45),
                              borderRadius: BorderRadius.circular(
                                SoulRadius.button,
                              ),
                            ),
                            child: const SoulAudioWave(
                              isPlaying: true,
                              barColor: Colors.white,
                              height: 13,
                            ),
                          ),
                        IconButton(
                          tooltip: l10n.comfortZoneFavorites,
                          onPressed: onToggleFavorite,
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color:
                                isFavorite
                                    ? const Color(0xFFFF6B8B)
                                    : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom title overlay on canvas
                  Positioned(
                    left: SoulSpace.md,
                    right: SoulSpace.md,
                    bottom: SoulSpace.sm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          scene.bilingualSubheader,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            shadows: const [
                              Shadow(color: Color(0xAA000000), blurRadius: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Healing message + Audio badges + Enter CTA
            Padding(
              padding: const EdgeInsets.all(SoulSpace.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '“${scene.affirmation}”',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: SoulColors.plum,
                      fontStyle: FontStyle.italic,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: SoulSpace.sm),

                  // Sound & Audio row: Play button + Music/Frequency track aligned horizontally
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SoulSpace.sm,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isScenePlaying
                              ? SoulColors.lilac.withValues(alpha: 0.65)
                              : SoulColors.softFill,
                      borderRadius: BorderRadius.circular(SoulRadius.button),
                      border: Border.all(
                        color:
                            isScenePlaying
                                ? SoulColors.plum.withValues(alpha: 0.35)
                                : SoulColors.line,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Compact circular Play/Pause button
                        InkWell(
                          onTap: onTogglePlay,
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color:
                                  isScenePlaying
                                      ? SoulColors.plum
                                      : SoulColors.surface,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    isScenePlaying
                                        ? Colors.transparent
                                        : SoulColors.line,
                              ),
                              boxShadow: [
                                if (isScenePlaying)
                                  BoxShadow(
                                    color: SoulColors.plum.withValues(
                                      alpha: 0.25,
                                    ),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                              ],
                            ),
                            child: Icon(
                              isScenePlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 19,
                              color:
                                  isScenePlaying
                                      ? Colors.white
                                      : SoulColors.plum,
                            ),
                          ),
                        ),
                        const SizedBox(width: SoulSpace.sm),
                        // Track title & frequency info (aligned horizontally with play button)
                        Expanded(
                          child: InkWell(
                            onTap: onTogglePlay,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.music_note_rounded,
                                      size: 13,
                                      color: SoulColors.plum,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        primaryAsset != null
                                            ? primaryAsset.displayLabelFor(
                                              locale,
                                            )
                                            : l10n.comfortZoneAmbientSound,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: SoulColors.plum,
                                        ),
                                      ),
                                    ),
                                    if (isScenePlaying) ...[
                                      const SizedBox(width: 6),
                                      const SoulAudioWave(
                                        isPlaying: true,
                                        barColor: SoulColors.plum,
                                        height: 12,
                                      ),
                                    ],
                                  ],
                                ),
                                if (guidedAsset != null) ...[
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.record_voice_over_rounded,
                                        size: 11,
                                        color: SoulColors.softInk,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          guidedAsset.titleFor(locale),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.labelSmall?.copyWith(
                                            color: SoulColors.softInk,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: SoulSpace.xs),

                  // Enter space CTA row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        l10n.comfortZoneEnterSpace,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: SoulColors.plum,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: SoulColors.plum,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  const _FilterChipItem({
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
          fontWeight: selected ? FontWeight.w700 : FontWeight.normal,
        ),
      ),
    );
  }
}

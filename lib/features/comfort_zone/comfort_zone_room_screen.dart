import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class ComfortZoneRoomScreen extends ConsumerStatefulWidget {
  const ComfortZoneRoomScreen({super.key, required this.sceneId});

  final String sceneId;

  @override
  ConsumerState<ComfortZoneRoomScreen> createState() =>
      _ComfortZoneRoomScreenState();
}

class _ComfortZoneRoomScreenState extends ConsumerState<ComfortZoneRoomScreen> {
  late String _activeSceneId;
  bool _zenMode = false;
  bool _showBreathingGuide = false;
  int _breathingPhase = 0; // 0: inhale, 1: hold, 2: exhale
  Timer? _breathingTimer;

  bool get _isTest {
    return WidgetsBinding.instance.runtimeType.toString().contains(
      'TestWidgetsFlutterBinding',
    );
  }

  @override
  void initState() {
    super.initState();
    _activeSceneId = widget.sceneId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onEnterScene(_activeSceneId, autoPlayIfSilent: true);
    });
  }

  @override
  void dispose() {
    _breathingTimer?.cancel();
    super.dispose();
  }

  void _toggleBreathingGuide() {
    setState(() {
      _showBreathingGuide = !_showBreathingGuide;
      _breathingPhase = 0;
    });
    _breathingTimer?.cancel();
    if (_showBreathingGuide && !_isTest) {
      _breathingTimer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (!mounted) return;
        setState(() {
          _breathingPhase = (_breathingPhase + 1) % 3;
        });
      });
    }
  }

  Future<void> _onEnterScene(
    String sceneId, {
    bool autoPlayIfSilent = false,
  }) async {
    if (!mounted) return;
    await ref
        .read(comfortZonePreferencesProvider.notifier)
        .markVisited(sceneId);

    if (!autoPlayIfSilent) return;
    final state = ref.read(appStateProvider);
    if (!state.soundEnabled) return;

    final catalog = await ref.read(comfortZoneCatalogProvider.future);
    final scene = catalog.scene(sceneId);
    if (scene == null || !mounted) return;

    final audioCatalog = await ref.read(audioCatalogProvider.future);
    if (!mounted) return;
    final locale = state.locale ?? SoulLocale.vi;
    final primaryAsset = audioCatalog.asset(scene.primarySoundId);
    final path = primaryAsset?.pathFor(locale);
    if (primaryAsset == null || path == null) return;

    final audio = ref.read(audioPlaybackProvider);
    if (!audio.isCurrentTrack(path)) {
      await audio.playTrack(
        path: path,
        title: '${scene.numberBadge}. ${scene.localizedTitle}',
        subtitle: primaryAsset.displayLabelFor(locale),
        isAsset: true,
        loop: true,
      );
    }
  }

  Future<void> _switchScene(
    ComfortZoneScene target,
    SoulLocale locale,
    AudioCatalog? audioCatalog,
  ) async {
    setState(() {
      _activeSceneId = target.id;
    });
    await ref
        .read(comfortZonePreferencesProvider.notifier)
        .markVisited(target.id);

    final state = ref.read(appStateProvider);
    if (!state.soundEnabled) return;

    final primaryAsset = audioCatalog?.asset(target.primarySoundId);
    final path = primaryAsset?.pathFor(locale);
    if (primaryAsset != null && path != null) {
      await ref
          .read(audioPlaybackProvider)
          .playTrack(
            path: path,
            title: '${target.numberBadge}. ${target.localizedTitle}',
            subtitle: primaryAsset.displayLabelFor(locale),
            isAsset: true,
            loop: true,
          );
    }
  }

  Future<void> _playAssetForScene(
    ComfortZoneScene scene,
    SoulAudioAsset asset,
    SoulLocale locale,
  ) async {
    final path = asset.pathFor(locale);
    if (path == null) return;

    final state = ref.read(appStateProvider);
    if (!state.soundEnabled) {
      await state.setSoundEnabled(true);
    }
    await ref
        .read(audioPlaybackProvider)
        .playTrack(
          path: path,
          title: '${scene.numberBadge}. ${scene.localizedTitle}',
          subtitle: asset.displayLabelFor(locale),
          isAsset: true,
          loop: !asset.isGuided,
        );
  }

  String _breathingText(AppLocalizations l10n) {
    switch (_breathingPhase) {
      case 0:
        return l10n.comfortZoneBreatheIn;
      case 1:
        return l10n.comfortZoneBreatheHold;
      case 2:
      default:
        return l10n.comfortZoneBreatheOut;
    }
  }

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
      backgroundColor: Colors.black,
      body: catalogAsync.when(
        loading: () => const SoulLoadingState(),
        error:
            (err, _) => SoulErrorState(
              message: l10n.somethingWentWrong,
              onRetry: () => ref.invalidate(comfortZoneCatalogProvider),
            ),
        data: (catalog) {
          final scene = catalog.scene(_activeSceneId) ?? catalog.scenes.first;
          final category = catalog.category(scene.categoryId);
          final isFavorite = prefsState.isFavorite(scene.id);

          final sceneIndex = catalog.scenes.indexOf(scene);
          final prevScene =
              catalog.scenes[(sceneIndex - 1 + catalog.scenes.length) %
                  catalog.scenes.length];
          final nextScene =
              catalog.scenes[(sceneIndex + 1) % catalog.scenes.length];

          final soundAssets = [
            for (final id in scene.soundIds)
              if (audioCatalog?.asset(id) case final item?
                  when item.delivery == AudioDelivery.published)
                item,
          ];
          final guidedAsset = audioCatalog?.asset(scene.guidedAudioId);
          final primaryAsset =
              soundAssets.firstOrNull ??
              audioCatalog?.asset(scene.primarySoundId);

          final allAudioAssets = <SoulAudioAsset>[
            ...soundAssets,
            if (guidedAsset != null &&
                guidedAsset.delivery == AudioDelivery.published &&
                !soundAssets.any((s) => s.id == guidedAsset.id))
              guidedAsset,
          ];
          final activeAsset =
              allAudioAssets.where((asset) {
                final p = asset.pathFor(locale);
                return p != null && audio.isCurrentTrack(p);
              }).firstOrNull ??
              primaryAsset ??
              allAudioAssets.firstOrNull;

          return Stack(
            fit: StackFit.expand,
            children: [
              // 1. Full-screen animated illustration canvas (edge-to-edge)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _zenMode = !_zenMode),
                  child: ComfortSceneCanvas(scene: scene, isPlaying: true),
                ),
              ),

              // 2. SafeArea overlay for Top Bar, Breathing Orb, and Compact Bottom Card
              SafeArea(
                child: Column(
                  children: [
                    // Top Action Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SoulSpace.sm,
                        vertical: SoulSpace.xs,
                      ),
                      child: Row(
                        children: [
                          _GlassIconButton(
                            icon: Icons.arrow_back_rounded,
                            tooltip: l10n.back,
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                          const SizedBox(width: SoulSpace.xs),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: SoulSpace.sm,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.38),
                                borderRadius: BorderRadius.circular(
                                  SoulRadius.button,
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.24),
                                ),
                              ),
                              child: Text(
                                '${scene.numberBadge} · ${category?.title ?? l10n.comfortZoneTitle}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: Theme.of(
                                  context,
                                ).textTheme.labelMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: SoulSpace.xs),
                          _GlassIconButton(
                            icon:
                                isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                            iconColor:
                                isFavorite
                                    ? const Color(0xFFFF6B8B)
                                    : Colors.white,
                            tooltip: l10n.comfortZoneFavorites,
                            onPressed:
                                () => ref
                                    .read(
                                      comfortZonePreferencesProvider.notifier,
                                    )
                                    .toggleFavorite(scene.id),
                          ),
                          const SizedBox(width: 6),
                          _GlassIconButton(
                            icon: Icons.air_rounded,
                            iconColor:
                                _showBreathingGuide
                                    ? const Color(0xFFFFE082)
                                    : Colors.white,
                            tooltip: l10n.comfortZoneBreathingGuide,
                            onPressed: _toggleBreathingGuide,
                          ),
                          const SizedBox(width: 6),
                          _GlassIconButton(
                            icon: Icons.widgets_outlined,
                            tooltip: l10n.homeWidgetTitle,
                            onPressed:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => HomeWidgetScreen(
                                          initialMode:
                                              HomeWidgetMode.comfortZone,
                                          initialSceneId: scene.id,
                                          initialSoundId: activeAsset?.id,
                                        ),
                                  ),
                                ),
                          ),
                          const SizedBox(width: 6),
                          _GlassIconButton(
                            icon:
                                _zenMode
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                            tooltip:
                                _zenMode
                                    ? l10n.comfortZoneExitZenMode
                                    : l10n.comfortZoneZenMode,
                            onPressed:
                                () => setState(() => _zenMode = !_zenMode),
                          ),
                        ],
                      ),
                    ),

                    // Center Breathing Guide or Zen Affirmation
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => setState(() => _zenMode = !_zenMode),
                        child: Center(
                          child:
                              _showBreathingGuide
                                  ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SoulBreathingOrb(
                                        isPlaying: true,
                                        size: 132,
                                        child: const Center(
                                          child: Icon(
                                            Icons.self_improvement_rounded,
                                            color: Colors.white,
                                            size: 42,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: SoulSpace.sm),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: SoulSpace.md,
                                          vertical: SoulSpace.xs,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(
                                            alpha: 0.45,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            SoulRadius.button,
                                          ),
                                        ),
                                        child: Text(
                                          _breathingText(l10n),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                  : _zenMode
                                  ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: SoulSpace.xl,
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(
                                        SoulSpace.md,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(
                                          alpha: 0.36,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          SoulRadius.card,
                                        ),
                                      ),
                                      child: Text(
                                        '“${scene.affirmation}”',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium?.copyWith(
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                          height: 1.45,
                                        ),
                                      ),
                                    ),
                                  )
                                  : const SizedBox.expand(),
                        ),
                      ),
                    ),

                    // Compact Bottom Sanctuary Dock (Hidden in Zen Mode)
                    if (!_zenMode)
                      Container(
                        margin: const EdgeInsets.fromLTRB(
                          SoulSpace.sm,
                          0,
                          SoulSpace.sm,
                          SoulSpace.xs,
                        ),
                        padding: const EdgeInsets.fromLTRB(
                          SoulSpace.md,
                          SoulSpace.sm,
                          SoulSpace.sm,
                          SoulSpace.xs,
                        ),
                        decoration: BoxDecoration(
                          color: SoulColors.surface.withValues(alpha: 0.90),
                          borderRadius: BorderRadius.circular(SoulRadius.card),
                          border: Border.all(color: SoulColors.line),
                          boxShadow: SoulShadows.card,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Scene Title & Healing Message
                            Text(
                              scene.bilingualSubheader,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(
                                context,
                              ).textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: SoulColors.plum,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '“${scene.affirmation}”',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(
                                color: SoulColors.softInk,
                                fontStyle: FontStyle.italic,
                                height: 1.38,
                              ),
                            ),
                            const SizedBox(height: SoulSpace.xs),

                            // Single compact row: Audio Dropdown + Icon-only Transport Bar
                            Row(
                              children: [
                                if (allAudioAssets.isNotEmpty)
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: SoulSpace.sm,
                                      ),
                                      decoration: BoxDecoration(
                                        color: SoulColors.softFill,
                                        borderRadius: BorderRadius.circular(
                                          SoulRadius.button,
                                        ),
                                        border: Border.all(
                                          color: SoulColors.line,
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: activeAsset?.id,
                                          isExpanded: true,
                                          isDense: true,
                                          borderRadius: BorderRadius.circular(
                                            SoulRadius.card,
                                          ),
                                          dropdownColor: SoulColors.surface,
                                          icon: const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: SoulColors.plum,
                                            size: 20,
                                          ),
                                          onChanged: (selectedId) {
                                            if (selectedId == null) return;
                                            final chosen =
                                                allAudioAssets
                                                    .where(
                                                      (a) => a.id == selectedId,
                                                    )
                                                    .firstOrNull;
                                            if (chosen != null) {
                                              _playAssetForScene(
                                                scene,
                                                chosen,
                                                locale,
                                              );
                                            }
                                          },
                                          items: [
                                            for (final item in allAudioAssets)
                                              DropdownMenuItem<String>(
                                                value: item.id,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      item.isGuided
                                                          ? Icons
                                                              .record_voice_over_rounded
                                                          : item.type == 'music'
                                                          ? Icons
                                                              .music_note_rounded
                                                          : Icons
                                                              .water_drop_rounded,
                                                      size: 16,
                                                      color: SoulColors.plum,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        item.displayLabelFor(
                                                          locale,
                                                        ),
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelMedium
                                                            ?.copyWith(
                                                              color:
                                                                  SoulColors
                                                                      .plum,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                      ),
                                                    ),
                                                    if (item.pathFor(locale) !=
                                                            null &&
                                                        audio.isCurrentTrack(
                                                          item.pathFor(locale)!,
                                                        ) &&
                                                        audio.isPlaying)
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                              left: 6,
                                                            ),
                                                        child: SoulAudioWave(
                                                          isPlaying: true,
                                                          barColor:
                                                              SoulColors.plum,
                                                          height: 11,
                                                          barCount: 3,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                const SizedBox(width: 4),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  tooltip: l10n.comfortZonePreviousSpace,
                                  onPressed:
                                      () => _switchScene(
                                        prevScene,
                                        locale,
                                        audioCatalog,
                                      ),
                                  icon: const Icon(
                                    Icons.skip_previous_rounded,
                                    color: SoulColors.plum,
                                    size: 24,
                                  ),
                                ),
                                IconButton.filled(
                                  tooltip:
                                      audio.isPlaying ? l10n.pause : l10n.play,
                                  style: IconButton.styleFrom(
                                    backgroundColor: SoulColors.plum,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(42, 42),
                                  ),
                                  onPressed: () async {
                                    if (audio.hasTrack) {
                                      await audio.togglePlayPause();
                                    } else if (activeAsset != null) {
                                      await _playAssetForScene(
                                        scene,
                                        activeAsset,
                                        locale,
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    audio.isPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    size: 22,
                                  ),
                                ),
                                IconButton(
                                  visualDensity: VisualDensity.compact,
                                  tooltip: l10n.comfortZoneNextSpace,
                                  onPressed:
                                      () => _switchScene(
                                        nextScene,
                                        locale,
                                        audioCatalog,
                                      ),
                                  icon: const Icon(
                                    Icons.skip_next_rounded,
                                    color: SoulColors.plum,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.iconColor = Colors.white,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.38),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
      ),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}

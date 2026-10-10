import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../core/audio/audio_playback_controller.dart';
import '../../core/design_system/design_system.dart';
import '../../core/platform/home_widget_service.dart';
import '../../data/content/audio_catalog.dart';
import '../../data/content/card_catalog.dart';
import '../../data/content/comfort_zone_catalog.dart';
import '../../data/content/content_repository.dart';
import '../../data/repositories/card_draw_repository.dart';
import '../../l10n/app_localizations.dart';
import '../comfort_zone/comfort_scene_canvas.dart';
import '../vision/vision_controllers.dart';
import '../vision/vision_statement.dart';

class HomeWidgetScreen extends ConsumerStatefulWidget {
  const HomeWidgetScreen({
    super.key,
    this.initialMode,
    this.initialSceneId,
    this.initialSoundId,
  });

  final HomeWidgetMode? initialMode;
  final String? initialSceneId;
  final String? initialSoundId;

  @override
  ConsumerState<HomeWidgetScreen> createState() => _HomeWidgetScreenState();
}

class _HomeWidgetScreenState extends ConsumerState<HomeWidgetScreen> {
  late HomeWidgetMode _mode;
  late HomeWidgetTheme _theme;
  String? _selectedSceneId;
  String? _selectedSoundId;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    final service = ref.read(homeWidgetServiceProvider);
    _mode = widget.initialMode ?? service.mode;
    _theme = service.theme;
    _selectedSceneId = widget.initialSceneId ?? service.sceneId;
    _selectedSoundId = widget.initialSoundId ?? service.soundId;
  }

  HomeWidgetPayload _buildPayload(AppLocalizations l10n) {
    final state = ref.read(appStateProvider);
    final locale = state.locale ?? SoulLocale.vi;
    final name = state.preferredName?.trim();
    final defaultTitle =
        (name != null && name.isNotEmpty)
            ? l10n.welcome(name)
            : l10n.comfortZoneSubtitle;
    final visions = ref.read(visionsProvider).valueOrNull ?? const [];
    final visionCatalog = ref.read(activeVisionCatalogProvider).valueOrNull;
    final drawState = ref.read(cardDrawProvider);
    final cardCatalog = ref.read(cardCatalogProvider).valueOrNull;
    final czCatalog = ref.read(comfortZoneCatalogProvider).valueOrNull;
    final audioCatalog = ref.read(audioCatalogProvider).valueOrNull;

    final scenes = czCatalog?.scenes ?? const <ComfortZoneScene>[];
    final selectedScene =
        scenes.isEmpty
            ? null
            : scenes.firstWhere(
              (s) => s.id == _selectedSceneId,
              orElse: () => scenes.first,
            );

    final soundAssets = [
      for (final asset in audioCatalog?.assets ?? const <SoulAudioAsset>[])
        if (!asset.isGuided && asset.delivery == AudioDelivery.published) asset,
    ];
    final selectedSound =
        soundAssets.isEmpty
            ? null
            : soundAssets.firstWhere(
              (a) => a.id == _selectedSoundId,
              orElse: () => soundAssets.first,
            );

    final primarySoundAsset =
        selectedScene != null
            ? audioCatalog?.asset(selectedScene.primarySoundId)
            : null;

    final (musicTrack, frequency) = switch (_mode) {
      HomeWidgetMode.comfortZone => (
        primarySoundAsset?.displayLabelFor(locale),
        primarySoundAsset?.frequency,
      ),
      HomeWidgetMode.sound => (
        selectedSound?.displayLabelFor(locale),
        selectedSound?.frequency,
      ),
      _ => (null, null),
    };

    final badge = switch (_mode) {
      HomeWidgetMode.comfortZone =>
        'SOUL • ${l10n.homeWidgetModeComfortZone.toUpperCase()}',
      HomeWidgetMode.sound =>
        'SOUL • ${l10n.homeWidgetModeSound.toUpperCase()}',
      HomeWidgetMode.vision =>
        'SOUL • ${l10n.homeWidgetModeVision.toUpperCase()}',
      HomeWidgetMode.gratitude =>
        'SOUL • ${l10n.homeWidgetModeGratitude.toUpperCase()}',
      HomeWidgetMode.card => 'SOUL • ${l10n.homeWidgetModeCard.toUpperCase()}',
    };

    final displayTitle = switch (_mode) {
      HomeWidgetMode.comfortZone =>
        selectedScene != null
            ? '${selectedScene.numberBadge} • ${selectedScene.localizedTitle}'
            : defaultTitle,
      HomeWidgetMode.sound =>
        selectedSound != null
            ? selectedSound.displayLabelFor(locale)
            : defaultTitle,
      _ => defaultTitle,
    };

    final body = switch (_mode) {
      HomeWidgetMode.comfortZone =>
        selectedScene != null
            ? '“${selectedScene.affirmation}”'
            : l10n.comfortZoneBannerSubtitle,
      HomeWidgetMode.sound =>
        selectedSound != null
            ? selectedSound.subtitleFor(locale)
            : l10n.comfortZoneAmbientSound,
      HomeWidgetMode.vision =>
        visions.isNotEmpty
            ? (visionCatalog != null
                    ? resolveVisionStatement(
                      vision: visions.first,
                      catalog: visionCatalog,
                      locale: locale,
                    )
                    : cleanVisionStatement(visions.first.statement))
                .replaceAll('\n\n', ' • ')
            : l10n.visionEmptyBody,
      HomeWidgetMode.gratitude => l10n.notificationMorningBody,
      HomeWidgetMode.card =>
        (() {
          if (drawState.todayEntries.isNotEmpty && cardCatalog != null) {
            final latest = drawState.todayEntries.first;
            final deck = cardCatalog.deck(latest.deckId);
            if (deck != null && deck.cards.isNotEmpty) {
              final card = deck.cards.firstWhere(
                (item) => item.id == latest.cardId,
                orElse: () => deck.cards.first,
              );
              return card.text;
            }
          }
          return l10n.soulCardsSubtitle;
        })(),
    };

    final footer = switch (_mode) {
      HomeWidgetMode.comfortZone => l10n.homeWidgetSpaceFooter,
      HomeWidgetMode.sound => l10n.homeWidgetSoundFooter,
      _ => 'Soul • ${l10n.comfortZoneSubtitle} ✦',
    };

    return HomeWidgetPayload(
      badge: badge,
      title: displayTitle,
      body: body,
      footer: footer,
      theme: _theme,
      musicTrack: musicTrack,
      frequency: frequency,
    );
  }

  Future<void> _syncNow(AppLocalizations l10n, {bool pin = false}) async {
    if (_isSyncing) return;
    setState(() => _isSyncing = true);
    try {
      final service = ref.read(homeWidgetServiceProvider);
      await service.setMode(_mode);
      await service.setTheme(_theme);
      if (_selectedSceneId != null) {
        await service.setSceneId(_selectedSceneId!);
      }
      if (_selectedSoundId != null) {
        await service.setSoundId(_selectedSoundId!);
      }
      final payload = _buildPayload(l10n);
      if (pin) {
        await service.requestPinWidget(payload);
      } else {
        await service.syncPayload(payload);
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.homeWidgetSyncedSuccess)));
      }
    } finally {
      if (mounted) {
        setState(() => _isSyncing = false);
      }
    }
  }

  Future<void> _toggleAudio({
    required ComfortZoneScene? scene,
    required SoulAudioAsset? sound,
    required SoulAudioAsset? primarySoundAsset,
    required SoulLocale locale,
  }) async {
    final audio = ref.read(audioPlaybackProvider);
    final state = ref.read(appStateProvider);

    SoulAudioAsset? targetAsset;
    String? trackTitle;
    if (_mode == HomeWidgetMode.comfortZone) {
      targetAsset = primarySoundAsset;
      trackTitle =
          scene != null
              ? '${scene.numberBadge}. ${scene.localizedTitle}'
              : null;
    } else if (_mode == HomeWidgetMode.sound) {
      targetAsset = sound;
      trackTitle = sound?.displayLabelFor(locale);
    }

    if (targetAsset == null) return;
    final path = targetAsset.pathFor(locale);
    if (path == null) return;

    if (audio.isPlaying && audio.assetPath == path) {
      await audio.pause();
    } else {
      if (!state.soundEnabled) {
        await state.setSoundEnabled(true);
      }
      await audio.playTrack(
        path: path,
        title: trackTitle ?? targetAsset.titleFor(locale),
        subtitle: targetAsset.subtitleFor(locale),
        isAsset: true,
        loop: !targetAsset.isGuided,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Watch providers so preview updates automatically when data loads.
    ref.watch(visionsProvider);
    ref.watch(activeVisionCatalogProvider);
    ref.watch(cardDrawProvider);
    ref.watch(cardCatalogProvider);
    final czCatalog = ref.watch(comfortZoneCatalogProvider).valueOrNull;
    final audioCatalog = ref.watch(audioCatalogProvider).valueOrNull;
    final locale = ref.watch(appStateProvider).locale ?? SoulLocale.vi;
    final audio = ref.watch(audioPlaybackProvider);

    final scenes = czCatalog?.scenes ?? const <ComfortZoneScene>[];
    final activeSceneId =
        scenes.any((s) => s.id == _selectedSceneId)
            ? _selectedSceneId
            : (scenes.isNotEmpty ? scenes.first.id : null);
    final selectedScene =
        scenes.isEmpty
            ? null
            : scenes.firstWhere(
              (s) => s.id == activeSceneId,
              orElse: () => scenes.first,
            );

    final soundAssets = [
      for (final asset in audioCatalog?.assets ?? const <SoulAudioAsset>[])
        if (!asset.isGuided && asset.delivery == AudioDelivery.published) asset,
    ];
    final activeSoundId =
        soundAssets.any((a) => a.id == _selectedSoundId)
            ? _selectedSoundId
            : (soundAssets.isNotEmpty ? soundAssets.first.id : null);
    final selectedSound =
        soundAssets.isEmpty
            ? null
            : soundAssets.firstWhere(
              (a) => a.id == activeSoundId,
              orElse: () => soundAssets.first,
            );

    final primarySoundAsset =
        selectedScene != null
            ? audioCatalog?.asset(selectedScene.primarySoundId)
            : null;

    final isCurrentPlaying = switch (_mode) {
      HomeWidgetMode.comfortZone =>
        primarySoundAsset != null &&
            primarySoundAsset.pathFor(locale) != null &&
            audio.isPlaying &&
            audio.assetPath == primarySoundAsset.pathFor(locale),
      HomeWidgetMode.sound =>
        selectedSound != null &&
            selectedSound.pathFor(locale) != null &&
            audio.isPlaying &&
            audio.assetPath == selectedSound.pathFor(locale),
      _ => false,
    };

    final payload = _buildPayload(l10n);

    return Scaffold(
      backgroundColor: SoulColors.paper,
      appBar: SoulAppBar(
        title: l10n.homeWidgetTitle,
        onBack: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(SoulSpace.lg),
          children: [
            Text(
              l10n.homeWidgetSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: SoulColors.muted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: SoulSpace.lg),
            _WidgetPreviewCard(
              payload: payload,
              mode: _mode,
              selectedScene: selectedScene,
              selectedSound: selectedSound,
              primarySoundAsset: primarySoundAsset,
              locale: locale,
              isPlaying: isCurrentPlaying,
              onTogglePlay:
                  () => _toggleAudio(
                    scene: selectedScene,
                    sound: selectedSound,
                    primarySoundAsset: primarySoundAsset,
                    locale: locale,
                  ),
            ),
            const SizedBox(height: SoulSpace.lg),
            Text(
              l10n.homeWidgetModeLabel,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: SoulColors.plum,
              ),
            ),
            const SizedBox(height: SoulSpace.xs),
            Wrap(
              spacing: SoulSpace.xs,
              runSpacing: SoulSpace.xs,
              children: [
                SoulChip(
                  label: l10n.homeWidgetModeComfortZone,
                  selected: _mode == HomeWidgetMode.comfortZone,
                  onSelected:
                      (_) => setState(() => _mode = HomeWidgetMode.comfortZone),
                ),
                SoulChip(
                  label: l10n.homeWidgetModeSound,
                  selected: _mode == HomeWidgetMode.sound,
                  onSelected:
                      (_) => setState(() => _mode = HomeWidgetMode.sound),
                ),
                SoulChip(
                  label: l10n.homeWidgetModeVision,
                  selected: _mode == HomeWidgetMode.vision,
                  onSelected:
                      (_) => setState(() => _mode = HomeWidgetMode.vision),
                ),
                SoulChip(
                  label: l10n.homeWidgetModeGratitude,
                  selected: _mode == HomeWidgetMode.gratitude,
                  onSelected:
                      (_) => setState(() => _mode = HomeWidgetMode.gratitude),
                ),
                SoulChip(
                  label: l10n.homeWidgetModeCard,
                  selected: _mode == HomeWidgetMode.card,
                  onSelected:
                      (_) => setState(() => _mode = HomeWidgetMode.card),
                ),
              ],
            ),
            if (_mode == HomeWidgetMode.comfortZone && scenes.isNotEmpty) ...[
              const SizedBox(height: SoulSpace.md),
              Text(
                l10n.homeWidgetSelectSpace,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: SoulColors.plum,
                ),
              ),
              const SizedBox(height: SoulSpace.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SoulSpace.md,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: SoulColors.surface,
                  borderRadius: BorderRadius.circular(SoulRadius.button),
                  border: Border.all(color: SoulColors.line),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: activeSceneId,
                    isExpanded: true,
                    items: [
                      for (final scene in scenes)
                        DropdownMenuItem(
                          value: scene.id,
                          child: Text(
                            '${scene.numberBadge} • ${scene.localizedTitle}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedSceneId = value);
                      }
                    },
                  ),
                ),
              ),
            ],
            if (_mode == HomeWidgetMode.sound && soundAssets.isNotEmpty) ...[
              const SizedBox(height: SoulSpace.md),
              Text(
                l10n.homeWidgetSelectSound,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: SoulColors.plum,
                ),
              ),
              const SizedBox(height: SoulSpace.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SoulSpace.md,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: SoulColors.surface,
                  borderRadius: BorderRadius.circular(SoulRadius.button),
                  border: Border.all(color: SoulColors.line),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: activeSoundId,
                    isExpanded: true,
                    items: [
                      for (final sound in soundAssets)
                        DropdownMenuItem(
                          value: sound.id,
                          child: Text(
                            sound.displayLabelFor(locale),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedSoundId = value);
                      }
                    },
                  ),
                ),
              ),
            ],
            const SizedBox(height: SoulSpace.lg),
            Text(
              l10n.homeWidgetThemeLabel,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: SoulColors.plum,
              ),
            ),
            const SizedBox(height: SoulSpace.xs),
            Wrap(
              spacing: SoulSpace.xs,
              runSpacing: SoulSpace.xs,
              children: [
                SoulChip(
                  label: l10n.homeWidgetThemePlum,
                  selected: _theme == HomeWidgetTheme.plum,
                  onSelected:
                      (_) => setState(() => _theme = HomeWidgetTheme.plum),
                ),
                SoulChip(
                  label: l10n.homeWidgetThemePaper,
                  selected: _theme == HomeWidgetTheme.paper,
                  onSelected:
                      (_) => setState(() => _theme = HomeWidgetTheme.paper),
                ),
                SoulChip(
                  label: l10n.homeWidgetThemeRose,
                  selected: _theme == HomeWidgetTheme.rose,
                  onSelected:
                      (_) => setState(() => _theme = HomeWidgetTheme.rose),
                ),
              ],
            ),
            const SizedBox(height: SoulSpace.xl),
            SoulButton(
              label: l10n.homeWidgetPinButton,
              onPressed: _isSyncing ? null : () => _syncNow(l10n, pin: true),
            ),
            const SizedBox(height: SoulSpace.xs),
            SoulButton(
              label: l10n.homeWidgetSyncButton,
              variant: SoulButtonVariant.secondary,
              onPressed: _isSyncing ? null : () => _syncNow(l10n),
            ),
            const SizedBox(height: SoulSpace.md),
            Container(
              padding: const EdgeInsets.all(SoulSpace.md),
              decoration: BoxDecoration(
                color: SoulColors.surface,
                borderRadius: BorderRadius.circular(SoulRadius.card),
                border: Border.all(color: SoulColors.line),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.widgets_outlined,
                    size: 20,
                    color: SoulColors.plum,
                  ),
                  const SizedBox(width: SoulSpace.sm),
                  Expanded(
                    child: Text(
                      l10n.homeWidgetHowToHint,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: SoulColors.softInk,
                        height: 1.45,
                      ),
                    ),
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

class _WidgetPreviewCard extends StatelessWidget {
  const _WidgetPreviewCard({
    required this.payload,
    required this.mode,
    required this.selectedScene,
    required this.selectedSound,
    required this.primarySoundAsset,
    required this.locale,
    required this.isPlaying,
    required this.onTogglePlay,
  });

  final HomeWidgetPayload payload;
  final HomeWidgetMode mode;
  final ComfortZoneScene? selectedScene;
  final SoulAudioAsset? selectedSound;
  final SoulAudioAsset? primarySoundAsset;
  final SoulLocale locale;
  final bool isPlaying;
  final VoidCallback onTogglePlay;

  @override
  Widget build(BuildContext context) {
    final (
      gradient,
      badgeColor,
      titleColor,
      bodyColor,
      footerColor,
      borderColor,
    ) = switch (payload.theme) {
      HomeWidgetTheme.paper => (
        const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFCF8F4), Color(0xFFF3EAE3)],
        ),
        const Color(0xFF7A4E6D),
        const Color(0xFF3E2438),
        const Color(0xFF2E1A29),
        const Color(0xFF8A6B80),
        const Color(0xFFE2D3C8),
      ),
      HomeWidgetTheme.rose => (
        const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF4E3EC), Color(0xFFEAD4E2), Color(0xFFDFC3D5)],
        ),
        const Color(0xFF6D3D5E),
        const Color(0xFF3A1F33),
        const Color(0xFF2B1626),
        const Color(0xFF764D69),
        const Color(0xFFD4B2C8),
      ),
      HomeWidgetTheme.plum => (
        const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3A2135), Color(0xFF4F2D46), Color(0xFF6A3E5C)],
        ),
        const Color(0xFFE8D2E1),
        const Color(0xFFFFF9F5),
        const Color(0xFFFFF9F5),
        const Color(0xFFD9C0D1),
        const Color(0x33FFF8F4),
      ),
    };

    // Comfort Zone Mode with animated live canvas + player bar
    if (mode == HomeWidgetMode.comfortZone && selectedScene != null) {
      return Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: SoulColors.plum.withValues(alpha: 0.16),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Khung hình động (Live animated illustration!)
            SizedBox(
              height: 115,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ComfortSceneCanvas(scene: selectedScene!, isPlaying: true),
                  // Top overlay: Room number + Name pill & Widget Badge
                  Positioned(
                    top: SoulSpace.xs + 2,
                    left: SoulSpace.sm,
                    right: SoulSpace.sm,
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.52),
                                borderRadius: BorderRadius.circular(
                                  SoulRadius.button,
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.25),
                                ),
                              ),
                              child: Text(
                                '${selectedScene!.numberBadge} • ${selectedScene!.localizedTitle}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: SoulSpace.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.52),
                            borderRadius: BorderRadius.circular(
                              SoulRadius.button,
                            ),
                          ),
                          child: Text(
                            payload.badge,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w800,
                              fontSize: 9,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Affirmation & Thanh phát nhạc
            Padding(
              padding: const EdgeInsets.all(SoulSpace.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '“${selectedScene!.affirmation}”',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: bodyColor,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                      fontFamily: 'serif',
                    ),
                  ),
                  const SizedBox(height: SoulSpace.sm),

                  // Thanh phát nhạc tích hợp (Live interactive player bar)
                  _PreviewPlayerBar(
                    title:
                        primarySoundAsset != null
                            ? primarySoundAsset!.displayLabelFor(locale)
                            : 'Âm thanh không gian',
                    subtitle:
                        primarySoundAsset != null
                            ? primarySoundAsset!.subtitleFor(locale)
                            : 'Tần số chữa lành',
                    isPlaying: isPlaying,
                    theme: payload.theme,
                    onTogglePlay: onTogglePlay,
                  ),

                  const SizedBox(height: SoulSpace.xs),
                  Text(
                    payload.footer,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: footerColor,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Sound & Frequency Mode with featured player card
    if (mode == HomeWidgetMode.sound) {
      return Container(
        padding: const EdgeInsets.all(SoulSpace.lg),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: SoulColors.plum.withValues(alpha: 0.16),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  payload.badge,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: badgeColor,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.0,
                  ),
                ),
                const Spacer(),
                if (isPlaying)
                  SoulAudioWave(
                    isPlaying: true,
                    barColor: badgeColor,
                    height: 14,
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              payload.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: titleColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              payload.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: bodyColor, height: 1.4),
            ),
            const SizedBox(height: SoulSpace.md),

            // Thanh phát nhạc chuẩn của Soul
            _PreviewPlayerBar(
              title:
                  selectedSound != null
                      ? selectedSound!.displayLabelFor(locale)
                      : payload.title,
              subtitle:
                  selectedSound != null
                      ? selectedSound!.subtitleFor(locale)
                      : payload.body,
              isPlaying: isPlaying,
              theme: payload.theme,
              onTogglePlay: onTogglePlay,
            ),

            const SizedBox(height: SoulSpace.xs),
            Text(
              payload.footer,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: footerColor,
                fontSize: 11,
              ),
            ),
          ],
        ),
      );
    }

    // Default Vision, Gratitude, Card Mode
    return Container(
      padding: const EdgeInsets.all(SoulSpace.lg),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: SoulColors.plum.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            payload.badge,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: badgeColor,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            payload.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: titleColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            payload.body,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: bodyColor,
              height: 1.45,
              fontFamily: 'serif',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            payload.footer,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: footerColor),
          ),
        ],
      ),
    );
  }
}

class _PreviewPlayerBar extends StatelessWidget {
  const _PreviewPlayerBar({
    required this.title,
    required this.subtitle,
    required this.isPlaying,
    required this.theme,
    required this.onTogglePlay,
  });

  final String title;
  final String subtitle;
  final bool isPlaying;
  final HomeWidgetTheme theme;
  final VoidCallback onTogglePlay;

  @override
  Widget build(BuildContext context) {
    final (
      barBg,
      textColor,
      subColor,
      waveColor,
      playBtnBg,
      playBtnIcon,
    ) = switch (theme) {
      HomeWidgetTheme.paper => (
        const Color(0xFFF0E5DC),
        const Color(0xFF3E2438),
        const Color(0xFF8A6B80),
        const Color(0xFF7A4E6D),
        const Color(0xFF7A4E6D),
        Colors.white,
      ),
      HomeWidgetTheme.rose => (
        const Color(0xFFE8CFDE),
        const Color(0xFF3A1F33),
        const Color(0xFF764D69),
        const Color(0xFF6D3D5E),
        const Color(0xFF6D3D5E),
        Colors.white,
      ),
      HomeWidgetTheme.plum => (
        const Color(0x3DFFFFFF),
        const Color(0xFFFFF9F5),
        const Color(0xFFD9C0D1),
        const Color(0xFFE8D2E1),
        const Color(0xFFFFF9F5),
        const Color(0xFF3A2135),
      ),
    };

    return Container(
      decoration: BoxDecoration(
        color: barBg,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: isPlaying ? null : 0.45,
            minHeight: 2.0,
            backgroundColor: Colors.transparent,
            valueColor: AlwaysStoppedAnimation<Color>(waveColor),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: waveColor.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child:
                        isPlaying
                            ? SoulAudioWave(
                              isPlaying: true,
                              barColor: waveColor,
                              height: 14,
                            )
                            : Icon(
                              Icons.music_note_rounded,
                              color: waveColor,
                              size: 18,
                            ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: subColor, fontSize: 10.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: onTogglePlay,
                  borderRadius: BorderRadius.circular(17),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: playBtnBg,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.16),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      size: 20,
                      color: playBtnIcon,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

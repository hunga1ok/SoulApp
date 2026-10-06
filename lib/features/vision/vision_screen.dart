import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/audio/audio_playback_controller.dart';
import '../../core/design_system/design_system.dart';
import '../../data/content/content_repository.dart';
import '../../data/content/vision_catalog.dart';
import '../../data/repositories/vision_audio_repository.dart';
import '../../data/repositories/vision_repository.dart';
import '../../l10n/app_localizations.dart';
import 'vision_controllers.dart';
import 'vision_widgets.dart';

/// Vision tab: an inspiring collage board or clean list of active Visions.
class VisionScreen extends ConsumerStatefulWidget {
  const VisionScreen({super.key});

  @override
  ConsumerState<VisionScreen> createState() => _VisionScreenState();
}

class _VisionScreenState extends ConsumerState<VisionScreen> {
  bool _isCollageMode = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final visions = ref.watch(visionsProvider);
    final catalog = ref.watch(activeVisionCatalogProvider);
    void create() => context.go('/app/vision/new');

    if (visions.hasError || catalog.hasError) {
      return SoulErrorState(
        onRetry: () {
          ref.invalidate(visionsProvider);
          ref.invalidate(activeVisionCatalogProvider);
        },
      );
    }
    if (!visions.hasValue || !catalog.hasValue) return const SoulLoadingState();
    if (visions.value!.isEmpty) {
      return SoulEmptyState(
        icon: Icons.auto_awesome_outlined,
        title: l10n.visionEmptyTitle,
        message: l10n.visionEmptyBody,
        action: SoulButton(label: l10n.createVision, onPressed: create),
      );
    }
    final isVi = Localizations.localeOf(context).languageCode == 'vi';
    final items = visions.value!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        SoulSpace.lg,
        SoulSpace.md,
        SoulSpace.lg,
        SoulSpace.xl + 24,
      ),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.yourVisions,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${items.length} ${isVi ? 'tầm nhìn đang hoạt động' : 'active visions'}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      color: SoulColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip:
                  _isCollageMode
                      ? (isVi ? 'Chuyển sang danh sách' : 'Switch to list view')
                      : (isVi
                          ? 'Chuyển sang bảng ghép'
                          : 'Switch to collage board'),
              icon: Icon(
                _isCollageMode
                    ? Icons.view_agenda_outlined
                    : Icons.dashboard_outlined,
                color: SoulColors.plum,
                size: 22,
              ),
              onPressed: () => setState(() => _isCollageMode = !_isCollageMode),
            ),
            const SizedBox(width: SoulSpace.xxs),
            Material(
              color: SoulColors.ctaStart,
              shape: const CircleBorder(),
              elevation: 2,
              child: IconButton(
                tooltip: l10n.createVision,
                icon: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                constraints: const BoxConstraints(minWidth: 42, minHeight: 42),
                padding: EdgeInsets.zero,
                onPressed: create,
              ),
            ),
          ],
        ),
        const SizedBox(height: SoulSpace.md),
        if (_isCollageMode)
          _buildMasonryBoard(context, items, catalog.value!)
        else
          for (final vision in items)
            Padding(
              padding: const EdgeInsets.only(bottom: SoulSpace.md),
              child: _VisionBoardCard(
                vision: vision,
                catalog: catalog.value!,
                isFullWidth: true,
              ),
            ),
      ],
    );
  }

  Widget _buildMasonryBoard(
    BuildContext context,
    List<Vision> items,
    VisionCatalog catalog,
  ) {
    if (items.length == 1) {
      return _VisionBoardCard(
        vision: items.first,
        catalog: catalog,
        isFullWidth: true,
      );
    }

    final leftVisions = <Vision>[];
    final rightVisions = <Vision>[];
    var leftWeight = 0.0;
    var rightWeight = 0.0;

    for (final vision in items) {
      final weight = _estimateCardWeight(vision);
      if (leftWeight <= rightWeight) {
        leftVisions.add(vision);
        leftWeight += weight;
      } else {
        rightVisions.add(vision);
        rightWeight += weight;
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final vision in leftVisions) ...[
                _VisionBoardCard(
                  vision: vision,
                  catalog: catalog,
                  isFullWidth: false,
                ),
                const SizedBox(height: SoulSpace.md),
              ],
            ],
          ),
        ),
        const SizedBox(width: SoulSpace.sm + 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final vision in rightVisions) ...[
                _VisionBoardCard(
                  vision: vision,
                  catalog: catalog,
                  isFullWidth: false,
                ),
                const SizedBox(height: SoulSpace.md),
              ],
            ],
          ),
        ),
      ],
    );
  }

  double _estimateCardWeight(Vision vision) {
    final hasImage = vision.imagePath != null && vision.imagePath!.isNotEmpty;
    if (hasImage) {
      return 250.0;
    }
    final lineCount = (vision.statement.length / 20.0).clamp(2.0, 7.0);
    final textHeight = lineCount * 22.0;
    final chipsHeight = vision.feelingCodes.isNotEmpty ? 30.0 : 0.0;
    return 60.0 + textHeight + chipsHeight;
  }
}

class _VisionBoardCard extends ConsumerWidget {
  const _VisionBoardCard({
    required this.vision,
    required this.catalog,
    required this.isFullWidth,
  });

  final Vision vision;
  final VisionCatalog catalog;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = catalog.category(vision.categoryCode);
    final theme = CategoryArtTheme.forCategory(vision.categoryCode);
    final selections =
        ref.watch(visionAudioSelectionsProvider(vision.id)).valueOrNull;
    final audioCatalog = ref.watch(audioCatalogProvider).valueOrNull;
    final playback = ref.watch(audioPlaybackProvider);
    final locale =
        ref.watch(appStateProvider.select((s) => s.locale)) ?? SoulLocale.vi;

    // Resolve pre-attached soundtrack title & path
    String? soundTitle;
    String? soundPath;
    bool isAsset = true;

    if (selections != null && selections.isNotEmpty) {
      soundTitle = selections.first.title;
      soundPath = selections.first.path;
      isAsset = selections.first.isAsset;
    } else if (audioCatalog != null) {
      final defaultSound =
          audioCatalog.playableSoundsFor(vision.categoryCode).firstOrNull;
      if (defaultSound != null) {
        soundTitle = defaultSound.titleFor(locale);
        soundPath = defaultSound.pathFor(locale);
      }
    }

    final isPlaying =
        soundPath != null &&
        playback.isPlaying &&
        playback.assetPath == soundPath;

    void onToggleAudio() {
      if (soundPath == null) return;
      if (isAsset) {
        ref.read(audioPlaybackProvider).toggleAsset(soundPath);
      } else {
        ref.read(audioPlaybackProvider).toggleFile(soundPath);
      }
    }

    final hasImage = vision.imagePath != null && vision.imagePath!.isNotEmpty;

    return GestureDetector(
      onTap: () => context.push('/app/vision/${vision.id}', extra: vision),
      behavior: HitTestBehavior.opaque,
      child:
          hasImage
              ? _PhotoBoardCard(
                vision: vision,
                catalog: catalog,
                category: category,
                theme: theme,
                soundTitle: soundTitle,
                soundPath: soundPath,
                isPlaying: isPlaying,
                onToggleAudio: onToggleAudio,
                isFullWidth: isFullWidth,
              )
              : _ArtisticTextBoardCard(
                vision: vision,
                catalog: catalog,
                category: category,
                theme: theme,
                soundTitle: soundTitle,
                soundPath: soundPath,
                isPlaying: isPlaying,
                onToggleAudio: onToggleAudio,
                isFullWidth: isFullWidth,
              ),
    );
  }
}

class _ArtisticTextBoardCard extends StatelessWidget {
  const _ArtisticTextBoardCard({
    required this.vision,
    required this.catalog,
    required this.category,
    required this.theme,
    required this.soundTitle,
    required this.soundPath,
    required this.isPlaying,
    required this.onToggleAudio,
    required this.isFullWidth,
  });

  final Vision vision;
  final VisionCatalog catalog;
  final VisionCategory? category;
  final CategoryArtTheme theme;
  final String? soundTitle;
  final String? soundPath;
  final bool isPlaying;
  final VoidCallback onToggleAudio;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: theme.gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.accentColor.withValues(alpha: 0.16),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.65),
          width: 1.2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: Stack(
          children: [
            // Watermark icon in bottom-right corner for texture & depth
            Positioned(
              right: -12,
              bottom: -12,
              child: Opacity(
                opacity: 0.16,
                child: Icon(
                  theme.bgIcon,
                  size: isFullWidth ? 130 : 96,
                  color: Colors.white,
                ),
              ),
            ),
            // Washi tape accent at top center
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 32,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                isFullWidth ? SoulSpace.lg : 12,
                14,
                isFullWidth ? SoulSpace.lg : 12,
                13,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category tag pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3.5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A000000),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(theme.icon, style: const TextStyle(fontSize: 11)),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            (category?.name ?? vision.categoryCode)
                                .toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: theme.accentColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Statement text directly on background canvas!
                  Text(
                    vision.statement,
                    maxLines: isFullWidth ? 6 : 6,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isFullWidth ? 16 : 14,
                      fontWeight: FontWeight.w600,
                      height: 1.42,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF241C28),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Feelings
                  if (vision.feelingCodes.isNotEmpty) ...[
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        for (final code in vision.feelingCodes)
                          if (catalog.feeling(code)?.label case final label?)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2.5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                label,
                                style: TextStyle(
                                  color: theme.accentColor,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                  // Soundtrack pill
                  if (soundTitle != null && soundPath != null)
                    _SoundtrackPill(
                      soundTitle: soundTitle!,
                      isPlaying: isPlaying,
                      accentColor: theme.accentColor,
                      onTap: onToggleAudio,
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

class _PhotoBoardCard extends StatelessWidget {
  const _PhotoBoardCard({
    required this.vision,
    required this.catalog,
    required this.category,
    required this.theme,
    required this.soundTitle,
    required this.soundPath,
    required this.isPlaying,
    required this.onToggleAudio,
    required this.isFullWidth,
  });

  final Vision vision;
  final VisionCatalog catalog;
  final VisionCategory? category;
  final CategoryArtTheme theme;
  final String? soundTitle;
  final String? soundPath;
  final bool isPlaying;
  final VoidCallback onToggleAudio;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFF0EAE1), width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: Stack(
          children: [
            // Washi tape accent at top center
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 32,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8DFD3),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 9, 6, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: VisionPhoto(
                      relativePath: vision.imagePath,
                      height: isFullWidth ? 170 : 130,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6, 8, 6, 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              theme.icon,
                              style: const TextStyle(fontSize: 11),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                (category?.name ?? vision.categoryCode)
                                    .toUpperCase(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: theme.accentColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 10,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          vision.statement,
                          maxLines: isFullWidth ? 4 : 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isFullWidth ? 15 : 13,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                            color: SoulColors.plum,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (vision.feelingCodes.isNotEmpty) ...[
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: [
                              for (final code in vision.feelingCodes)
                                if (catalog.feeling(code)?.label
                                    case final label?)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2.5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: SoulColors.selectedFill,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      label,
                                      style: TextStyle(
                                        color: SoulColors.selectedInk,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (soundTitle != null && soundPath != null)
                          _SoundtrackPill(
                            soundTitle: soundTitle!,
                            isPlaying: isPlaying,
                            accentColor: SoulColors.ctaStart,
                            onTap: onToggleAudio,
                          ),
                      ],
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

class _SoundtrackPill extends StatelessWidget {
  const _SoundtrackPill({
    required this.soundTitle,
    required this.isPlaying,
    required this.accentColor,
    required this.onTap,
  });

  final String soundTitle;
  final bool isPlaying;
  final Color accentColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: isPlaying ? Colors.white : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isPlaying ? accentColor : Colors.white.withValues(alpha: 0.6),
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPlaying
                  ? Icons.pause_circle_filled_rounded
                  : Icons.play_circle_fill_rounded,
              size: 14,
              color: isPlaying ? accentColor : SoulColors.ctaStart,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                soundTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: isPlaying ? accentColor : SoulColors.plum,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

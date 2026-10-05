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

/// Vision tab: a guided empty state, or the board of active Visions.
class VisionScreen extends ConsumerWidget {
  const VisionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    '${visions.value!.length} ${isVi ? 'tầm nhìn đang hoạt động' : 'active visions'}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      color: SoulColors.muted,
                    ),
                  ),
                ],
              ),
            ),
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
        for (final vision in visions.value!)
          Padding(
            padding: const EdgeInsets.only(bottom: SoulSpace.md),
            child: _VisionCard(vision: vision, catalog: catalog.value!),
          ),
      ],
    );
  }
}

class _VisionCard extends ConsumerWidget {
  const _VisionCard({required this.vision, required this.catalog});

  final Vision vision;
  final VisionCatalog catalog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final category = catalog.category(vision.categoryCode);
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

    return SoulCard(
      onTap: () => context.push('/app/vision/${vision.id}', extra: vision),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (vision.imagePath != null)
            VisionPhoto(relativePath: vision.imagePath, height: 140)
          else
            CategoryArtBanner(
              categoryCode: vision.categoryCode,
              categoryName: category?.name,
              height: 120,
              showTag: true,
            ),
          const SizedBox(height: SoulSpace.sm),
          if (vision.imagePath != null) ...[
            Text(
              [
                if (category?.icon != null) category!.icon!,
                category?.name ?? vision.categoryCode,
              ].join(' ').toUpperCase(),
              style: textTheme.bodyMedium?.copyWith(
                letterSpacing: 1.1,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: SoulSpace.xxs),
          ],
          Text(
            vision.statement,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: SoulSpace.sm),
          Wrap(
            spacing: SoulSpace.xs,
            runSpacing: SoulSpace.xs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final code in vision.feelingCodes)
                if (catalog.feeling(code)?.label case final label?)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SoulSpace.sm,
                      vertical: SoulSpace.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: SoulColors.selectedFill,
                      borderRadius: BorderRadius.circular(SoulRadius.row),
                    ),
                    child: Text(
                      label,
                      style: textTheme.bodyMedium?.copyWith(
                        color: SoulColors.selectedInk,
                        fontSize: 12,
                      ),
                    ),
                  ),
              if (soundTitle != null && soundPath != null)
                GestureDetector(
                  onTap: () {
                    if (isAsset) {
                      ref.read(audioPlaybackProvider).toggleAsset(soundPath!);
                    } else {
                      ref.read(audioPlaybackProvider).toggleFile(soundPath!);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SoulSpace.sm,
                      vertical: SoulSpace.xxs,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isPlaying
                              ? SoulColors.softFill
                              : const Color(0xFFF7F4F9),
                      borderRadius: BorderRadius.circular(SoulRadius.row),
                      border: Border.all(
                        color:
                            isPlaying ? SoulColors.ctaStart : SoulColors.line,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPlaying
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_fill_rounded,
                          size: 16,
                          color: SoulColors.ctaStart,
                        ),
                        const SizedBox(width: 4),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 160),
                          child: Text(
                            soundTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color:
                                  isPlaying
                                      ? SoulColors.ctaStart
                                      : SoulColors.plum,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

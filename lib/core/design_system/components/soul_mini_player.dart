import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../audio/audio_playback_controller.dart';
import '../soul_theme.dart';

/// Floating mini player bar displayed above the bottom navigation bar when an
/// audio track is loaded or active.
class SoulMiniPlayer extends ConsumerWidget {
  const SoulMiniPlayer({super.key});

  void _openDetailSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => const _SoulAudioDetailSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audio = ref.watch(audioPlaybackProvider);
    if (!audio.hasTrack) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final title = audio.currentTitle ?? l10n.exploreTabAudio;
    final subtitle = audio.currentSubtitle ?? l10n.nowPlaying;

    final double progress =
        audio.duration.inMilliseconds > 0
            ? (audio.position.inMilliseconds / audio.duration.inMilliseconds)
                .clamp(0.0, 1.0)
            : 0.0;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: SoulSpace.sm,
        vertical: SoulSpace.xs,
      ),
      decoration: BoxDecoration(
        color: SoulColors.surface,
        borderRadius: BorderRadius.circular(SoulRadius.card),
        border: Border.all(color: SoulColors.line),
        boxShadow: [
          BoxShadow(
            color: SoulColors.plum.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Thin progress line
          LinearProgressIndicator(
            value: progress,
            minHeight: 2.5,
            backgroundColor: SoulColors.softFill,
            valueColor: const AlwaysStoppedAnimation<Color>(SoulColors.plum),
          ),
          InkWell(
            onTap: () => _openDetailSheet(context, ref),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                SoulSpace.sm,
                SoulSpace.xs,
                SoulSpace.xxs,
                SoulSpace.xs,
              ),
              child: Row(
                children: [
                  // Icon Tile
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(SoulRadius.button),
                      gradient: const LinearGradient(
                        colors: [
                          SoulColors.iconTileStart,
                          SoulColors.iconTileEnd,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        audio.isPlaying
                            ? Icons.graphic_eq_rounded
                            : Icons.music_note_rounded,
                        color: SoulColors.plum,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: SoulSpace.sm),

                  // Track Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: SoulColors.muted, fontSize: 11),
                        ),
                      ],
                    ),
                  ),

                  // Play / Pause Button
                  IconButton(
                    iconSize: 28,
                    splashRadius: 22,
                    color: SoulColors.plum,
                    tooltip: audio.isPlaying ? l10n.pause : l10n.play,
                    icon: Icon(
                      audio.isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_filled_rounded,
                    ),
                    onPressed: () => audio.togglePlayPause(),
                  ),

                  // Close Button
                  IconButton(
                    iconSize: 18,
                    splashRadius: 18,
                    color: SoulColors.muted,
                    tooltip: l10n.stop,
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => audio.stop(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoulAudioDetailSheet extends ConsumerWidget {
  const _SoulAudioDetailSheet();

  static String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audio = ref.watch(audioPlaybackProvider);
    final l10n = AppLocalizations.of(context)!;
    final title = audio.currentTitle ?? l10n.exploreTabAudio;
    final subtitle = audio.currentSubtitle ?? l10n.nowPlaying;

    final durationMs = audio.duration.inMilliseconds.toDouble();
    final positionMs = audio.position.inMilliseconds.toDouble().clamp(
      0.0,
      durationMs > 0 ? durationMs : 1.0,
    );

    return Container(
      decoration: const BoxDecoration(
        color: SoulColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(
        SoulSpace.lg,
        SoulSpace.sm,
        SoulSpace.lg,
        SoulSpace.xl,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: SoulSpace.md),
                decoration: BoxDecoration(
                  color: SoulColors.line,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Cover Art Box
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [
                    SoulColors.plum.withValues(alpha: 0.15),
                    SoulColors.rose.withValues(alpha: 0.25),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: SoulColors.line),
                boxShadow: [
                  BoxShadow(
                    color: SoulColors.plum.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.graphic_eq_rounded,
                  color: SoulColors.plum,
                  size: 56,
                ),
              ),
            ),
            const SizedBox(height: SoulSpace.lg),

            // Title & Subtitle
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: SoulSpace.xxs),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: SoulColors.muted),
            ),
            const SizedBox(height: SoulSpace.md),

            // Progress Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: SoulColors.plum,
                inactiveTrackColor: SoulColors.softFill,
                thumbColor: SoulColors.plum,
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: Slider(
                value: positionMs,
                max: durationMs > 0 ? durationMs : 1.0,
                onChanged:
                    durationMs > 0
                        ? (value) {
                          audio.seek(Duration(milliseconds: value.toInt()));
                        }
                        : null,
              ),
            ),

            // Elapsed / Total
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: SoulSpace.xs),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(audio.position),
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: SoulColors.muted),
                  ),
                  Text(
                    _formatDuration(audio.duration),
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: SoulColors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SoulSpace.md),

            // Playback Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Loop toggle
                IconButton(
                  iconSize: 24,
                  tooltip: 'Loop',
                  color: audio.isLooping ? SoulColors.plum : SoulColors.muted,
                  icon: Icon(
                    audio.isLooping
                        ? Icons.repeat_one_rounded
                        : Icons.repeat_rounded,
                  ),
                  onPressed: () => audio.toggleLoop(),
                ),
                const SizedBox(width: SoulSpace.sm),

                // Replay 10s
                IconButton(
                  iconSize: 30,
                  tooltip: '-10s',
                  color: SoulColors.softInk,
                  icon: const Icon(Icons.replay_10_rounded),
                  onPressed:
                      () => audio.seekRelative(const Duration(seconds: -10)),
                ),
                const SizedBox(width: SoulSpace.md),

                // Big Play / Pause Button
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [SoulColors.ctaStart, SoulColors.ctaEnd],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: SoulColors.plum.withValues(alpha: 0.25),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    iconSize: 36,
                    color: Colors.white,
                    tooltip: audio.isPlaying ? l10n.pause : l10n.play,
                    icon: Icon(
                      audio.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                    ),
                    onPressed: () => audio.togglePlayPause(),
                  ),
                ),
                const SizedBox(width: SoulSpace.md),

                // Forward 10s
                IconButton(
                  iconSize: 30,
                  tooltip: '+10s',
                  color: SoulColors.softInk,
                  icon: const Icon(Icons.forward_10_rounded),
                  onPressed:
                      () => audio.seekRelative(const Duration(seconds: 10)),
                ),
                const SizedBox(width: SoulSpace.sm),

                // Stop Button
                IconButton(
                  iconSize: 24,
                  tooltip: l10n.stop,
                  color: SoulColors.muted,
                  icon: const Icon(Icons.stop_circle_outlined),
                  onPressed: () {
                    audio.stop();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

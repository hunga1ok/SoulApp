import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../core/audio/audio_playback_controller.dart';
import '../../core/design_system/design_system.dart';
import '../../data/content/audio_catalog.dart';
import '../../data/content/content_repository.dart';
import '../../l10n/app_localizations.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(appStateProvider);
    final locale = state.locale ?? SoulLocale.en;
    final catalog = ref.watch(audioCatalogProvider);
    final audio = ref.watch(audioPlaybackProvider);
    return ListView(
      padding: const EdgeInsets.all(SoulSpace.lg),
      children: [
        Text(
          l10n.exploreTitle,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: SoulSpace.sm),
        Text(l10n.exploreBody, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: SoulSpace.lg),
        SoulCard(color: SoulColors.lilac, child: Text(l10n.audioLibraryNote)),
        const SizedBox(height: SoulSpace.lg),
        if (catalog.hasError)
          TextButton(
            onPressed: () => ref.invalidate(audioCatalogProvider),
            child: Text(l10n.retry),
          )
        else if (!catalog.hasValue)
          const SoulLoadingState()
        else
          for (final group in _audioGroups(catalog.value!.assets)) ...[
            Text(
              _titleForGroup(l10n, group.$1),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: SoulSpace.sm),
            for (final item in group.$2)
              if (item.pathFor(locale) case final path?)
                Padding(
                  padding: const EdgeInsets.only(bottom: SoulSpace.sm),
                  child: SoulAudioRow(
                    title: item.titleFor(locale),
                    subtitle:
                        item.delivery == AudioDelivery.published
                            ? item.id
                            : l10n.audioPending,
                    isPlaying: audio.isPlaying && audio.assetPath == path,
                    onPlayPause:
                        state.soundEnabled &&
                                item.delivery == AudioDelivery.published
                            ? () async {
                              try {
                                await audio.toggleAsset(path);
                              } catch (_) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.somethingWentWrong),
                                    ),
                                  );
                                }
                              }
                            }
                            : null,
                  ),
                ),
            const SizedBox(height: SoulSpace.md),
          ],
      ],
    );
  }

  List<(String, List<SoulAudioAsset>)> _audioGroups(
    List<SoulAudioAsset> assets,
  ) => [
    (
      'guided',
      [
        for (final item in assets)
          if (item.isGuided) item,
      ],
    ),
    (
      'music',
      [
        for (final item in assets)
          if (item.type == 'music') item,
      ],
    ),
    (
      'rest',
      [
        for (final item in assets)
          if (!item.isGuided && item.type != 'music') item,
      ],
    ),
  ];

  String _titleForGroup(AppLocalizations l10n, String group) => switch (group) {
    'guided' => l10n.audioGuided,
    'music' => l10n.audioMusic,
    _ => l10n.audioRest,
  };
}

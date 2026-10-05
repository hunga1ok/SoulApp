import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../core/audio/audio_playback_controller.dart';
import '../../core/design_system/design_system.dart';
import '../../data/content/audio_catalog.dart';
import '../../data/content/content_repository.dart';
import '../../l10n/app_localizations.dart';

class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  var _smallActionDone = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = ref.watch(appStateProvider).preferredName ?? '…';
    final soundEnabled = ref.watch(appStateProvider).soundEnabled;
    final audio = ref.watch(audioPlaybackProvider);
    final track = ref.watch(audioCatalogProvider).valueOrNull?.asset('SO-11');
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        SoulSpace.lg,
        SoulSpace.md,
        SoulSpace.lg,
        SoulSpace.xl,
      ),
      children: [
        Text(
          l10n.dayProgress(1).toUpperCase(),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(letterSpacing: 1.1),
        ),
        const SizedBox(height: SoulSpace.xs),
        Text(
          l10n.welcome(name),
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: SoulSpace.lg),
        const _ProgressCard(),
        const SizedBox(height: SoulSpace.lg),
        Text(
          l10n.todayRhythm,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: SoulSpace.sm),
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
                      )
                  : null,
        ),
        const SizedBox(height: SoulSpace.lg),
        Text(
          l10n.oneSmallAction,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: SoulSpace.sm),
        Semantics(
          button: true,
          selected: _smallActionDone,
          label: l10n.oneSmallAction,
          child: SoulCard(
            color: _smallActionDone ? SoulColors.lilac : SoulColors.surface,
            onTap: () => setState(() => _smallActionDone = !_smallActionDone),
            child: Row(
              children: [
                Icon(
                  _smallActionDone
                      ? Icons.check_circle
                      : Icons.auto_awesome_outlined,
                  color: SoulColors.lilacStrong,
                ),
                const SizedBox(width: SoulSpace.sm),
                Expanded(
                  child: Text(
                    l10n.smallActionText,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard();

  @override
  Widget build(BuildContext context) {
    return SoulCard(
      color: SoulColors.rose,
      padding: const EdgeInsets.all(SoulSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('01', style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: SoulSpace.xs),
          SoulProgressBar(
            value: 1 / 28,
            semanticsLabel: AppLocalizations.of(context)!.dayProgress(1),
          ),
        ],
      ),
    );
  }
}

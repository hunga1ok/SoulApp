import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../core/audio/audio_playback_controller.dart';
import '../../core/design_system/design_system.dart';
import '../../data/content/audio_catalog.dart';
import '../../data/content/content_repository.dart';
import '../../data/repositories/gratitude_repository.dart';
import '../../l10n/app_localizations.dart';

class TodayScreen extends ConsumerStatefulWidget {
  const TodayScreen({super.key});

  @override
  ConsumerState<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends ConsumerState<TodayScreen> {
  final _gratitudeController = TextEditingController();

  @override
  void dispose() {
    _gratitudeController.dispose();
    super.dispose();
  }

  Future<void> _saveGratitude() async {
    await ref
        .read(gratitudeNotesProvider.notifier)
        .add(_gratitudeController.text);
    _gratitudeController.clear();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = ref.watch(appStateProvider).preferredName ?? '…';
    final soundEnabled = ref.watch(appStateProvider).soundEnabled;
    final audio = ref.watch(audioPlaybackProvider);
    final track = ref.watch(audioCatalogProvider).valueOrNull?.asset('SO-11');
    final gratitudeNotes = ref.watch(gratitudeNotesProvider);
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
          l10n.gratitudeJournalTitle,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: SoulSpace.sm),
        Text(
          l10n.gratitudeJournalHint,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: SoulSpace.sm),
        SoulTextField(
          controller: _gratitudeController,
          label: l10n.gratitudeNoteLabel,
          maxLines: 4,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: SoulSpace.sm),
        SoulButton(
          label: l10n.saveNote,
          onPressed:
              _gratitudeController.text.trim().isEmpty ? null : _saveGratitude,
        ),
        if (gratitudeNotes.valueOrNull case final notes?
            when notes.isNotEmpty) ...[
          const SizedBox(height: SoulSpace.lg),
          for (final note in notes.take(3))
            Padding(
              padding: const EdgeInsets.only(bottom: SoulSpace.sm),
              child: SoulStickyNote(
                eyebrow: l10n.gratitudeToday,
                body: note.body,
              ),
            ),
        ],
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

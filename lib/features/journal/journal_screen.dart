import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_system/design_system.dart';
import '../../data/repositories/gratitude_repository.dart';
import '../../l10n/app_localizations.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ref.read(gratitudeNotesProvider.notifier).add(_controller.text);
    _controller.clear();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final notes = ref.watch(gratitudeNotesProvider);
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        SoulSpace.lg,
        SoulSpace.md,
        SoulSpace.lg,
        SoulSpace.xl,
      ),
      children: [
        Text(
          l10n.gratitudeJournalTitle,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: SoulSpace.xs),
        Text(
          l10n.gratitudeJournalHint,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: SoulSpace.lg),
        SoulTextField(
          controller: _controller,
          label: l10n.gratitudeNoteLabel,
          maxLines: 6,
          textCapitalization: TextCapitalization.sentences,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: SoulSpace.sm),
        SoulButton(
          label: l10n.saveNote,
          onPressed: _controller.text.trim().isEmpty ? null : _save,
        ),
        const SizedBox(height: SoulSpace.xl),
        Text(l10n.recent, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: SoulSpace.sm),
        switch (notes) {
          AsyncData(:final value) when value.isEmpty => Text(
            l10n.gratitudeNotesEmpty,
          ),
          AsyncData(:final value) => Column(
            children: [
              for (final note in value)
                Padding(
                  padding: const EdgeInsets.only(bottom: SoulSpace.sm),
                  child: SoulStickyNote(
                    eyebrow: l10n.gratitudeToday,
                    body: note.body,
                  ),
                ),
            ],
          ),
          AsyncError() => SoulErrorState(
            onRetry: () => ref.invalidate(gratitudeNotesProvider),
          ),
          _ => const SoulLoadingState(),
        },
      ],
    );
  }
}

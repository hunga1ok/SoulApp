import 'package:flutter/material.dart';

import '../../core/design_system/design_system.dart';
import '../../l10n/app_localizations.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        SoulSpace.lg,
        SoulSpace.md,
        SoulSpace.lg,
        SoulSpace.xl,
      ),
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: SoulSpace.sm,
          children: [
            Text(l10n.recent, style: Theme.of(context).textTheme.headlineSmall),
            Text(l10n.oneNote, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: SoulSpace.md),
        const _LinedNote(),
      ],
    );
  }
}

class _LinedNote extends StatelessWidget {
  const _LinedNote();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SoulStickyNote(
      eyebrow: l10n.gratitudeToday,
      body: l10n.gratitudeNote,
      onTap:
          () => showSoulBottomSheet<void>(
            context: context,
            builder:
                (context) => _NoteSheet(
                  title: l10n.gratitudeToday,
                  body: l10n.gratitudeNote,
                ),
          ),
    );
  }
}

class _NoteSheet extends StatelessWidget {
  const _NoteSheet({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: SoulSpace.sm),
        Text(body, style: Theme.of(context).textTheme.headlineSmall),
      ],
    );
  }
}

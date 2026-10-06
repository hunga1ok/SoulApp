import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../core/design_system/design_system.dart';
import '../../data/repositories/gratitude_repository.dart';
import '../../l10n/app_localizations.dart';
import 'journal_note_detail_screen.dart';
import 'journal_note_models.dart';
import 'new_journal_note_screen.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(appStateProvider).locale ?? SoulLocale.vi;
    final entries =
        ref.watch(recentGratitudeEntriesProvider).valueOrNull ?? const [];
    final notes = groupGratitudeEntries(entries, locale);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        SoulSpace.lg,
        SoulSpace.md,
        SoulSpace.lg,
        SoulSpace.xl,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.recent,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l10n.notesCount(notes.length),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: SoulColors.muted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: SoulSpace.xs),
            Material(
              color: SoulColors.plum.withValues(alpha: 0.08),
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: IconButton(
                icon: const Icon(
                  Icons.add_rounded,
                  color: SoulColors.plum,
                  size: 22,
                ),
                tooltip: l10n.addNote,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NewJournalNoteScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: SoulSpace.lg),
        if (notes.isEmpty)
          _EmptyJournalCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NewJournalNoteScreen()),
              );
            },
          )
        else
          for (final note in notes) ...[
            _JournalNoteCard(
              note: note,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => JournalNoteDetailScreen(note: note),
                  ),
                );
              },
            ),
            const SizedBox(height: SoulSpace.md),
          ],
      ],
    );
  }
}

class _JournalNoteCard extends StatelessWidget {
  const _JournalNoteCard({required this.note, required this.onTap});

  final JournalNote note;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateStr =
        '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SoulRadius.card),
      child: Container(
        decoration: BoxDecoration(
          color: SoulColors.surface,
          borderRadius: BorderRadius.circular(SoulRadius.card),
          border: Border.all(color: SoulColors.line),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(SoulSpace.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Category badge + Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (note.journeyDay != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SoulSpace.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: SoulColors.lilac,
                      borderRadius: BorderRadius.circular(SoulRadius.button),
                    ),
                    child: Text(
                      l10n.dayProgress(note.journeyDay!).toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: SoulColors.plum,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Text(
                      l10n.gratitudeNote.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: SoulColors.muted,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                Text(
                  dateStr,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: SoulColors.muted),
                ),
              ],
            ),
            const SizedBox(height: SoulSpace.xs),

            // Note title
            Text(
              note.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: SoulColors.softInk,
              ),
            ),
            const SizedBox(height: SoulSpace.sm),

            // Note text preview (up to 2 preview entries)
            for (int i = 0; i < note.sentences.take(2).length; i++) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: SoulSpace.xxs),
                child: Text(
                  note.sentences.length > 1
                      ? '• ${note.sentences[i]}'
                      : note.sentences[i],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: SoulColors.softInk,
                    height: 1.4,
                  ),
                ),
              ),
            ],
            if (note.sentences.length > 2) ...[
              const SizedBox(height: SoulSpace.xxs),
              Text(
                '+ ${note.sentences.length - 2} ${l10n.gratitudeSentenceCount(note.sentences.length - 2)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: SoulColors.plum,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            const SizedBox(height: SoulSpace.sm),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.gratitudeSentenceCount(note.sentences.length),
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: SoulColors.muted),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: SoulColors.muted,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyJournalCard extends StatelessWidget {
  const _EmptyJournalCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SoulRadius.card),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SoulSpace.lg,
          vertical: SoulSpace.xl,
        ),
        decoration: BoxDecoration(
          color: SoulColors.surface,
          borderRadius: BorderRadius.circular(SoulRadius.card),
          border: Border.all(color: SoulColors.line),
        ),
        child: Column(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: SoulColors.lilac,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit_note_rounded,
                size: 28,
                color: SoulColors.plum,
              ),
            ),
            const SizedBox(height: SoulSpace.md),
            Text(
              l10n.gratitudeJournalTitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: SoulColors.softInk,
              ),
            ),
            const SizedBox(height: SoulSpace.xs),
            Text(
              l10n.gratitudeNotesEmpty,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: SoulColors.muted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: SoulSpace.lg),
            SoulButton(
              label: l10n.addNote,
              variant: SoulButtonVariant.secondary,
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }
}

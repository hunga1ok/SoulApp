import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/design_system/design_system.dart';
import '../../data/local/image_store.dart';
import '../../data/repositories/gratitude_repository.dart';
import '../../l10n/app_localizations.dart';
import 'journal_note_models.dart';
import 'new_journal_note_screen.dart';

class JournalNoteDetailScreen extends ConsumerWidget {
  const JournalNoteDetailScreen({super.key, required this.note});

  final JournalNote note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final dateStr =
        '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}';
    final timeStr =
        '${note.createdAt.hour.toString().padLeft(2, '0')}:${note.createdAt.minute.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: SoulColors.paper,
      appBar: SoulAppBar(
        title: note.title,
        onBack: () => Navigator.pop(context),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: SoulColors.plum),
            tooltip: l10n.editNote,
            onPressed: () async {
              final updated = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => NewJournalNoteScreen(existingNote: note),
                ),
              );
              if (updated == true && context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFFB3261E),
            ),
            tooltip: l10n.deleteNote,
            onPressed: () => _confirmDelete(context, ref, l10n),
          ),
          const SizedBox(width: SoulSpace.xs),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            SoulSpace.lg,
            SoulSpace.md,
            SoulSpace.lg,
            SoulSpace.xl,
          ),
          children: [
            // Top category / day badge
            if (note.journeyDay != null) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SoulSpace.sm,
                    vertical: SoulSpace.xxs,
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
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: SoulSpace.sm),
            ],

            // Note title
            Text(
              note.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: SoulColors.softInk,
              ),
            ),
            const SizedBox(height: SoulSpace.xs),

            // Timestamp & count
            Wrap(
              spacing: SoulSpace.sm,
              runSpacing: SoulSpace.xxs,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: SoulColors.muted,
                    ),
                    const SizedBox(width: SoulSpace.xs),
                    Text(
                      '$dateStr • $timeStr',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: SoulColors.muted),
                    ),
                  ],
                ),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: SoulColors.line,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  l10n.gratitudeSentenceCount(note.sentences.length),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: SoulColors.muted),
                ),
              ],
            ),
            const SizedBox(height: SoulSpace.lg),
            const Divider(color: SoulColors.line, height: 1),
            const SizedBox(height: SoulSpace.lg),

            // Attached photo preview
            if (note.imagePath != null) ...[
              Consumer(
                builder: (context, ref, _) {
                  final fileAsync = ref.watch(
                    FutureProvider.autoDispose(
                      (ref) => ref
                          .watch(imageStoreProvider)
                          .resolve(note.imagePath!),
                    ),
                  );
                  return fileAsync.when(
                    data: (file) {
                      if (!file.existsSync()) return const SizedBox.shrink();
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(SoulRadius.card),
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 280),
                          width: double.infinity,
                          child: Image.file(file, fit: BoxFit.cover),
                        ),
                      );
                    },
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  );
                },
              ),
              const SizedBox(height: SoulSpace.lg),
            ],

            // Note text paragraphs
            for (int i = 0; i < note.sentences.length; i++) ...[
              Text(
                note.sentences[i],
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: SoulColors.softInk,
                  height: 1.65,
                  fontSize: 16,
                ),
              ),
              if (i < note.sentences.length - 1)
                const SizedBox(height: SoulSpace.md),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showSoulConfirmDialog(
      context: context,
      title: l10n.deleteNoteConfirmTitle,
      message: l10n.deleteNoteConfirmBody,
      confirmLabel: l10n.deleteNote,
    );
    if (confirmed && context.mounted) {
      final repo = ref.read(gratitudeRepositoryProvider);
      for (final raw in note.rawEntries) {
        await repo.deleteEntry(raw.id);
      }
      ref.invalidate(recentGratitudeEntriesProvider);
      ref.invalidate(todayGratitudeEntriesProvider);
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.noteDeleted)));
      }
    }
  }
}

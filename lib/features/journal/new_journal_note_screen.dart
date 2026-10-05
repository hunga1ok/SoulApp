import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../core/design_system/design_system.dart';
import '../../data/repositories/gratitude_repository.dart';
import '../../l10n/app_localizations.dart';
import 'journal_note_models.dart';

class NewJournalNoteScreen extends ConsumerStatefulWidget {
  const NewJournalNoteScreen({super.key});

  @override
  ConsumerState<NewJournalNoteScreen> createState() =>
      _NewJournalNoteScreenState();
}

class _NewJournalNoteScreenState extends ConsumerState<NewJournalNoteScreen> {
  final _themeController = TextEditingController();
  final _gratitudeController = TextEditingController();
  final _reasonController = TextEditingController();
  bool _isSaving = false;

  final List<String> _suggestedThemesVi = [
    'Khoảnh khắc biết ơn',
    'Gia đình & Người thân',
    'Công việc & Sự nghiệp',
    'Bản thân & Bình yên',
    'Sức khỏe & Cơ thể',
  ];

  final List<String> _suggestedThemesEn = [
    'Grateful Moment',
    'Family & Loved Ones',
    'Work & Growth',
    'Self-Care & Peace',
    'Health & Body',
  ];

  @override
  void initState() {
    super.initState();
    _gratitudeController.addListener(() => setState(() {}));
    _reasonController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _themeController.dispose();
    _gratitudeController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _gratitudeController.text.trim();
    if (text.isEmpty || _isSaving) return;

    setState(() => _isSaving = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      final theme = _themeController.text.trim();
      final fullGratitude = theme.isNotEmpty ? '[$theme] $text' : text;

      await ref
          .read(gratitudeRepositoryProvider)
          .addSingleEntry(
            gratitudeText: fullGratitude,
            reasonText: _reasonController.text.trim(),
          );

      ref.invalidate(recentGratitudeEntriesProvider);
      ref.invalidate(todayGratitudeEntriesProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.noteSaved)));
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.somethingWentWrong)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(appStateProvider).locale ?? SoulLocale.vi;
    final suggestions =
        locale == SoulLocale.vi ? _suggestedThemesVi : _suggestedThemesEn;

    final previewSentence = formatGratitudeSentence(
      gratitude:
          _gratitudeController.text.trim().isEmpty
              ? (locale == SoulLocale.vi ? '...' : '...')
              : _gratitudeController.text.trim(),
      reason:
          _reasonController.text.trim().isEmpty
              ? null
              : _reasonController.text.trim(),
      locale: locale,
    );

    return Scaffold(
      backgroundColor: SoulColors.paper,
      appBar: SoulAppBar(
        title: l10n.newGratitudeNote,
        onBack: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(SoulSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Theme section
              Text(
                locale == SoulLocale.vi ? 'Chủ đề ghi chú' : 'Note Theme',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: SoulColors.muted,
                ),
              ),
              const SizedBox(height: SoulSpace.xs),
              SoulTextField(
                controller: _themeController,
                label: locale == SoulLocale.vi ? 'Chủ đề' : 'Theme',
                hint: l10n.customNoteDefaultTheme,
              ),
              const SizedBox(height: SoulSpace.xs),
              Wrap(
                spacing: SoulSpace.xs,
                runSpacing: SoulSpace.xxs,
                children: [
                  for (final item in suggestions)
                    ActionChip(
                      label: Text(item),
                      backgroundColor:
                          _themeController.text == item
                              ? SoulColors.lilac
                              : SoulColors.surface,
                      side: BorderSide(
                        color:
                            _themeController.text == item
                                ? SoulColors.lilacStrong
                                : SoulColors.line,
                      ),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color:
                            _themeController.text == item
                                ? SoulColors.plum
                                : SoulColors.softInk,
                        fontWeight:
                            _themeController.text == item
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                      onPressed: () {
                        setState(() {
                          _themeController.text = item;
                        });
                      },
                    ),
                ],
              ),
              const SizedBox(height: SoulSpace.lg),

              // Field 1: Gratitude
              Text(
                l10n.gratitudeFieldPrompt,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: SoulSpace.xs),
              SoulTextField(
                controller: _gratitudeController,
                label: l10n.gratitudeFieldPrompt,
                hint: l10n.notePromptPlaceholder,
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
              ),
              const SizedBox(height: SoulSpace.md),

              // Field 2: Reason
              Text(
                l10n.gratitudeReasonPrompt,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: SoulSpace.xs),
              SoulTextField(
                controller: _reasonController,
                label: l10n.gratitudeReasonPrompt,
                hint: l10n.noteReasonPlaceholder,
                maxLines: 2,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: SoulSpace.lg),

              // Live sentence preview
              Container(
                padding: const EdgeInsets.all(SoulSpace.md),
                decoration: BoxDecoration(
                  color: SoulColors.surface,
                  borderRadius: BorderRadius.circular(SoulRadius.card),
                  border: Border.all(color: SoulColors.line),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.sentencePreview,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: SoulColors.muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: SoulSpace.xs),
                    Text(
                      previewSentence,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color:
                            _gratitudeController.text.trim().isEmpty
                                ? SoulColors.muted
                                : SoulColors.softInk,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SoulSpace.xl),

              // Save button
              SoulButton(
                label: l10n.saveNote,
                onPressed:
                    _gratitudeController.text.trim().isEmpty || _isSaving
                        ? null
                        : _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

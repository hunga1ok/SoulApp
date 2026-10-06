import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../core/design_system/design_system.dart';
import '../../core/platform/image_picking.dart';
import '../../data/local/image_store.dart';
import '../../data/repositories/gratitude_repository.dart';
import '../../l10n/app_localizations.dart';
import 'journal_note_models.dart';

class NewJournalNoteScreen extends ConsumerStatefulWidget {
  const NewJournalNoteScreen({super.key, this.existingNote});

  final JournalNote? existingNote;

  @override
  ConsumerState<NewJournalNoteScreen> createState() =>
      _NewJournalNoteScreenState();
}

class _NewJournalNoteScreenState extends ConsumerState<NewJournalNoteScreen> {
  late final TextEditingController _contentController;
  bool _isSaving = false;
  String? _attachedLocalImagePath;
  String? _selectedTheme;

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
    final existing = widget.existingNote;
    if (existing != null) {
      _selectedTheme = existing.title;
      _attachedLocalImagePath = existing.imagePath;
      final initialText = existing.sentences.join('\n');
      _contentController = TextEditingController(text: initialText);
    } else {
      _contentController = TextEditingController();
    }
    _contentController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ref.read(imagePickingProvider);
    final picked = await picker.pick(fromCamera: false);
    if (picked != null && mounted) {
      setState(() {
        _attachedLocalImagePath = picked;
      });
    }
  }

  void _insertPrompt() {
    final l10n = AppLocalizations.of(context)!;
    final template = '${l10n.gratitudePromptTemplateText}\n';
    final currentText = _contentController.text;
    final selection = _contentController.selection;

    if (selection.isValid && selection.start >= 0) {
      final newText = currentText.replaceRange(
        selection.start,
        selection.end,
        template,
      );
      _contentController.value = TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
          offset: selection.start + template.length,
        ),
      );
    } else {
      _contentController.text =
          currentText.isEmpty ? template : '$currentText\n$template';
      _contentController.selection = TextSelection.collapsed(
        offset: _contentController.text.length,
      );
    }
  }

  Future<void> _save() async {
    final text = _contentController.text.trim();
    if (text.isEmpty || _isSaving) return;

    setState(() => _isSaving = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      final theme = _selectedTheme?.trim() ?? '';
      final fullGratitude = theme.isNotEmpty ? '[$theme]\n$text' : text;

      String? reasonWithImage;
      if (_attachedLocalImagePath != null) {
        if (_attachedLocalImagePath!.startsWith('journal/') ||
            _attachedLocalImagePath!.startsWith('assets/')) {
          reasonWithImage = 'image:$_attachedLocalImagePath';
        } else {
          final relPath = await ref
              .read(imageStoreProvider)
              .saveJournalImage(_attachedLocalImagePath!);
          reasonWithImage = 'image:$relPath';
        }
      }

      final existing = widget.existingNote;
      final repo = ref.read(gratitudeRepositoryProvider);

      if (existing != null && existing.rawEntries.isNotEmpty) {
        // If updating an existing standalone note
        final firstId = existing.rawEntries.first.id;
        await repo.updateSingleEntry(
          id: firstId,
          gratitudeText: fullGratitude,
          reasonText: reasonWithImage,
        );
        // Clean up remaining raw entries if note was previously split into multiples
        for (int i = 1; i < existing.rawEntries.length; i++) {
          await repo.deleteEntry(existing.rawEntries[i].id);
        }
      } else {
        await repo.addSingleEntry(
          gratitudeText: fullGratitude,
          reasonText: reasonWithImage,
        );
      }

      ref.invalidate(recentGratitudeEntriesProvider);
      ref.invalidate(todayGratitudeEntriesProvider);

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(existing != null ? l10n.noteUpdated : l10n.noteSaved),
          ),
        );
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

    final effectiveTheme = _selectedTheme ?? suggestions.first;

    return Scaffold(
      backgroundColor: SoulColors.paper,
      appBar: SoulAppBar(
        title:
            widget.existingNote != null ? l10n.editNote : l10n.newGratitudeNote,
        onBack: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            SoulSpace.lg,
            SoulSpace.md,
            SoulSpace.lg,
            SoulSpace.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Clean Journal editing card
              Container(
                decoration: BoxDecoration(
                  color: SoulColors.surface,
                  borderRadius: BorderRadius.circular(SoulRadius.card),
                  border: Border.all(color: SoulColors.line),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(SoulSpace.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Theme Row
                    Row(
                      children: [
                        const Icon(
                          Icons.label_outline_rounded,
                          size: 18,
                          color: SoulColors.plum,
                        ),
                        const SizedBox(width: SoulSpace.xs),
                        Text(
                          locale == SoulLocale.vi ? 'Chủ đề:' : 'Theme:',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(
                            color: SoulColors.muted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: SoulSpace.xs),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value:
                                  suggestions.contains(effectiveTheme)
                                      ? effectiveTheme
                                      : suggestions.first,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.arrow_drop_down_rounded,
                                color: SoulColors.plum,
                              ),
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: SoulColors.softInk,
                                fontWeight: FontWeight.w600,
                              ),
                              onChanged: (newVal) {
                                if (newVal != null) {
                                  setState(() => _selectedTheme = newVal);
                                }
                              },
                              items: [
                                for (final t in suggestions)
                                  DropdownMenuItem<String>(
                                    value: t,
                                    child: Text(
                                      t,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: SoulColors.line, height: 12),

                    // Minimal Toolbar
                    Wrap(
                      spacing: SoulSpace.xs,
                      runSpacing: SoulSpace.xxs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: _insertPrompt,
                          icon: const Icon(
                            Icons.auto_fix_high_rounded,
                            size: 16,
                            color: SoulColors.plum,
                          ),
                          label: Text(
                            l10n.insertPromptTemplate,
                            style: const TextStyle(
                              color: SoulColors.plum,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 16,
                            color: SoulColors.plum,
                          ),
                          label: Text(
                            _attachedLocalImagePath == null
                                ? l10n.addPhoto
                                : l10n.changePhoto,
                            style: const TextStyle(
                              color: SoulColors.plum,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: SoulColors.line, height: 12),

                    // Attached image thumbnail
                    if (_attachedLocalImagePath != null) ...[
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              SoulRadius.card,
                            ),
                            child: Image.file(
                              File(_attachedLocalImagePath!),
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Material(
                              color: Colors.black.withValues(alpha: 0.6),
                              shape: const CircleBorder(),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                tooltip: l10n.removePhoto,
                                onPressed: () {
                                  setState(() {
                                    _attachedLocalImagePath = null;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: SoulSpace.sm),
                    ],

                    // Borderless Text field (no inner outline box)
                    TextField(
                      controller: _contentController,
                      maxLines: 14,
                      minLines: 8,
                      textCapitalization: TextCapitalization.sentences,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: SoulColors.softInk,
                        height: 1.6,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.zero,
                        hintText: l10n.gratitudeJournalPlaceholder,
                        hintStyle: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(
                          color: SoulColors.muted.withValues(alpha: 0.7),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SoulSpace.xl),

              // Save button
              SoulButton(
                label: l10n.saveAndCompleteJournal,
                onPressed:
                    _contentController.text.trim().isEmpty || _isSaving
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

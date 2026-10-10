import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../app/app_state.dart';
import '../../core/audio/audio_playback_controller.dart';
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
  final AudioRecorder _recorder = AudioRecorder();
  bool _isSaving = false;
  bool _isRecording = false;
  String? _attachedLocalImagePath;
  String? _attachedAudioPath;
  String? _selectedTheme;

  List<String> _suggestedThemesFor(SoulLocale locale) => switch (locale) {
    SoulLocale.vi => const [
      'Khoảnh khắc biết ơn',
      'Gia đình & Người thân',
      'Công việc & Sự nghiệp',
      'Bản thân & Bình yên',
      'Sức khỏe & Cơ thể',
    ],
    SoulLocale.en => const [
      'Grateful Moment',
      'Family & Loved Ones',
      'Work & Growth',
      'Self-Care & Peace',
      'Health & Body',
    ],
    SoulLocale.ko => const [
      '감사의 순간',
      '가족 & 소중한 사람들',
      '일 & 성장',
      '자기 돌봄 & 평온',
      '건강 & 몸',
    ],
    SoulLocale.ja => const ['感謝の瞬間', '家族＆大切な人', '仕事＆成長', 'セルフケア＆安らぎ', '健康＆身体'],
    SoulLocale.fr => const [
      'Moment de gratitude',
      'Famille & Proches',
      'Travail & Croissance',
      'Prendre soin de soi & Paix',
      'Santé & Corps',
    ],
    SoulLocale.zh => const ['感恩时刻', '家人与挚爱', '工作与成长', '自我关怀与宁静', '健康与身心'],
  };

  @override
  void initState() {
    super.initState();
    final existing = widget.existingNote;
    if (existing != null) {
      _selectedTheme = existing.title;
      _attachedLocalImagePath = existing.imagePath;
      _attachedAudioPath = existing.audioPath;
      final initialText = existing.sentences.join('\n');
      _contentController = TextEditingController(text: initialText);
    } else {
      _contentController = TextEditingController();
    }
    _contentController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _recorder.dispose();
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

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final recordedPath = await _recorder.stop();
      if (mounted) {
        setState(() {
          _isRecording = false;
          if (recordedPath != null && recordedPath.isNotEmpty) {
            _attachedAudioPath = recordedPath;
          }
        });
      }
      return;
    }
    if (!await _recorder.hasPermission()) {
      return;
    }
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory(path.join(documents.path, 'journal_audio'));
    await directory.create(recursive: true);
    final filePath = path.join(
      directory.path,
      'journal-${DateTime.now().millisecondsSinceEpoch}.m4a',
    );
    await _recorder.start(const RecordConfig(), path: filePath);
    if (mounted) {
      setState(() => _isRecording = true);
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

  bool get _canSave =>
      !_isSaving &&
      (_contentController.text.trim().isNotEmpty ||
          _attachedAudioPath != null ||
          _attachedLocalImagePath != null);

  Future<void> _save() async {
    if (!_canSave) return;

    setState(() => _isSaving = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      if (_isRecording) {
        final recordedPath = await _recorder.stop();
        _isRecording = false;
        if (recordedPath != null && recordedPath.isNotEmpty) {
          _attachedAudioPath = recordedPath;
        }
      }

      final rawText = _contentController.text.trim();
      final effectiveBody = rawText.isNotEmpty ? rawText : l10n.myRecording;
      final theme = _selectedTheme?.trim() ?? '';
      final fullGratitude =
          theme.isNotEmpty ? '[$theme]\n$effectiveBody' : effectiveBody;

      String? storedImagePath;
      if (_attachedLocalImagePath != null) {
        if (_attachedLocalImagePath!.startsWith('journal/') ||
            _attachedLocalImagePath!.startsWith('assets/')) {
          storedImagePath = _attachedLocalImagePath;
        } else {
          storedImagePath = await ref
              .read(imageStoreProvider)
              .saveJournalImage(_attachedLocalImagePath!);
        }
      }
      final encodedAttachments = encodeJournalAttachments(
        imagePath: storedImagePath,
        audioPath: _attachedAudioPath,
      );

      final existing = widget.existingNote;
      final repo = ref.read(gratitudeRepositoryProvider);

      if (existing != null && existing.rawEntries.isNotEmpty) {
        final firstId = existing.rawEntries.first.id;
        await repo.updateSingleEntry(
          id: firstId,
          gratitudeText: fullGratitude,
          reasonText: encodedAttachments,
        );
        for (int i = 1; i < existing.rawEntries.length; i++) {
          await repo.deleteEntry(existing.rawEntries[i].id);
        }
      } else {
        await repo.addSingleEntry(
          gratitudeText: fullGratitude,
          reasonText: encodedAttachments,
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
    final playback = ref.watch(audioPlaybackProvider);
    final suggestions = _suggestedThemesFor(locale);

    final effectiveTheme = _selectedTheme ?? suggestions.first;
    final isPlayingAudio =
        _attachedAudioPath != null &&
        playback.isPlaying &&
        playback.assetPath == _attachedAudioPath;

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
                          switch (locale) {
                            SoulLocale.vi => 'Chủ đề:',
                            SoulLocale.en => 'Theme:',
                            SoulLocale.ko => '주제:',
                            SoulLocale.ja => 'テーマ:',
                            SoulLocale.fr => 'Thème :',
                            SoulLocale.zh => '主题：',
                          },
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

                    // Minimal Icon-Only Toolbar (Template, Photo, Voice Recording)
                    Row(
                      children: [
                        IconButton(
                          onPressed: _insertPrompt,
                          tooltip: l10n.insertPromptTemplate,
                          icon: const Icon(
                            Icons.auto_fix_high_rounded,
                            size: 20,
                            color: SoulColors.plum,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: SoulColors.lilac.withValues(
                              alpha: 0.45,
                            ),
                          ),
                        ),
                        const SizedBox(width: SoulSpace.xs),
                        IconButton(
                          onPressed: _pickImage,
                          tooltip:
                              _attachedLocalImagePath == null
                                  ? l10n.addPhoto
                                  : l10n.changePhoto,
                          icon: Icon(
                            _attachedLocalImagePath == null
                                ? Icons.add_photo_alternate_outlined
                                : Icons.photo_library_rounded,
                            size: 20,
                            color: SoulColors.plum,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: SoulColors.lilac.withValues(
                              alpha: 0.45,
                            ),
                          ),
                        ),
                        const SizedBox(width: SoulSpace.xs),
                        IconButton(
                          onPressed: _toggleRecording,
                          tooltip:
                              _isRecording
                                  ? l10n.stopRecording
                                  : l10n.recordAudio,
                          icon: Icon(
                            _isRecording
                                ? Icons.stop_circle_rounded
                                : Icons.mic_none_rounded,
                            size: 20,
                            color:
                                _isRecording
                                    ? const Color(0xFFB3261E)
                                    : SoulColors.plum,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                _isRecording
                                    ? const Color(0xFFFCE8E6)
                                    : SoulColors.lilac.withValues(alpha: 0.45),
                          ),
                        ),
                        if (_isRecording) ...[
                          const SizedBox(width: SoulSpace.xs),
                          Expanded(
                            child: Text(
                              l10n.stopRecording,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(
                                context,
                              ).textTheme.labelSmall?.copyWith(
                                color: const Color(0xFFB3261E),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const Divider(color: SoulColors.line, height: 12),

                    // Attached voice recording pill
                    if (_attachedAudioPath != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: SoulSpace.sm,
                          vertical: SoulSpace.xs,
                        ),
                        decoration: BoxDecoration(
                          color: SoulColors.lilac.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(SoulRadius.card),
                          border: Border.all(color: SoulColors.selectedBorder),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                ref
                                    .read(audioPlaybackProvider)
                                    .toggleFile(_attachedAudioPath!);
                              },
                              icon: Icon(
                                isPlayingAudio
                                    ? Icons.pause_circle_filled_rounded
                                    : Icons.play_circle_fill_rounded,
                                color: SoulColors.plum,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: SoulSpace.xxs),
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.graphic_eq_rounded,
                                    size: 16,
                                    color: SoulColors.plum,
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      l10n.myRecording,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.copyWith(
                                        color: SoulColors.plum,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  if (isPlayingAudio) ...[
                                    const SizedBox(width: 8),
                                    const SoulAudioWave(
                                      isPlaying: true,
                                      barColor: SoulColors.plum,
                                      barCount: 4,
                                      height: 12,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (isPlayingAudio) {
                                  ref.read(audioPlaybackProvider).stop();
                                }
                                setState(() => _attachedAudioPath = null);
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: SoulColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: SoulSpace.sm),
                    ],

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
                onPressed: _canSave ? _save : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

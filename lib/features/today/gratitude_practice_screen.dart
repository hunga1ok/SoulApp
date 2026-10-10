import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../app/app_state.dart';
import '../../core/audio/audio_playback_controller.dart';
import '../../core/design_system/design_system.dart';
import '../../core/platform/image_picking.dart';
import '../../data/local/image_store.dart';
import '../../data/repositories/gratitude_repository.dart';
import '../../data/repositories/journey_repository.dart';
import '../../l10n/app_localizations.dart';
import '../journal/journal_note_models.dart';

class GratitudePracticeScreen extends ConsumerStatefulWidget {
  const GratitudePracticeScreen({super.key});

  @override
  ConsumerState<GratitudePracticeScreen> createState() =>
      _GratitudePracticeScreenState();
}

class _GratitudePracticeScreenState
    extends ConsumerState<GratitudePracticeScreen> {
  static const String _calmTrackAsset =
      'assets/audio/music/so-11-warm-felt-piano.m4a';

  late final TextEditingController _contentController;
  final AudioRecorder _recorder = AudioRecorder();
  bool _isSaving = false;
  bool _isRecording = false;
  bool _isGuidanceExpanded = false;
  String? _attachedLocalImagePath;
  String? _attachedAudioPath;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
    _contentController.addListener(() => setState(() {}));
    _loadExistingEntries();
  }

  @override
  void dispose() {
    _recorder.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingEntries() async {
    final entries = await ref
        .read(gratitudeRepositoryProvider)
        .getEntriesForDay(1);
    if (entries.isNotEmpty && mounted) {
      final lines = <String>[];
      String? foundImage;
      String? foundAudio;
      for (final e in entries) {
        if (e.gratitudeText.trim().isNotEmpty) {
          lines.add(e.gratitudeText.trim());
        }
        final parsed = parseJournalAttachments(e.reasonText);
        foundImage ??= parsed.imagePath;
        foundAudio ??= parsed.audioPath;
      }
      if (lines.isNotEmpty && _contentController.text.isEmpty) {
        setState(() {
          _contentController.text = lines.join('\n\n');
          _attachedAudioPath ??= foundAudio;
        });
      }
    }
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
      'gratitude-${DateTime.now().millisecondsSinceEpoch}.m4a',
    );
    await _recorder.start(const RecordConfig(), path: filePath);
    if (mounted) {
      setState(() => _isRecording = true);
    }
  }

  void _insertTemplatePrompt() {
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

  bool get _canComplete =>
      !_isSaving &&
      (_contentController.text.trim().isNotEmpty ||
          _attachedAudioPath != null ||
          _attachedLocalImagePath != null);

  Future<void> _completePractice() async {
    if (!_canComplete) return;

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
      final text = rawText.isNotEmpty ? rawText : l10n.myRecording;
      final journeyRepo = ref.read(journeyRepositoryProvider);
      final activeJourney = await journeyRepo.activeJourney();

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

      final gratitudeRepo = ref.read(gratitudeRepositoryProvider);

      // Split lines/bullet points if formatted as distinct paragraphs/lines
      final rawLines =
          text
              .split('\n')
              .map((line) => line.trim())
              .where((line) => line.isNotEmpty)
              .toList();

      if (rawLines.length > 1) {
        final draftItems = <GratitudeDraftItem>[];
        for (int i = 0; i < rawLines.length; i++) {
          draftItems.add(
            GratitudeDraftItem(
              gratitudeText: rawLines[i],
              reasonText: i == 0 ? (encodedAttachments ?? '') : '',
              thankYouTaps: 1,
            ),
          );
        }
        await gratitudeRepo.saveEntries(
          journeyDay: 1,
          userJourneyId: activeJourney?.id,
          items: draftItems,
        );
      } else {
        await gratitudeRepo.addSingleEntry(
          gratitudeText: text,
          reasonText: encodedAttachments,
          journeyDay: 1,
          userJourneyId: activeJourney?.id,
        );
      }

      ref.invalidate(todayGratitudeEntriesProvider);
      ref.invalidate(recentGratitudeEntriesProvider);

      if (!mounted) return;
      _showCompletionDialog(context, l10n);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.somethingWentWrong)));
    }
  }

  void _showCompletionDialog(BuildContext context, AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: SoulColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SoulRadius.card),
          ),
          child: Padding(
            padding: const EdgeInsets.all(SoulSpace.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: SoulColors.lilac,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: SoulColors.plum,
                    size: 30,
                  ),
                ),
                const SizedBox(height: SoulSpace.md),
                Text(
                  l10n.gratitudeCompletedTitle,
                  style: Theme.of(
                    dialogContext,
                  ).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: SoulColors.softInk,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: SoulSpace.sm),
                Text(
                  l10n.gratitudeCompletedBody,
                  style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
                    color: SoulColors.muted,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: SoulSpace.xl),
                SoulButton(
                  label: l10n.gratitudeBackToToday,
                  onPressed: () {
                    Navigator.pop(dialogContext); // pop dialog
                    context.pop(); // return to Today
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(appStateProvider).locale ?? SoulLocale.vi;
    final playback = ref.watch(audioPlaybackProvider);
    final dayTheme = JourneyDayThemes.getTitle(1, locale);
    final isPlayingAudio =
        _attachedAudioPath != null &&
        playback.isPlaying &&
        playback.assetPath == _attachedAudioPath;

    return Scaffold(
      backgroundColor: SoulColors.paper,
      appBar: SoulAppBar(
        title: l10n.gratitudePracticeTitle,
        onBack: () => context.pop(),
        actions: const [
          _AudioIndicator(assetPath: _calmTrackAsset),
          SizedBox(width: SoulSpace.sm),
        ],
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
              // Daily Guidance Card (Expandable dropdown)
              InkWell(
                onTap: () {
                  setState(() {
                    _isGuidanceExpanded = !_isGuidanceExpanded;
                  });
                },
                borderRadius: BorderRadius.circular(SoulRadius.card),
                child: Container(
                  decoration: BoxDecoration(
                    color: SoulColors.surface,
                    borderRadius: BorderRadius.circular(SoulRadius.card),
                    border: Border.all(color: SoulColors.line),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: SoulSpace.md,
                    vertical: SoulSpace.sm,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            l10n.dayProgress(1).toUpperCase(),
                            style: Theme.of(
                              context,
                            ).textTheme.labelSmall?.copyWith(
                              color: SoulColors.plum,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(width: SoulSpace.xs),
                          const Text(
                            '·',
                            style: TextStyle(color: SoulColors.muted),
                          ),
                          const SizedBox(width: SoulSpace.xs),
                          Expanded(
                            child: Text(
                              dayTheme,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: SoulColors.softInk,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            _isGuidanceExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: SoulColors.plum,
                            size: 20,
                          ),
                        ],
                      ),
                      if (_isGuidanceExpanded) ...[
                        const SizedBox(height: SoulSpace.xs),
                        const Divider(color: SoulColors.line, height: 12),
                        const SizedBox(height: SoulSpace.xs),
                        Text(
                          l10n.gratitudeJournalPrompt,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: SoulColors.softInk.withValues(alpha: 0.85),
                            height: 1.55,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: SoulSpace.md),

              // Journal Paper Editor Card
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
                    // Minimal Icon-Only Toolbar (Template, Photo, Voice Recording)
                    Row(
                      children: [
                        IconButton(
                          onPressed: _insertTemplatePrompt,
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

                    // Ruled text editing field
                    TextField(
                      controller: _contentController,
                      maxLines: 15,
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
                onPressed: _canComplete ? _completePractice : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AudioIndicator extends ConsumerWidget {
  const _AudioIndicator({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundEnabled = ref.watch(appStateProvider).soundEnabled;
    final audio = ref.watch(audioPlaybackProvider);
    final isPlaying = audio.isPlaying && audio.assetPath == assetPath;

    if (!soundEnabled) return const SizedBox.shrink();

    return IconButton(
      icon: Icon(
        isPlaying ? Icons.music_note : Icons.music_off_outlined,
        color: isPlaying ? SoulColors.softInk : SoulColors.muted,
      ),
      tooltip: isPlaying ? 'Pause sound' : 'Play sound',
      onPressed: () {
        ref.read(audioPlaybackProvider).toggleAsset(assetPath);
      },
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  bool _isSaving = false;
  bool _isGuidanceExpanded = false;
  String? _attachedLocalImagePath;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
    _contentController.addListener(() => setState(() {}));
    _loadExistingEntries();
  }

  @override
  void dispose() {
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
      for (final e in entries) {
        if (e.gratitudeText.trim().isNotEmpty) {
          lines.add(e.gratitudeText.trim());
        }
        if (e.reasonText.startsWith('image:')) {
          foundImage ??= e.reasonText.substring('image:'.length).trim();
        }
      }
      if (lines.isNotEmpty && _contentController.text.isEmpty) {
        setState(() {
          _contentController.text = lines.join('\n\n');
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

  Future<void> _completePractice() async {
    final text = _contentController.text.trim();
    if (text.isEmpty || _isSaving) return;

    setState(() => _isSaving = true);
    final l10n = AppLocalizations.of(context)!;

    try {
      final journeyRepo = ref.read(journeyRepositoryProvider);
      final activeJourney = await journeyRepo.activeJourney();

      String? reasonWithImage;
      if (_attachedLocalImagePath != null) {
        final relPath = await ref
            .read(imageStoreProvider)
            .saveJournalImage(_attachedLocalImagePath!);
        reasonWithImage = 'image:$relPath';
      }

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
              reasonText: i == 0 ? (reasonWithImage ?? '') : '',
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
          reasonText: reasonWithImage,
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
    final dayTheme = JourneyDayThemes.getTitle(1, locale);

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
                    // Toolbar
                    Wrap(
                      spacing: SoulSpace.xs,
                      runSpacing: SoulSpace.xxs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: _insertTemplatePrompt,
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
                onPressed:
                    _contentController.text.trim().isEmpty || _isSaving
                        ? null
                        : _completePractice,
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

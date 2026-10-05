import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/audio/audio_playback_controller.dart';
import '../../core/design_system/design_system.dart';
import '../../data/repositories/gratitude_repository.dart';
import '../../data/repositories/journey_repository.dart';
import '../../l10n/app_localizations.dart';

enum _GratitudeFlowStage { intro, practicing, reviewing, completed }

class GratitudePracticeScreen extends ConsumerStatefulWidget {
  const GratitudePracticeScreen({super.key});

  @override
  ConsumerState<GratitudePracticeScreen> createState() =>
      _GratitudePracticeScreenState();
}

class _GratitudePracticeScreenState
    extends ConsumerState<GratitudePracticeScreen> {
  static const int _totalCount = 10;
  static const String _calmTrackAsset =
      'assets/audio/music/so-11-warm-felt-piano.m4a';

  _GratitudeFlowStage _stage = _GratitudeFlowStage.intro;
  int _currentIndex = 0;
  final List<GratitudeDraftItem> _items = List.generate(
    _totalCount,
    (_) => GratitudeDraftItem(),
  );

  late final TextEditingController _gratitudeController;
  late final TextEditingController _reasonController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _gratitudeController = TextEditingController();
    _reasonController = TextEditingController();
    _loadCurrentItemIntoControllers();
  }

  @override
  void dispose() {
    _gratitudeController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _loadCurrentItemIntoControllers() {
    final item = _items[_currentIndex];
    _gratitudeController.text = item.gratitudeText;
    _reasonController.text = item.reasonText;
  }

  void _syncControllersToCurrentItem() {
    final item = _items[_currentIndex];
    item.gratitudeText = _gratitudeController.text;
    item.reasonText = _reasonController.text;
  }

  bool get _hasAnyFilledItem {
    return _items.any((item) => item.gratitudeText.trim().isNotEmpty) ||
        _gratitudeController.text.trim().isNotEmpty;
  }

  void _onNext() {
    _syncControllersToCurrentItem();
    if (_currentIndex < _totalCount - 1) {
      setState(() {
        _currentIndex++;
        _loadCurrentItemIntoControllers();
      });
    } else {
      setState(() {
        _stage = _GratitudeFlowStage.reviewing;
      });
    }
  }

  void _onPrevious() {
    _syncControllersToCurrentItem();
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _loadCurrentItemIntoControllers();
      });
    }
  }

  void _onSkipProgress() {
    _syncControllersToCurrentItem();
    final currentItem = _items[_currentIndex];
    if (currentItem.gratitudeText.trim().isNotEmpty &&
        currentItem.thankYouTaps == 0) {
      currentItem.thankYouTaps = 1;
    }
    if (_hasAnyFilledItem) {
      setState(() => _stage = _GratitudeFlowStage.reviewing);
    } else {
      _completePractice();
    }
  }

  void _onEditFromReview(int index) {
    setState(() {
      _currentIndex = index;
      _stage = _GratitudeFlowStage.practicing;
      _loadCurrentItemIntoControllers();
    });
  }

  void _onSelectLevel(int level) {
    HapticFeedback.selectionClick();
    setState(() {
      _items[_currentIndex].thankYouTaps = level;
    });
  }

  Future<void> _completePractice() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final journeyRepo = ref.read(journeyRepositoryProvider);
      final activeJourney = await journeyRepo.activeJourney();

      final filledItems =
          _items.where((i) => i.gratitudeText.trim().isNotEmpty).toList();

      final gratitudeRepo = ref.read(gratitudeRepositoryProvider);
      await gratitudeRepo.saveEntries(
        journeyDay: 1,
        userJourneyId: activeJourney?.id,
        items: filledItems,
      );

      ref.invalidate(todayGratitudeEntriesProvider);
      ref.invalidate(recentGratitudeEntriesProvider);

      if (!mounted) return;
      setState(() {
        _isSaving = false;
        _stage = _GratitudeFlowStage.completed;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.somethingWentWrong),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: SoulColors.paper,
      appBar: SoulAppBar(
        title: l10n.gratitudePracticeTitle,
        onBack:
            _stage == _GratitudeFlowStage.completed
                ? null
                : () {
                  if (_stage == _GratitudeFlowStage.reviewing) {
                    setState(() => _stage = _GratitudeFlowStage.practicing);
                  } else if (_stage == _GratitudeFlowStage.practicing &&
                      _currentIndex > 0) {
                    _onPrevious();
                  } else {
                    context.pop();
                  }
                },
        actions: [
          if (_stage == _GratitudeFlowStage.intro ||
              _stage == _GratitudeFlowStage.practicing)
            TextButton(
              onPressed: _onSkipProgress,
              child: Text(
                l10n.gratitudeSkipProgress,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: SoulColors.plum,
                ),
              ),
            ),
          const _AudioIndicator(assetPath: _calmTrackAsset),
          const SizedBox(width: SoulSpace.sm),
        ],
      ),
      body: SafeArea(
        child: switch (_stage) {
          _GratitudeFlowStage.intro => _buildIntroView(context, l10n),
          _GratitudeFlowStage.practicing => _buildPracticingView(context, l10n),
          _GratitudeFlowStage.reviewing => _buildReviewView(context, l10n),
          _GratitudeFlowStage.completed => _buildCompletedView(context, l10n),
        },
      ),
    );
  }

  Widget _buildIntroView(BuildContext context, AppLocalizations l10n) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(SoulSpace.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(SoulSpace.xl),
                      decoration: BoxDecoration(
                        color: SoulColors.rose,
                        borderRadius: BorderRadius.circular(SoulRadius.card),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.favorite_rounded,
                            size: 48,
                            color: SoulColors.softInk,
                          ),
                          const SizedBox(height: SoulSpace.md),
                          Text(
                            l10n.gratitudePracticeIntroTitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: SoulSpace.sm),
                          Text(
                            l10n.gratitudePracticeIntroBody,
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color: SoulColors.muted,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SoulButton(
                      label: l10n.gratitudeStartPractice,
                      onPressed: () {
                        setState(() => _stage = _GratitudeFlowStage.practicing);
                      },
                    ),
                    const SizedBox(height: SoulSpace.md),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPracticingView(BuildContext context, AppLocalizations l10n) {
    final currentItem = _items[_currentIndex];
    final isFormValid =
        _gratitudeController.text.trim().isNotEmpty &&
        currentItem.thankYouTaps >= 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: SoulSpace.lg,
        vertical: SoulSpace.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.gratitudeItemProgress(_currentIndex + 1, _totalCount),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: SoulColors.muted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${((_currentIndex + 1) / _totalCount * 100).round()}%',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: SoulColors.muted),
              ),
            ],
          ),
          const SizedBox(height: SoulSpace.xs),
          SoulProgressBar(
            value: (_currentIndex + 1) / _totalCount,
            semanticsLabel: l10n.gratitudeItemProgress(
              _currentIndex + 1,
              _totalCount,
            ),
          ),
          const SizedBox(height: SoulSpace.xl),

          // Field 1: Gratitude Item
          Text(
            l10n.gratitudeFieldPrompt,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SoulSpace.sm),
          SoulTextField(
            controller: _gratitudeController,
            label: l10n.gratitudeFieldPrompt,
            hint: l10n.gratitudeFieldPlaceholder,
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (val) {
              setState(() {
                currentItem.gratitudeText = val;
              });
            },
          ),
          const SizedBox(height: SoulSpace.xl),

          // Field 2: Reason ("Vì sao...")
          Text(
            l10n.gratitudeReasonPrompt,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SoulSpace.sm),
          SoulTextField(
            controller: _reasonController,
            label: l10n.gratitudeReasonPrompt,
            hint: l10n.gratitudeReasonPlaceholder,
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (val) {
              setState(() {
                currentItem.reasonText = val;
              });
            },
          ),
          const SizedBox(height: SoulSpace.xl),

          // 1-click Intensity / Level selection
          Text(
            l10n.gratitudeTapLevelHint,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: SoulColors.muted,
            ),
          ),
          const SizedBox(height: SoulSpace.sm),
          Row(
            children: [
              for (int level = 1; level <= 3; level++) ...[
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(SoulRadius.card),
                    onTap: () => _onSelectLevel(level),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        vertical: SoulSpace.md,
                        horizontal: SoulSpace.xs,
                      ),
                      decoration: BoxDecoration(
                        color:
                            currentItem.thankYouTaps == level
                                ? SoulColors.lilac
                                : SoulColors.surface,
                        borderRadius: BorderRadius.circular(SoulRadius.card),
                        border: Border.all(
                          color:
                              currentItem.thankYouTaps == level
                                  ? SoulColors.lilacStrong
                                  : SoulColors.line,
                          width: currentItem.thankYouTaps == level ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int t = 1; t <= level; t++)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 16,
                                  color: SoulColors.gold,
                                ),
                            ],
                          ),
                          const SizedBox(height: SoulSpace.xs),
                          Text(
                            switch (level) {
                              1 => l10n.gratitudeLevelLow,
                              2 => l10n.gratitudeLevelMedium,
                              _ => l10n.gratitudeLevelHigh,
                            },
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              fontWeight:
                                  currentItem.thankYouTaps == level
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              color:
                                  currentItem.thankYouTaps == level
                                      ? SoulColors.softInk
                                      : SoulColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (level < 3) const SizedBox(width: SoulSpace.sm),
              ],
            ],
          ),
          const SizedBox(height: SoulSpace.xl),

          // Primary Navigation Button
          SoulButton(
            label:
                _currentIndex == _totalCount - 1
                    ? l10n.gratitudeReviewTitle
                    : l10n.gratitudeAddAndNext,
            onPressed: isFormValid ? _onNext : null,
          ),
          const SizedBox(height: SoulSpace.sm),

          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: SoulSpace.md,
            children: [
              if (_currentIndex > 0)
                TextButton(
                  onPressed: _onPrevious,
                  child: Text(
                    l10n.cancel,
                    style: const TextStyle(color: SoulColors.muted),
                  ),
                ),
              TextButton(
                onPressed: _onSkipProgress,
                child: Text(
                  l10n.gratitudeSkipProgress,
                  style: const TextStyle(
                    color: SoulColors.plum,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SoulSpace.lg),
        ],
      ),
    );
  }

  Widget _buildReviewView(BuildContext context, AppLocalizations l10n) {
    final filledIndices = <int>[];
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].gratitudeText.trim().isNotEmpty) {
        filledIndices.add(i);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            SoulSpace.lg,
            SoulSpace.md,
            SoulSpace.lg,
            SoulSpace.sm,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.gratitudeReviewTitleCount(filledIndices.length),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: SoulSpace.xs),
              Text(
                l10n.gratitudeReviewSubtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: SoulColors.muted),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: SoulSpace.lg,
              vertical: SoulSpace.sm,
            ),
            itemCount: filledIndices.length,
            separatorBuilder: (_, _) => const SizedBox(height: SoulSpace.sm),
            itemBuilder: (context, displayIndex) {
              final originalIndex = filledIndices[displayIndex];
              final item = _items[originalIndex];
              return SoulCard(
                color: SoulColors.surface,
                padding: const EdgeInsets.all(SoulSpace.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: SoulColors.lilac,
                      child: Text(
                        '${displayIndex + 1}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: SoulColors.lilacStrong,
                        ),
                      ),
                    ),
                    const SizedBox(width: SoulSpace.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.gratitudeText,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          if (item.reasonText.trim().isNotEmpty) ...[
                            const SizedBox(height: SoulSpace.xs),
                            Text(
                              l10n.gratitudeReasonLabel(item.reasonText),
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(
                                color: SoulColors.muted,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      color: SoulColors.muted,
                      onPressed: () => _onEditFromReview(originalIndex),
                      tooltip: l10n.editEntry,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(SoulSpace.lg),
          child: SoulButton(
            label: l10n.gratitudeCompletePractice,
            onPressed:
                _isSaving || filledIndices.isEmpty ? null : _completePractice,
          ),
        ),
      ],
    );
  }

  Widget _buildCompletedView(BuildContext context, AppLocalizations l10n) {
    final filledCount =
        _items.where((i) => i.gratitudeText.trim().isNotEmpty).length;
    final isSkipped = filledCount == 0;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(SoulSpace.xl),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(SoulSpace.xl),
                      decoration: BoxDecoration(
                        color:
                            isSkipped ? SoulColors.surface : SoulColors.lilac,
                        borderRadius: BorderRadius.circular(SoulRadius.card),
                        border:
                            isSkipped
                                ? Border.all(color: SoulColors.line)
                                : null,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            isSkipped
                                ? Icons.pause_circle_outline_rounded
                                : Icons.auto_awesome_rounded,
                            size: 56,
                            color:
                                isSkipped
                                    ? SoulColors.muted
                                    : SoulColors.lilacStrong,
                          ),
                          const SizedBox(height: SoulSpace.md),
                          Text(
                            isSkipped
                                ? l10n.gratitudeSkippedTitle
                                : l10n.gratitudeCompletedTitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: SoulSpace.sm),
                          Text(
                            isSkipped
                                ? l10n.gratitudeSkippedBody
                                : l10n.gratitudeCompletedBodyCount(filledCount),
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color: SoulColors.muted,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    SoulButton(
                      label: l10n.gratitudeBackToToday,
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(height: SoulSpace.md),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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

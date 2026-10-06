import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../core/audio/audio_playback_controller.dart';
import '../../core/design_system/design_system.dart';
import '../../data/content/card_catalog.dart';
import '../../data/content/content_repository.dart';
import '../../data/repositories/card_draw_repository.dart';
import '../../data/repositories/gratitude_repository.dart';
import '../../l10n/app_localizations.dart';
import 'card_flip_widget.dart';

class CardsDrawScreen extends ConsumerStatefulWidget {
  const CardsDrawScreen({super.key, required this.deckId});

  final String deckId;

  @override
  ConsumerState<CardsDrawScreen> createState() => _CardsDrawScreenState();
}

class _CardsDrawScreenState extends ConsumerState<CardsDrawScreen> {
  SoulCardItem? _drawnCard;
  CardDeck? _currentDeck;
  bool _isFlipped = false;
  bool _isSavedToJournal = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAmbientSound();
    });
  }

  Future<void> _startAmbientSound() async {
    final appState = ref.read(appStateProvider);
    if (!appState.soundEnabled) return;

    final catalog = ref.read(cardCatalogProvider).valueOrNull;
    final deck = catalog?.deck(widget.deckId);
    if (deck == null) return;

    final audioCatalog = ref.read(audioCatalogProvider).valueOrNull;
    final track = audioCatalog?.asset(deck.ambientTrackId);
    if (track?.assetPath != null) {
      await ref.read(audioPlaybackProvider).toggleAsset(track!.assetPath!);
    }
  }

  void _showDailyLimitPopup(AppLocalizations l10n) {
    showDialog<void>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SoulRadius.card),
            ),
            title: Row(
              children: [
                const Icon(
                  Icons.nightlight_round,
                  color: SoulColors.plum,
                  size: 24,
                ),
                const SizedBox(width: SoulSpace.xs),
                Expanded(
                  child: Text(
                    l10n.dailyDrawLimitDialogTitle,
                    style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: SoulColors.plum,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              l10n.dailyDrawLimitDialogMessage,
              style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                color: SoulColors.softInk,
                height: 1.5,
              ),
            ),
            actions: [
              SoulButton(
                label: l10n.understood,
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
    );
  }

  Future<void> _handleDraw(CardDeck deck) async {
    final drawState = ref.read(cardDrawProvider);
    final l10n = AppLocalizations.of(context)!;

    if (!drawState.canDraw) {
      _showDailyLimitPopup(l10n);
      return;
    }

    final random = Random();
    final card = deck.cards[random.nextInt(deck.cards.length)];

    await ref
        .read(cardDrawProvider.notifier)
        .recordDraw(deckId: deck.id, cardId: card.id);

    if (!mounted) return;
    setState(() {
      _drawnCard = card;
      _currentDeck = deck;
      _isFlipped = true;
      _isSavedToJournal = false;
    });
  }

  void _handleDrawAnother(CardDeck deck) {
    final drawState = ref.read(cardDrawProvider);
    final l10n = AppLocalizations.of(context)!;

    if (!drawState.canDraw) {
      _showDailyLimitPopup(l10n);
      return;
    }

    setState(() {
      _drawnCard = null;
      _isFlipped = false;
      _isSavedToJournal = false;
    });
  }

  Future<void> _saveToJournal(SoulCardItem card, CardDeck deck) async {
    if (_isSavedToJournal) return;
    final l10n = AppLocalizations.of(context)!;
    final gratitudeRepo = ref.read(gratitudeRepositoryProvider);

    await gratitudeRepo.addSingleEntry(
      gratitudeText: card.text,
      reasonText: '${l10n.todayCardDrawBanner} (${deck.title})',
    );

    if (!mounted) return;
    setState(() {
      _isSavedToJournal = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.savedToJournalSuccess),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Color _getDeckColor(String deckId) {
    switch (deckId) {
      case 'healing':
        return SoulColors.ctaStart;
      case 'career':
        return SoulColors.gold;
      case 'relationship':
        return SoulColors.lilacStrong;
      default:
        return SoulColors.plum;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appState = ref.watch(appStateProvider);
    final catalogAsync = ref.watch(cardCatalogProvider);
    final drawState = ref.watch(cardDrawProvider);

    return catalogAsync.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (err, _) => Scaffold(
            appBar: AppBar(),
            body: Center(child: Text(err.toString())),
          ),
      data: (catalog) {
        final deck = catalog.deck(widget.deckId) ?? catalog.decks.first;

        return Scaffold(
          appBar: SoulAppBar(
            title: deck.title,
            onBack: () => Navigator.of(context).maybePop(),
            actions: [
              IconButton(
                tooltip: appState.soundEnabled ? l10n.soundOn : l10n.soundOff,
                onPressed: () async {
                  final enabled = !appState.soundEnabled;
                  await appState.setSoundEnabled(enabled);
                  if (!enabled) {
                    await ref.read(audioPlaybackProvider).stop();
                  } else {
                    await _startAmbientSound();
                  }
                },
                isSelected: appState.soundEnabled,
                icon: Icon(
                  appState.soundEnabled
                      ? Icons.volume_up_outlined
                      : Icons.volume_off_outlined,
                ),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: SoulSpace.lg,
              vertical: SoulSpace.md,
            ),
            children: [
              // Deck subtitle
              Text(
                deck.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: SoulColors.muted,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: SoulSpace.lg),

              // Card Flip Area (Focus is 100% on card and message)
              Center(
                child: SizedBox(
                  width: 310,
                  height: 480,
                  child: GestureDetector(
                    onTap: () {
                      if (!_isFlipped) {
                        _handleDraw(deck);
                      }
                    },
                    child: CardFlipWidget(
                      isFlipped: _isFlipped,
                      back: SoulCardBack(
                        deckTitle: deck.title,
                        color: SoulColors.plum,
                        accentColor: _getDeckColor(deck.id),
                      ),
                      front:
                          _drawnCard != null
                              ? _buildCardFront(
                                context,
                                _drawnCard!,
                                _currentDeck ?? deck,
                              )
                              : const SizedBox.shrink(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: SoulSpace.lg),

              // Action buttons
              if (!_isFlipped) ...[
                Center(
                  child: Text(
                    l10n.tapCardToReveal,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: SoulColors.muted),
                  ),
                ),
                const SizedBox(height: SoulSpace.sm),
                SoulButton(
                  label: l10n.drawCardAction,
                  icon: const Icon(Icons.touch_app_outlined),
                  onPressed: () => _handleDraw(deck),
                ),
              ] else ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SoulButton(
                        label:
                            _isSavedToJournal
                                ? l10n.savedToJournalSuccess
                                : l10n.saveToJournalAction,
                        icon: Icon(
                          _isSavedToJournal
                              ? Icons.check
                              : Icons.bookmark_border,
                        ),
                        variant: SoulButtonVariant.secondary,
                        onPressed:
                            _isSavedToJournal
                                ? null
                                : () => _saveToJournal(_drawnCard!, deck),
                      ),
                    ),
                    const SizedBox(width: SoulSpace.sm),
                    Expanded(
                      child: SoulButton(
                        label: l10n.drawAnotherCard,
                        icon: const Icon(Icons.replay),
                        onPressed: () => _handleDrawAnother(deck),
                      ),
                    ),
                  ],
                ),
              ],

              // Today's history from this deck or all decks
              if (drawState.todayEntries.isNotEmpty) ...[
                const SizedBox(height: SoulSpace.xl),
                Text(
                  l10n.reviewTodayCards,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: SoulColors.plum,
                  ),
                ),
                const SizedBox(height: SoulSpace.sm),
                for (final entry in drawState.todayEntries)
                  _buildTodayEntryCard(context, catalog, entry),
                const SizedBox(height: SoulSpace.lg),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardFront(
    BuildContext context,
    SoulCardItem card,
    CardDeck deck,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: SoulColors.surface,
        borderRadius: BorderRadius.circular(SoulRadius.card),
        border: Border.all(color: SoulColors.line),
        boxShadow: [
          BoxShadow(
            color: SoulColors.plum.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Card art image
          Expanded(
            flex: 6,
            child: Image.asset(
              card.imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),

          // Message content
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(SoulSpace.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        deck.title.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: _getDeckColor(deck.id),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        '#${card.number}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: SoulColors.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SoulSpace.xxs),
                  Expanded(
                    child: Center(
                      child: Text(
                        card.text,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: SoulColors.plum,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayEntryCard(
    BuildContext context,
    CardCatalog catalog,
    CardDrawEntry entry,
  ) {
    final deck = catalog.deck(entry.deckId);
    final card = deck?.cards.firstWhere(
      (c) => c.id == entry.cardId,
      orElse: () => deck.cards.first,
    );

    if (deck == null || card == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: SoulSpace.sm),
      padding: const EdgeInsets.all(SoulSpace.md),
      decoration: BoxDecoration(
        color: SoulColors.surface,
        borderRadius: BorderRadius.circular(SoulRadius.card),
        border: Border.all(color: SoulColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(SoulRadius.button),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Image.asset(card.imagePath, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: SoulSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deck.title,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: _getDeckColor(deck.id),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SoulSpace.xxs),
                Text(
                  card.text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: SoulColors.plum,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

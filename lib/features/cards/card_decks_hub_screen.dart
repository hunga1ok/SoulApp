import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_system/design_system.dart';
import '../../data/content/card_catalog.dart';
import '../../data/repositories/card_draw_repository.dart';
import '../../l10n/app_localizations.dart';

class CardDecksHubScreen extends ConsumerWidget {
  const CardDecksHubScreen({super.key});

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

  IconData _getDeckIcon(String deckId) {
    switch (deckId) {
      case 'healing':
        return Icons.water_drop_outlined;
      case 'career':
        return Icons.eco_outlined;
      case 'relationship':
        return Icons.favorite_border_rounded;
      default:
        return Icons.auto_awesome;
    }
  }

  String _getDeckCoverImage(String deckId) {
    switch (deckId) {
      case 'healing':
        return 'assets/images/cards/healing/card_32.webp';
      case 'career':
        return 'assets/images/cards/career/card_01.webp';
      case 'relationship':
        return 'assets/images/cards/relationship/card_01.webp';
      default:
        return 'assets/images/cards/healing/card_01.webp';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final catalogAsync = ref.watch(cardCatalogProvider);
    final drawState = ref.watch(cardDrawProvider);

    return Scaffold(
      body: catalogAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
        data: (catalog) {
          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: SoulSpace.lg,
              vertical: SoulSpace.md,
            ),
            children: [
              // Header title and subtitle
              Text(
                l10n.soulCardsTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: SoulColors.plum,
                ),
              ),
              const SizedBox(height: SoulSpace.xxs),
              Text(
                l10n.chooseDeckSubtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: SoulColors.softInk),
              ),
              const SizedBox(height: SoulSpace.lg),

              // 3 Decks visual cards
              for (final deck in catalog.decks) ...[
                _buildDeckCard(context, l10n, deck),
                const SizedBox(height: SoulSpace.md),
              ],

              // Today's Drawn Messages (if any)
              if (drawState.todayEntries.isNotEmpty) ...[
                const SizedBox(height: SoulSpace.md),
                Text(
                  l10n.reviewTodayCards,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
          );
        },
      ),
    );
  }

  Widget _buildDeckCard(
    BuildContext context,
    AppLocalizations l10n,
    CardDeck deck,
  ) {
    final deckColor = _getDeckColor(deck.id);
    final deckIcon = _getDeckIcon(deck.id);
    final coverImage = _getDeckCoverImage(deck.id);

    return InkWell(
      onTap: () => context.push('/cards/${deck.id}'),
      borderRadius: BorderRadius.circular(SoulRadius.card),
      child: Container(
        decoration: BoxDecoration(
          color: SoulColors.surface,
          borderRadius: BorderRadius.circular(SoulRadius.card),
          border: Border.all(color: SoulColors.line),
          boxShadow: [
            BoxShadow(
              color: SoulColors.plum.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Illustrated cover banner
            Stack(
              children: [
                SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: Image.asset(coverImage, fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: SoulSpace.sm,
                  left: SoulSpace.sm,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SoulSpace.sm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(SoulRadius.button),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(deckIcon, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          l10n.deckCardCount(deck.cardCount),
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: SoulSpace.sm,
                  left: SoulSpace.md,
                  right: SoulSpace.md,
                  child: Text(
                    deck.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.7),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Card description and action
            Padding(
              padding: const EdgeInsets.all(SoulSpace.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deck.subtitle,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: deckColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: SoulSpace.xxs),
                  Text(
                    deck.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: SoulColors.softInk,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: SoulSpace.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          l10n.drawFromThisDeck,
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge?.copyWith(
                            color: deckColor,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: deckColor,
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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

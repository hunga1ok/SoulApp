import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import 'content_repository.dart';

class SoulCardItem {
  const SoulCardItem({
    required this.id,
    required this.number,
    required this.text,
    required this.imagePrompt,
    required this.imagePath,
  });

  final String id;
  final int number;
  final String text;
  final String imagePrompt;
  final String imagePath;
}

class CardDeck {
  const CardDeck({
    required this.id,
    required this.code,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.ambientTrackId,
    required this.cardCount,
    required this.cards,
  });

  final String id;
  final String code;
  final String title;
  final String subtitle;
  final String description;
  final String ambientTrackId;
  final int cardCount;
  final List<SoulCardItem> cards;
}

class CardCatalog {
  const CardCatalog({required this.decks});

  final List<CardDeck> decks;

  CardDeck? deck(String id) {
    for (final d in decks) {
      if (d.id == id || d.code == id) return d;
    }
    return null;
  }

  factory CardCatalog.fromJson(Map<String, dynamic> json, SoulLocale locale) {
    final lang = locale.name;
    final decksJson = (json['decks'] as List).cast<Map<String, dynamic>>();

    final decks = <CardDeck>[];
    for (final dj in decksJson) {
      final titleMap = dj['title'] as Map<String, dynamic>;
      final subtitleMap = dj['subtitle'] as Map<String, dynamic>;
      final descMap = dj['description'] as Map<String, dynamic>;

      final cardsJson = (dj['cards'] as List).cast<Map<String, dynamic>>();
      final cards = <SoulCardItem>[];
      for (final cj in cardsJson) {
        final textMap = cj['text'] as Map<String, dynamic>;
        cards.add(
          SoulCardItem(
            id: cj['id'] as String,
            number: cj['number'] as int,
            text: (textMap[lang] ?? textMap['vi'] ?? '') as String,
            imagePrompt: (cj['imagePrompt'] ?? '') as String,
            imagePath: cj['imagePath'] as String,
          ),
        );
      }

      decks.add(
        CardDeck(
          id: dj['id'] as String,
          code: dj['code'] as String,
          title: (titleMap[lang] ?? titleMap['vi'] ?? '') as String,
          subtitle: (subtitleMap[lang] ?? subtitleMap['vi'] ?? '') as String,
          description: (descMap[lang] ?? descMap['vi'] ?? '') as String,
          ambientTrackId: dj['ambientTrackId'] as String,
          cardCount: dj['cardCount'] as int,
          cards: List.unmodifiable(cards),
        ),
      );
    }

    return CardCatalog(decks: List.unmodifiable(decks));
  }
}

final cardCatalogProvider = FutureProvider<CardCatalog>((ref) {
  final locale = ref.watch(appStateProvider).locale ?? SoulLocale.vi;
  return ref.watch(contentRepositoryProvider).cardCatalog(locale);
});

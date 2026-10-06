import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/core/localization/soul_locale.dart';
import 'package:soul_app/data/content/card_catalog.dart';

void main() {
  group('CardCatalog', () {
    late Map<String, dynamic> rawJson;

    setUpAll(() async {
      final file = File('assets/content/card_decks.json');
      rawJson = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    });

    test('loads 3 decks with 50 cards each in Vietnamese', () {
      final catalog = CardCatalog.fromJson(rawJson, SoulLocale.vi);
      expect(catalog.decks.length, equals(3));

      final healing = catalog.deck('healing')!;
      expect(healing.title, equals('Đại dương xanh'));
      expect(healing.subtitle, equals('Chữa lành tâm hồn'));
      expect(healing.cards.length, equals(50));
      expect(healing.cards.first.text, contains('Bạn không cần vội'));
      expect(healing.ambientTrackId, equals('SO-05'));

      final career = catalog.deck('career')!;
      expect(career.title, equals('Đồng cỏ xanh'));
      expect(career.cards.length, equals(50));
      expect(career.ambientTrackId, equals('SO-11'));

      final relationship = catalog.deck('relationship')!;
      expect(relationship.title, equals('Hoa cỏ tình cảm'));
      expect(relationship.cards.length, equals(50));
      expect(relationship.ambientTrackId, equals('SO-18'));
    });

    test('loads 3 decks with 50 cards each in English', () {
      final catalog = CardCatalog.fromJson(rawJson, SoulLocale.en);
      expect(catalog.decks.length, equals(3));

      final healing = catalog.deck('healing')!;
      expect(healing.title, equals('Blue Ocean'));
      expect(healing.subtitle, equals('Soul Healing'));
      expect(healing.cards.length, equals(50));
      expect(healing.cards.first.text, contains("You don't have to rush"));

      final career = catalog.deck('career')!;
      expect(career.title, equals('Green Meadow'));
      expect(career.cards.length, equals(50));

      final relationship = catalog.deck('relationship')!;
      expect(relationship.title, equals('Floral Relationship'));
      expect(relationship.cards.length, equals(50));
    });
  });
}

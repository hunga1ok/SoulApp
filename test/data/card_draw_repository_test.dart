import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soul_app/data/repositories/card_draw_repository.dart';

void main() {
  group('CardDrawNotifier', () {
    test('enforces max 2 draws per day limit', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final notifier = CardDrawNotifier(prefs);

      // Initially 2 draws remaining
      expect(notifier.state.remainingDraws, equals(2));
      expect(notifier.state.canDraw, isTrue);
      expect(notifier.state.todayEntries.length, equals(0));

      // Draw 1
      final draw1 = await notifier.recordDraw(
        deckId: 'healing',
        cardId: 'healing_01',
      );
      expect(draw1, isNotNull);
      expect(notifier.state.remainingDraws, equals(1));
      expect(notifier.state.canDraw, isTrue);
      expect(notifier.state.todayEntries.length, equals(1));

      // Draw 2
      final draw2 = await notifier.recordDraw(
        deckId: 'career',
        cardId: 'career_05',
      );
      expect(draw2, isNotNull);
      expect(notifier.state.remainingDraws, equals(0));
      expect(notifier.state.canDraw, isFalse);
      expect(notifier.state.todayEntries.length, equals(2));

      // Attempt draw 3 -> rejected
      final draw3 = await notifier.recordDraw(
        deckId: 'relationship',
        cardId: 'relationship_10',
      );
      expect(draw3, isNull);
      expect(notifier.state.remainingDraws, equals(0));
      expect(notifier.state.canDraw, isFalse);
      expect(notifier.state.todayEntries.length, equals(2));
    });

    test('reloads existing draws from SharedPreferences', () async {
      final now = DateTime.now().toIso8601String();
      SharedPreferences.setMockInitialValues({
        'soul_card_draw_history': [
          '{"id":"d1","deckId":"healing","cardId":"healing_01","drawnAt":"$now","isFavorite":false}',
        ],
      });
      final prefs = await SharedPreferences.getInstance();
      final notifier = CardDrawNotifier(prefs);

      expect(notifier.state.entries.length, equals(1));
      expect(notifier.state.todayEntries.length, equals(1));
      expect(notifier.state.remainingDraws, equals(1));
      expect(notifier.state.canDraw, isTrue);
    });
  });
}

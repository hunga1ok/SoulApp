import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/features/cards/card_decks_hub_screen.dart';
import 'package:soul_app/features/cards/card_flip_widget.dart';
import 'package:soul_app/features/cards/cards_draw_screen.dart';

import '../../helpers/soul_test_harness.dart';

void main() {
  group('CardsScreen', () {
    testWidgets(
      'vi: selects deck, draws card, and shows popup on 3rd draw attempt',
      (tester) async {
        final db = testDatabase();
        await pumpSoulApp(
          tester,
          database: db,
          preferences: onboardedPreferences(SoulLocale.vi),
        );

        // Scroll to and verify Today screen has Soul Cards tile and tap it
        await tester.scrollUntilVisible(
          find.text('Thông điệp tâm hồn'),
          100,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text('Thông điệp tâm hồn'), findsOneWidget);
        await tester.tap(find.text('Thông điệp tâm hồn'));
        await tester.pumpAndSettle();

        // We are on CardDecksHubScreen showing 3 decks
        expect(find.byType(CardDecksHubScreen), findsOneWidget);
        expect(find.text('Rút thẻ thông điệp'), findsOneWidget);
        expect(find.text('Đại dương xanh'), findsOneWidget);
        expect(find.text('Đồng cỏ xanh'), findsOneWidget);
        await tester.scrollUntilVisible(
          find.text('Hoa cỏ tình cảm'),
          100,
          scrollable: find.byType(Scrollable).first,
        );
        expect(find.text('Hoa cỏ tình cảm'), findsOneWidget);

        // Scroll back up and tap on first deck "Đại dương xanh"
        await tester.scrollUntilVisible(
          find.text('Đại dương xanh'),
          -100,
          scrollable: find.byType(Scrollable).first,
        );
        await tester.tap(find.text('Đại dương xanh'));
        await tester.pumpAndSettle();

        // Now on CardsDrawScreen
        expect(find.byType(CardsDrawScreen), findsOneWidget);
        expect(find.byType(SoulCardBack), findsOneWidget);

        // Draw first card
        await tester.tap(find.byType(SoulCardBack));
        await tester.pumpAndSettle();

        // First card revealed
        expect(find.text('Lưu vào nhật ký'), findsOneWidget);
        expect(find.text('Rút thêm thông điệp'), findsOneWidget);

        // Save to journal
        await tester.tap(find.text('Lưu vào nhật ký'));
        await tester.pumpAndSettle();
        expect(find.text('Đã lưu thông điệp vào nhật ký'), findsWidgets);

        // Draw second card
        await tester.tap(find.text('Rút thêm thông điệp'));
        await tester.pumpAndSettle();
        expect(find.byType(SoulCardBack), findsOneWidget);

        await tester.tap(find.byType(SoulCardBack));
        await tester.pumpAndSettle();
        expect(find.text('Rút thêm thông điệp'), findsOneWidget);

        // Attempt 3rd draw -> should show popup dialog!
        await tester.tap(find.text('Rút thêm thông điệp'));
        await tester.pumpAndSettle();

        expect(find.text('Đã đủ 2 thông điệp hôm nay'), findsOneWidget);
        expect(find.text('Đã hiểu'), findsOneWidget);

        // Dismiss popup
        await tester.tap(find.text('Đã hiểu'));
        await tester.pumpAndSettle();
        expect(find.text('Đã đủ 2 thông điệp hôm nay'), findsNothing);
      },
    );

    testWidgets('en: displays in English without mixed language', (
      tester,
    ) async {
      final db = testDatabase();
      await pumpSoulApp(
        tester,
        database: db,
        preferences: onboardedPreferences(SoulLocale.en),
      );

      // Scroll to and tap Soul Message tile on Today screen
      await tester.scrollUntilVisible(
        find.text('Soul Message'),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Soul Message'), findsOneWidget);
      await tester.tap(find.text('Soul Message'));
      await tester.pumpAndSettle();

      // Verify English copy on Hub
      expect(find.byType(CardDecksHubScreen), findsOneWidget);
      expect(find.text('Soul Cards'), findsWidgets);
      expect(find.text('Blue Ocean'), findsOneWidget);
      expect(find.text('Green Meadow'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Floral Relationship'),
        100,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('Floral Relationship'), findsOneWidget);

      // Scroll back up and tap on Blue Ocean deck
      await tester.scrollUntilVisible(
        find.text('Blue Ocean'),
        -100,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Blue Ocean'));
      await tester.pumpAndSettle();

      expect(find.byType(CardsDrawScreen), findsOneWidget);
      expect(find.text('Draw a Card'), findsOneWidget);
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/core/design_system/design_system.dart';
import 'package:soul_app/data/repositories/gratitude_repository.dart';
import 'package:soul_app/features/journal/journal_note_detail_screen.dart';
import 'package:soul_app/features/today/gratitude_practice_screen.dart';

import '../../helpers/soul_test_harness.dart';

void main() {
  group('GratitudePracticeScreen', () {
    testWidgets('allows 1-click level selection to enable Next', (
      tester,
    ) async {
      final db = testDatabase();
      await pumpSoulApp(
        tester,
        database: db,
        preferences: onboardedPreferences(SoulLocale.vi),
      );

      // Open Morning Gratitude practice card from Today
      final startCard = find.text('Bắt đầu thực hành');
      expect(startCard, findsOneWidget);
      await tester.tap(startCard);
      await tester.pumpAndSettle();

      expect(find.byType(GratitudePracticeScreen), findsOneWidget);
      expect(find.text('Bắt đầu bài tập'), findsOneWidget);

      // Tap Begin Practice
      await tester.tap(find.text('Bắt đầu bài tập'));
      await tester.pumpAndSettle();

      // Item 1 of 10
      expect(find.text('Điều 1 trên 10'), findsOneWidget);
      expect(find.text('Tôi biết ơn...'), findsWidgets);
      expect(find.text('Vì sao...'), findsWidgets);

      // Initially next button should be disabled
      final nextButtonFinder = find.widgetWithText(
        SoulButton,
        'Thêm & Tiếp tục',
      );
      var nextButton = tester.widget<SoulButton>(nextButtonFinder);
      expect(nextButton.onPressed, isNull);

      // Fill gratitude text only
      await tester.enterText(
        find.widgetWithText(SoulTextField, 'Tôi biết ơn...'),
        'Một buổi sáng trong lành',
      );
      await tester.pump();
      nextButton = tester.widget<SoulButton>(nextButtonFinder);
      expect(nextButton.onPressed, isNull);

      // 1-click level selection: Tap 'Biết ơn sâu sắc'
      await tester.tap(find.text('Biết ơn sâu sắc'));
      await tester.pumpAndSettle();

      // Now Next button should be enabled!
      nextButton = tester.widget<SoulButton>(nextButtonFinder);
      expect(nextButton.onPressed, isNotNull);

      // Tap next
      await tester.tap(nextButtonFinder);
      await tester.pumpAndSettle();

      // Moved to Item 2 of 10
      expect(find.text('Điều 2 trên 10'), findsOneWidget);
    });

    testWidgets('allows finish early without completing all 10 items', (
      tester,
    ) async {
      final db = testDatabase();
      await pumpSoulApp(
        tester,
        database: db,
        preferences: onboardedPreferences(SoulLocale.en),
      );

      // Open Gratitude practice
      await tester.tap(find.text('Start Practice'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Begin Practice'));
      await tester.pumpAndSettle();

      // Fill Item 1
      await tester.enterText(
        find.widgetWithText(SoulTextField, 'I am grateful for...'),
        'Fresh Morning Air',
      );
      await tester.enterText(
        find.widgetWithText(SoulTextField, 'Because...'),
        'It energizes my day',
      );
      await tester.ensureVisible(find.text('Profound gratitude'));
      await tester.tap(find.text('Profound gratitude'));
      await tester.pumpAndSettle();

      // Tap Add & Next to go to item 2
      final addNext = find.widgetWithText(SoulButton, 'Add & Next');
      await tester.ensureVisible(addNext);
      await tester.tap(addNext);
      await tester.pumpAndSettle();

      // Item 2
      expect(find.text('Item 2 of 10'), findsOneWidget);
      await tester.enterText(
        find.widgetWithText(SoulTextField, 'I am grateful for...'),
        'Warm Coffee',
      );
      await tester.ensureVisible(find.text('Thank you'));
      await tester.tap(find.text('Thank you'));
      await tester.pumpAndSettle();

      // Now tap Skip progress in AppBar!
      final skipInAppBar = find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Skip progress'),
      );
      await tester.tap(skipInAppBar);
      await tester.pumpAndSettle();

      // Review screen shows only the 2 filled items!
      expect(find.text('Your 2 Gratitudes Today'), findsOneWidget);
      expect(find.text('Fresh Morning Air'), findsOneWidget);
      expect(find.text('Warm Coffee'), findsOneWidget);

      // Complete Practice
      await tester.tap(find.widgetWithText(SoulButton, 'Complete Practice'));
      await tester.pumpAndSettle();

      // Celebration screen
      expect(find.text('Practice Completed ✨'), findsOneWidget);

      // Verify entries in database: exactly 2 entries saved!
      final entries = await db.select(db.gratitudeEntries).get();
      expect(entries.length, 2);
      expect(entries[0].gratitudeText, 'Fresh Morning Air');
      expect(entries[1].gratitudeText, 'Warm Coffee');

      // Go back to Today
      await tester.tap(find.text('Back to Today'));
      await tester.pumpAndSettle();

      // Today card shows continue practice button
      expect(find.text('Continue Practice'), findsOneWidget);
    });

    testWidgets('allows skipping progress immediately without entering items', (
      tester,
    ) async {
      final db = testDatabase();
      await pumpSoulApp(
        tester,
        database: db,
        preferences: onboardedPreferences(SoulLocale.en),
      );

      // Open Gratitude practice
      await tester.tap(find.text('Start Practice'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Begin Practice'));
      await tester.pumpAndSettle();

      // Tap Skip progress right on item 1 with no inputs
      final skipInAppBar = find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Skip progress'),
      );
      await tester.tap(skipInAppBar);
      await tester.pumpAndSettle();

      // Shows practice skipped screen
      expect(find.text('Practice Skipped'), findsOneWidget);

      // Go back to Today
      await tester.tap(find.text('Back to Today'));
      await tester.pumpAndSettle();

      // No entries in database
      final entries = await db.select(db.gratitudeEntries).get();
      expect(entries, isEmpty);
    });

    testWidgets('allows adding a custom note from Journal tab', (tester) async {
      final db = testDatabase();
      await pumpSoulApp(
        tester,
        database: db,
        preferences: onboardedPreferences(SoulLocale.vi),
      );

      // Navigate to Journal tab
      await tester.tap(find.byIcon(Icons.menu_book_outlined));
      await tester.pumpAndSettle();

      // Tap add note button
      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();

      // Sheet opens
      expect(find.text('Ghi chú biết ơn mới'), findsOneWidget);

      await tester.enterText(
        find.widgetWithText(SoulTextField, 'Tôi biết ơn...'),
        'Một người bạn luôn lắng nghe',
      );
      await tester.enterText(
        find.widgetWithText(SoulTextField, 'Vì sao...'),
        'Giúp tôi cảm thấy được thấu hiểu',
      );
      await tester.pump();

      // Scroll & tap 'Lưu ghi chú'
      await tester.ensureVisible(find.text('Lưu ghi chú'));
      await tester.tap(find.text('Lưu ghi chú'));
      await tester.pumpAndSettle();

      // Note is visible in Journal with complete sentence!
      expect(
        find.textContaining('Một người bạn luôn lắng nghe'),
        findsOneWidget,
      );

      // Tap on note card to open full-screen view
      await tester.tap(find.textContaining('Một người bạn luôn lắng nghe'));
      await tester.pumpAndSettle();

      // Full screen detail view is shown with close button
      expect(find.byType(JournalNoteDetailScreen), findsOneWidget);
      expect(find.text('Đóng'), findsOneWidget);
      expect(
        find.textContaining('Tôi biết ơn Một người bạn luôn lắng nghe'),
        findsOneWidget,
      );

      // Tap close button to exit
      await tester.tap(find.text('Đóng'));
      await tester.pumpAndSettle();

      // Back on Journal tab
      expect(find.byIcon(Icons.add_rounded), findsOneWidget);

      // Check database
      final repo = GratitudeRepository(db);
      final recent = await repo.getRecentEntries();
      expect(recent.length, 1);
      expect(recent.first.gratitudeText, 'Một người bạn luôn lắng nghe');
    });
  });
}

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
    testWidgets('allows freeform journal writing and saving to journal', (
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
      // Daily guidance card is dropdown/collapsible; tap the guidance header to expand and view
      await tester.tap(find.byIcon(Icons.keyboard_arrow_down_rounded));
      await tester.pumpAndSettle();

      // Daily guidance text should be visible
      expect(
        find.textContaining(
          'Ngày hôm nay, bạn bắt đầu trên hành trình biết ơn',
        ),
        findsOneWidget,
      );

      // Tap Insert Template
      await tester.tap(find.text('Chèn mẫu câu'));
      await tester.pumpAndSettle();

      // Enter journal text
      final editorFinder = find.byType(TextField).last;
      await tester.enterText(
        editorFinder,
        'Tôi biết ơn một ngày bình yên vì tâm hồn được thư thái.',
      );
      await tester.pumpAndSettle();

      // Tap Save & Complete
      final saveButtonFinder = find.widgetWithText(
        SoulButton,
        'Hoàn thành & Lưu nhật ký',
      );
      await tester.ensureVisible(saveButtonFinder);
      await tester.tap(saveButtonFinder);
      await tester.pumpAndSettle();

      // Completion dialog appears
      expect(find.text('Hoàn thành bài tập ✨'), findsOneWidget);
      await tester.tap(find.text('Về trang Hôm nay'));
      await tester.pumpAndSettle();

      // Returned to Today screen
      expect(find.byType(GratitudePracticeScreen), findsNothing);

      // Verify database
      final entries = await db.select(db.gratitudeEntries).get();
      expect(entries.length, 1);
      expect(
        entries[0].gratitudeText,
        'Tôi biết ơn một ngày bình yên vì tâm hồn được thư thái.',
      );
    });

    testWidgets('allows adding a custom freeform note from Journal tab', (
      tester,
    ) async {
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

      // Editor screen opens
      expect(find.text('Ghi chú biết ơn mới'), findsOneWidget);

      // Type freeform note in the main text field
      final textField = find.byType(TextField).last;
      await tester.enterText(
        textField,
        'Tôi biết ơn một người bạn luôn lắng nghe vì giúp tôi cảm thấy được thấu hiểu.',
      );
      await tester.pumpAndSettle();

      // Tap 'Hoàn thành & Lưu nhật ký'
      final saveButton = find.text('Hoàn thành & Lưu nhật ký');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Note is visible in Journal
      expect(
        find.textContaining('Tôi biết ơn một người bạn luôn lắng nghe'),
        findsOneWidget,
      );

      // Tap on note card to open full-screen view
      await tester.tap(
        find.textContaining('Tôi biết ơn một người bạn luôn lắng nghe'),
      );
      await tester.pumpAndSettle();

      // Full screen detail view is shown with edit button
      expect(find.byType(JournalNoteDetailScreen), findsOneWidget);
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);

      // Tap Edit button to edit this note
      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      // Edit screen is open
      expect(find.text('Chỉnh sửa ghi chú'), findsOneWidget);
      expect(
        find.textContaining('Tôi biết ơn một người bạn luôn lắng nghe'),
        findsOneWidget,
      );

      // Update text in editor
      await tester.enterText(
        find.byType(TextField).last,
        'Tôi biết ơn một người bạn luôn lắng nghe và động viên tôi.',
      );
      // Wait for any previous SnackBar to dismiss
      await tester.pump(const Duration(seconds: 4));
      await tester.pumpAndSettle();

      // Tap Save
      final editSaveButton = find.text('Hoàn thành & Lưu nhật ký');
      await tester.ensureVisible(editSaveButton);
      await tester.tap(editSaveButton);
      await tester.pumpAndSettle();

      // Back on Journal tab with updated content
      expect(
        find.textContaining(
          'Tôi biết ơn một người bạn luôn lắng nghe và động viên tôi.',
        ),
        findsOneWidget,
      );

      // Check database
      final repo = GratitudeRepository(db);
      final recent = await repo.getRecentEntries();
      expect(recent.length, 1);
      expect(
        recent.first.gratitudeText,
        contains('Tôi biết ơn một người bạn luôn lắng nghe và động viên tôi.'),
      );
    });
  });
}

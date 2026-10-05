import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/core/design_system/design_system.dart';
import 'package:soul_app/features/vision/vision_builder_screen.dart';
import 'package:soul_app/features/vision/vision_detail_screen.dart';
import 'package:soul_app/features/vision/vision_screen.dart';

import '../../helpers/soul_test_harness.dart';

Future<void> _openVisionTab(WidgetTester tester) async {
  await tester.tap(
    find.descendant(
      of: find.byType(NavigationBar),
      matching: find.byIcon(Icons.auto_awesome_outlined),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _tapButton(WidgetTester tester, String label) async {
  final button = find.widgetWithText(SoulButton, label);
  // Lazy lists build the footer button only once it scrolls into view.
  await tester.scrollUntilVisible(
    button,
    200,
    scrollable: find.byType(Scrollable).last,
  );
  await tester.pumpAndSettle();
  await tester.tap(button);
  await tester.pumpAndSettle();
}

Future<void> _tapText(WidgetTester tester, String text) async {
  final target = find.text(text);
  if (find.byType(Scrollable).evaluate().isNotEmpty) {
    try {
      await tester.scrollUntilVisible(
        target,
        200,
        scrollable: find.byType(Scrollable).last,
      );
    } catch (_) {}
  }
  await tester.ensureVisible(target);
  await tester.pumpAndSettle();
  await tester.tap(target);
  await tester.pumpAndSettle();
}

/// Answers every guided question with its first suggestion.
Future<void> _answerQuestions(
  WidgetTester tester,
  String next,
  String feelingsTitle,
) async {
  for (var step = 0; step < 20; step++) {
    if (find.text(feelingsTitle).evaluate().isNotEmpty) return;
    final continueButton = find.widgetWithText(SoulButton, next);
    if (continueButton.evaluate().isEmpty) return;
    final button = tester.widget<SoulButton>(continueButton);
    if (button.onPressed == null) {
      await tester.tap(find.byType(SoulChip).first);
      await tester.pump();
    }
    await _tapButton(tester, next);
  }
}

void main() {
  const cases = [
    (
      locale: SoulLocale.vi,
      create: 'Tạo một tầm nhìn',
      category: 'Bình an nội tâm',
      feelingsTitle: 'Bạn muốn cảm thấy thế nào khi điều đó đang diễn ra?',
      next: 'Tiếp tục',
      save: 'Lưu vào vision board',
      archive: 'Lưu trữ tầm nhìn',
      confirm: 'Lưu trữ',
    ),
    (
      locale: SoulLocale.en,
      create: 'Create a vision',
      category: 'Inner Peace',
      feelingsTitle: 'How do you want to feel when this vision comes true?',
      next: 'Continue',
      save: 'Save to vision board',
      archive: 'Archive vision',
      confirm: 'Archive',
    ),
  ];

  for (final c in cases) {
    testWidgets('${c.locale.name}: create a Vision through every step, open '
        'it and archive it', (tester) async {
      final database = testDatabase();
      await pumpSoulApp(
        tester,
        preferences: onboardedPreferences(c.locale),
        database: database,
      );
      await _openVisionTab(tester);
      expect(find.byType(VisionScreen), findsOneWidget);

      await _tapButton(tester, c.create);
      expect(find.byType(VisionBuilderScreen), findsOneWidget);

      await _tapText(tester, c.category);
      await _answerQuestions(tester, c.next, c.feelingsTitle);

      // Feelings: at least one, at most three.
      expect(find.text(c.feelingsTitle), findsOneWidget);
      for (var index = 0; index < 4; index++) {
        await tester.tap(find.byType(SoulChip).at(index));
        await tester.pump();
      }
      final selected = tester
          .widgetList<SoulChip>(find.byType(SoulChip))
          .where((chip) => chip.selected);
      expect(selected, hasLength(3));
      await _tapButton(tester, c.next);

      // Statement: drafted from the answers, editable.
      final statement = tester.widget<TextField>(find.byType(TextField));
      expect(statement.controller!.text, isNotEmpty);
      await _tapButton(tester, c.next);

      // Photo is optional.
      await _tapButton(tester, c.next);
      await _tapButton(tester, c.save);

      expect(find.byType(VisionScreen), findsOneWidget);
      final visions = await database.select(database.visions).get();
      expect(visions, hasLength(1));
      expect(visions.single.categoryCode, 'PEACE');
      expect(visions.single.locale, c.locale.name);
      expect(
        await database.select(database.visionFeelings).get(),
        hasLength(3),
      );
      expect(
        (await database.select(database.visionAnswers).get()).length,
        greaterThan(0),
      );

      await tester.tap(find.text(visions.single.statement));
      await tester.pumpAndSettle();
      expect(find.byType(VisionDetailScreen), findsOneWidget);

      await _tapButton(tester, c.archive);
      await tester.tap(find.text(c.confirm).last);
      await tester.pumpAndSettle();

      expect(find.byType(VisionScreen), findsOneWidget);
      expect(find.text(c.create), findsOneWidget);
      expect(
        (await database.select(database.visions).get()).single.status,
        'archived',
      );
    });
  }

  testWidgets('back returns to the previous step with answers kept, and '
      'from the first step to the board', (tester) async {
    await pumpSoulApp(tester, preferences: onboardedPreferences(SoulLocale.en));
    await _openVisionTab(tester);
    await _tapButton(tester, 'Create a vision');
    await _tapText(tester, 'Inner Peace');

    await tester.tap(find.byType(SoulChip).first);
    await tester.pump();
    await _tapButton(tester, 'Continue');
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    final chip = tester.widget<SoulChip>(find.byType(SoulChip).first);
    expect(chip.selected, isTrue);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Choose an area'), findsOneWidget);
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(VisionBuilderScreen), findsNothing);
    expect(find.byType(VisionScreen), findsOneWidget);
  });

  testWidgets('a picked photo can be previewed and removed before saving', (
    tester,
  ) async {
    final picking = FakeImagePicking('/tmp/picked.jpg');
    await pumpSoulApp(
      tester,
      preferences: onboardedPreferences(SoulLocale.en),
      imagePicking: picking,
    );
    await _openVisionTab(tester);
    await _tapButton(tester, 'Create a vision');
    await _tapText(tester, 'Inner Peace');
    await _answerQuestions(
      tester,
      'Continue',
      'How do you want to feel when this vision comes true?',
    );
    await tester.tap(find.byType(SoulChip).first);
    await tester.pump();
    await _tapButton(tester, 'Continue');
    await _tapButton(tester, 'Continue');

    await _tapButton(tester, 'Choose from library');
    expect(picking.picks, [false]);
    expect(find.text('Remove photo'), findsOneWidget);

    await tester.ensureVisible(find.text('Remove photo'));
    await tester.tap(find.text('Remove photo'));
    await tester.pumpAndSettle();
    expect(find.text('Remove photo'), findsNothing);
  });

  testWidgets('builder steps do not overflow at 200% text on a small phone', (
    tester,
  ) async {
    await pumpSoulApp(
      tester,
      preferences: onboardedPreferences(SoulLocale.vi),
      size: smallPhone,
      textScale: 2,
    );
    await _openVisionTab(tester);
    expect(tester.takeException(), isNull);
    await _tapButton(tester, 'Tạo một tầm nhìn');
    expect(tester.takeException(), isNull);
    await _tapText(tester, 'Bình an nội tâm');
    expect(tester.takeException(), isNull);
  });
}

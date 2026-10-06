import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/core/design_system/design_system.dart';

import '../../helpers/soul_test_harness.dart';

void main() {
  group('SoulButton', () {
    testWidgets('invokes onPressed and has a 48px+ target', (tester) async {
      var taps = 0;
      await pumpSoulWidget(
        tester,
        SoulButton(label: 'Continue', onPressed: () => taps++),
      );

      await tester.tap(find.text('Continue'));
      expect(taps, 1);
      expect(
        tester.getSize(find.byType(SoulButton)).height,
        greaterThanOrEqualTo(SoulSizes.minTouchTarget),
      );
    });

    testWidgets('is disabled without onPressed', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpSoulWidget(
        tester,
        const SoulButton(
          label: 'Save',
          onPressed: null,
          variant: SoulButtonVariant.secondary,
        ),
      );

      expect(
        tester.getSemantics(find.byType(SoulButton)),
        isSemantics(
          label: 'Save',
          isButton: true,
          isEnabled: false,
          hasTapAction: false,
        ),
      );
      handle.dispose();
    });
  });

  group('SoulChip', () {
    testWidgets('toggles and exposes selected state', (tester) async {
      final handle = tester.ensureSemantics();
      bool? toggled;
      await pumpSoulWidget(
        tester,
        SoulChip(
          label: 'Calm',
          selected: true,
          onSelected: (value) => toggled = value,
        ),
      );

      expect(
        tester.getSemantics(find.byType(FilterChip)),
        isSemantics(label: 'Calm', isSelected: true),
      );
      expect(find.byIcon(Icons.check), findsNothing);
      await tester.tap(find.text('Calm'));
      expect(toggled, isFalse);
      expect(
        tester.getSize(find.byType(SoulChip)).height,
        greaterThanOrEqualTo(SoulSizes.minTouchTarget),
      );
      handle.dispose();
    });
  });

  testWidgets('SoulCard makes the whole card tappable', (tester) async {
    var taps = 0;
    await pumpSoulWidget(
      tester,
      SoulCard(
        onTap: () => taps++,
        child: const SizedBox(height: 80, child: Text('Card')),
      ),
    );
    await tester.tapAt(
      tester.getBottomRight(find.byType(SoulCard)) - const Offset(24, 24),
    );
    expect(taps, 1);
  });

  testWidgets('showSoulBottomSheet shows content and dismisses', (
    tester,
  ) async {
    await pumpSoulWidget(
      tester,
      Builder(
        builder:
            (context) => TextButton(
              onPressed:
                  () => showSoulBottomSheet<void>(
                    context: context,
                    builder: (_) => const Text('Sheet body'),
                  ),
              child: const Text('Open'),
            ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Sheet body'), findsOneWidget);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.text('Sheet body'), findsNothing);
  });

  for (final (locale, cancel) in [
    (SoulLocale.vi, 'Hủy'),
    (SoulLocale.en, 'Cancel'),
  ]) {
    testWidgets('${locale.name}: showSoulConfirmDialog resolves the choice', (
      tester,
    ) async {
      final results = <bool>[];
      await pumpSoulWidget(
        tester,
        locale: locale,
        Builder(
          builder:
              (context) => TextButton(
                onPressed:
                    () async => results.add(
                      await showSoulConfirmDialog(
                        context: context,
                        title: 'Title',
                        message: 'Message',
                        confirmLabel: 'OK',
                      ),
                    ),
                child: const Text('Open'),
              ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text(cancel));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(results, [false, true]);
    });
  }

  testWidgets('SoulTextField reports changes and exposes its label', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    String? changed;
    await pumpSoulWidget(
      tester,
      SoulTextField(
        controller: controller,
        label: 'Your name',
        onChanged: (value) => changed = value,
      ),
    );

    await tester.enterText(find.byType(TextField), 'An');
    expect(changed, 'An');
    expect(find.bySemanticsLabel(RegExp('Your name')), findsOneWidget);
    handle.dispose();
  });

  testWidgets('SoulEmptyState renders title, message and action', (
    tester,
  ) async {
    var taps = 0;
    await pumpSoulWidget(
      tester,
      SoulEmptyState(
        icon: Icons.auto_awesome_outlined,
        title: 'Nothing yet',
        message: 'Start small.',
        action: SoulButton(label: 'Create', onPressed: () => taps++),
      ),
    );
    expect(find.text('Nothing yet'), findsOneWidget);
    expect(find.text('Start small.'), findsOneWidget);
    await tester.tap(find.text('Create'));
    expect(taps, 1);
  });

  for (final (locale, retry, message, loading) in [
    (
      SoulLocale.vi,
      'Thử lại',
      'Đã có lỗi xảy ra. Bạn thử lại nhé.',
      'Đang tải',
    ),
    (
      SoulLocale.en,
      'Try again',
      'Something went wrong. Please try again.',
      'Loading',
    ),
  ]) {
    testWidgets('${locale.name}: SoulErrorState retries', (tester) async {
      var retries = 0;
      await pumpSoulWidget(
        tester,
        locale: locale,
        SoulErrorState(onRetry: () => retries++),
      );
      expect(find.text(message), findsOneWidget);
      await tester.tap(find.text(retry));
      expect(retries, 1);
    });

    testWidgets('${locale.name}: SoulLoadingState has a localized label', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await pumpSoulWidget(
        tester,
        locale: locale,
        settle: false,
        const SoulLoadingState(),
      );
      expect(find.bySemanticsLabel(RegExp(loading)), findsOneWidget);
      handle.dispose();
    });
  }

  testWidgets('SoulProgressBar exposes label and percentage', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpSoulWidget(
      tester,
      const SoulProgressBar(value: 0.25, semanticsLabel: 'Day 7 of 28'),
    );
    expect(
      tester.getSemantics(find.byType(SoulProgressBar)),
      isSemantics(label: 'Day 7 of 28', value: '25%'),
    );
    handle.dispose();
  });

  group('SoulStickyNote', () {
    testWidgets('is tappable as a whole card', (tester) async {
      var taps = 0;
      await pumpSoulWidget(
        tester,
        SoulStickyNote(
          eyebrow: 'GRATITUDE',
          body: 'I am grateful.',
          onTap: () => taps++,
        ),
      );
      await tester.tapAt(
        tester.getBottomLeft(find.byType(SoulStickyNote)) + const Offset(8, -8),
      );
      expect(taps, 1);
    });

    testWidgets('uses warm-white paper with horizontal rules only', (
      tester,
    ) async {
      await pumpSoulWidget(
        tester,
        const SoulStickyNote(eyebrow: 'GRATITUDE', body: 'I am grateful.'),
      );
      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(SoulStickyNote),
          matching: find.byType(Material),
        ),
      );
      expect(material.color, SoulColors.notePaper);

      final paint = find.descendant(
        of: find.byType(SoulStickyNote),
        matching: find.byWidgetPredicate(
          (widget) => widget is CustomPaint && widget.painter != null,
        ),
      );
      final box = tester.getSize(paint);
      // Every ruled line spans the full width at a constant y: horizontal.
      expect(
        tester.renderObject<RenderCustomPaint>(paint),
        paints..line(p1: const Offset(0, 28), p2: Offset(box.width, 28)),
      );
    });
  });

  for (final (locale, play, pause) in [
    (SoulLocale.vi, 'Phát', 'Tạm dừng'),
    (SoulLocale.en, 'Play', 'Pause'),
  ]) {
    testWidgets('${locale.name}: SoulAudioRow play/pause is labelled', (
      tester,
    ) async {
      var taps = 0;
      await pumpSoulWidget(
        tester,
        locale: locale,
        Column(
          children: [
            SoulAudioRow(
              title: 'Morning',
              subtitle: '5 min',
              onPlayPause: () => taps++,
            ),
            SoulAudioRow(
              title: 'Evening',
              subtitle: '5 min',
              isPlaying: true,
              onPlayPause: () {},
            ),
          ],
        ),
      );
      expect(find.byTooltip(play), findsOneWidget);
      expect(find.byTooltip(pause), findsOneWidget);
      await tester.tap(find.byTooltip(play));
      expect(taps, 1);
    });

    testWidgets('${locale.name}: SoulAppBar shows logo or titled back', (
      tester,
    ) async {
      var backs = 0;
      await pumpSoulWidget(
        tester,
        locale: locale,
        Column(
          children: [
            const SoulAppBar(),
            SoulAppBar(title: 'Profile', onBack: () => backs++),
          ],
        ),
      );
      expect(find.bySemanticsLabel('Soul'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      await tester.tap(
        find.byTooltip(locale == SoulLocale.vi ? 'Quay lại' : 'Back'),
      );
      expect(backs, 1);
    });
  }
}

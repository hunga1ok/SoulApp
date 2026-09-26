@Tags(['golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/core/design_system/design_system.dart';
import 'package:soul_app/l10n/app_localizations.dart';

import '../../helpers/soul_test_harness.dart';

typedef _Gallery = Widget Function(AppLocalizations l10n);

final _components = <String, (double, _Gallery)>{
  'buttons': (
    220,
    (l10n) => Column(
      children: [
        SoulButton(label: l10n.saveAndContinue, onPressed: () {}),
        const SizedBox(height: SoulSpace.sm),
        SoulButton(
          label: l10n.createVision,
          variant: SoulButtonVariant.secondary,
          onPressed: () {},
        ),
        const SizedBox(height: SoulSpace.sm),
        SoulButton(label: l10n.saveAndContinue, onPressed: null),
      ],
    ),
  ),
  'chips': (
    140,
    (l10n) => Wrap(
      spacing: SoulSpace.xs,
      children: [
        SoulChip(label: l10n.today, selected: true, onSelected: (_) {}),
        SoulChip(label: l10n.journal, selected: false, onSelected: (_) {}),
        SoulChip(label: l10n.explore, selected: false, onSelected: (_) {}),
      ],
    ),
  ),
  'card': (
    160,
    (l10n) => SoulCard(onTap: () {}, child: Text(l10n.smallActionText)),
  ),
  'text_field': (
    140,
    (l10n) => SoulTextField(
      controller: TextEditingController(),
      label: l10n.nameHint,
    ),
  ),
  'empty_state': (
    420,
    (l10n) => SoulEmptyState(
      icon: Icons.auto_awesome_outlined,
      title: l10n.visionEmptyTitle,
      message: l10n.visionEmptyBody,
      action: SoulButton(label: l10n.createVision, onPressed: () {}),
    ),
  ),
  'error_state': (320, (l10n) => SoulErrorState(onRetry: () {})),
  'progress_bar': (
    80,
    (l10n) => SoulProgressBar(
      value: 7 / 28,
      semanticsLabel: l10n.dayProgress(7),
      trackColor: SoulColors.rose,
    ),
  ),
  'sticky_note': (
    200,
    (l10n) => SoulStickyNote(
      eyebrow: l10n.gratitudeToday,
      body: l10n.gratitudeNote,
      onTap: () {},
    ),
  ),
  'audio_row': (
    160,
    (l10n) => SoulAudioRow(
      title: l10n.morningGratitude,
      subtitle: l10n.neutralInstrumentalFiveMinutes,
      onPlayPause: () {},
    ),
  ),
  'app_bar': (100, (l10n) => SoulAppBar(title: l10n.profile, onBack: () {})),
};

void main() {
  const galleryKey = ValueKey('gallery');

  for (final locale in SoulLocale.values) {
    for (final MapEntry(key: name, value: (height, gallery))
        in _components.entries) {
      testWidgets('${locale.name}: $name golden', (tester) async {
        await pumpSoulWidget(
          tester,
          locale: locale,
          size: Size(360, height),
          RepaintBoundary(
            key: galleryKey,
            child: ColoredBox(
              color: SoulColors.paper,
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.all(SoulSpace.md),
                  child: Builder(
                    builder:
                        (context) => gallery(AppLocalizations.of(context)!),
                  ),
                ),
              ),
            ),
          ),
        );
        await expectLater(
          find.byKey(galleryKey),
          matchesGoldenFile('goldens/${name}_${locale.name}.png'),
        );
      });
    }

    testWidgets('${locale.name}: loading_state golden', (tester) async {
      await pumpSoulWidget(
        tester,
        locale: locale,
        size: const Size(360, 120),
        settle: false,
        const RepaintBoundary(key: galleryKey, child: SoulLoadingState()),
      );
      // Advance the indeterminate spinner to a visible, deterministic frame.
      await tester.pump(const Duration(milliseconds: 400));
      await expectLater(
        find.byKey(galleryKey),
        matchesGoldenFile('goldens/loading_state_${locale.name}.png'),
      );
    });

    testWidgets('${locale.name}: bottom_sheet golden', (tester) async {
      await pumpSoulWidget(
        tester,
        locale: locale,
        size: const Size(360, 480),
        Builder(
          builder:
              (context) => TextButton(
                onPressed:
                    () => showSoulBottomSheet<void>(
                      context: context,
                      builder:
                          (context) => Text(
                            AppLocalizations.of(context)!.gratitudeNote,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                    ),
                child: const Text('open'),
              ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/bottom_sheet_${locale.name}.png'),
      );
    });

    testWidgets('${locale.name}: dialog golden', (tester) async {
      await pumpSoulWidget(
        tester,
        locale: locale,
        size: const Size(360, 560),
        Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            return TextButton(
              onPressed:
                  () => showSoulConfirmDialog(
                    context: context,
                    title: l10n.signOut,
                    message: l10n.authTagline,
                    confirmLabel: l10n.signOut,
                  ),
              child: const Text('open'),
            );
          },
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/dialog_${locale.name}.png'),
      );
    });
  }
}

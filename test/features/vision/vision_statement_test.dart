import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:soul_app/app/app_state.dart';
import 'package:soul_app/data/content/vision_catalog.dart';
import 'package:soul_app/features/vision/vision_statement.dart';

VisionCatalog _catalog(SoulLocale locale) => VisionCatalog.fromJson(
  jsonDecode(File('assets/content/vision.json').readAsStringSync())
      as Map<String, dynamic>,
  locale,
);

Map<String, VisionAnswer> _firstOptions(VisionCatalog catalog, String code) => {
  for (final question in catalog.questionsFor(code))
    question.code: VisionAnswer(valueCodes: [question.options.first.valueCode]),
};

void main() {
  test('the bundled catalog has every category, feeling and question in '
      'both locales', () {
    for (final locale in SoulLocale.values) {
      final catalog = _catalog(locale);
      expect(catalog.categories, hasLength(9));
      expect(catalog.feelings, hasLength(34));
      for (final category in catalog.categories) {
        expect(category.name, isNotEmpty);
        expect(catalog.questionsFor(category.code), isNotEmpty);
        expect(
          catalog.templates.where((t) => t.categoryCode == category.code),
          isNotEmpty,
          reason: '${category.code} needs a statement template',
        );
      }
    }
  });

  test('suggested feelings come first but every feeling stays available', () {
    final catalog = _catalog(SoulLocale.en);
    final feelings = catalog.feelingsFor('LOVE');

    expect(feelings, hasLength(catalog.feelings.length));
    expect(feelings.first.suggestedCategoryCodes, contains('LOVE'));
  });

  for (final locale in SoulLocale.values) {
    test('${locale.name}: every category drafts a statement without '
        'unfilled placeholders', () {
      final catalog = _catalog(locale);
      for (final category in catalog.categories) {
        final statement = draftVisionStatement(
          catalog: catalog,
          categoryCode: category.code,
          answers: _firstOptions(catalog, category.code),
          feelingCodes: [catalog.feelings.first.code],
          locale: locale,
        );
        expect(statement, isNotEmpty, reason: category.code);
        expect(statement, isNot(contains('{')), reason: category.code);
      }
    });
  }

  test(
    'the draft keeps every answer and joins lists in the active language',
    () {
      final catalog = _catalog(SoulLocale.vi);
      final questions = catalog.questionsFor('CAREER');
      final workType = questions.firstWhere((q) => q.fieldKey == 'work_type');
      final answers = _firstOptions(catalog, 'CAREER')
        ..[workType.code] = VisionAnswer(
          valueCodes: [workType.options[0].valueCode],
          customText: 'Viết sách',
        );

      final statement = draftVisionStatement(
        catalog: catalog,
        categoryCode: 'CAREER',
        answers: answers,
        feelingCodes: const [],
        locale: SoulLocale.vi,
      );

      expect(statement, startsWith('Tầm nhìn của tôi'));
      expect(statement, contains(' và Viết sách'));
      for (final question in questions) {
        expect(statement, contains(question.options.first.label.toLowerCase()));
      }
      expect(statement, contains('Bước đầu tiên tôi chọn là'));
    },
  );

  test('LOVE falls back to its short template while its primary one is a '
      'draft', () {
    final catalog = _catalog(SoulLocale.en);
    final statement = draftVisionStatement(
      catalog: catalog,
      categoryCode: 'LOVE',
      answers: const {},
      feelingCodes: const ['LOVED'],
      locale: SoulLocale.en,
    );

    final short = catalog.templates.singleWhere(
      (t) => t.categoryCode == 'LOVE' && !t.isPrimary,
    );
    expect(statement, short.body.replaceAll('{feeling_1}', 'loved'));
  });
}

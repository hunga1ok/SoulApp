import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/soul_locale.dart';
import 'content_repository.dart';

class VisionCategory {
  const VisionCategory({
    required this.code,
    required this.icon,
    required this.name,
  });

  final String code;
  final String? icon;
  final String name;
}

class VisionFeeling {
  const VisionFeeling({
    required this.code,
    required this.label,
    required this.suggestedCategoryCodes,
  });

  final String code;
  final String label;
  final List<String> suggestedCategoryCodes;
}

class VisionAnswerOption {
  const VisionAnswerOption({required this.valueCode, required this.label});

  final String valueCode;
  final String label;
}

class VisionQuestion {
  const VisionQuestion({
    required this.code,
    required this.categoryCode,
    required this.fieldKey,
    required this.maxSelect,
    required this.required,
    required this.prompt,
    required this.helper,
    required this.options,
  });

  final String code;
  final String categoryCode;
  final String fieldKey;
  final int maxSelect;
  final bool required;
  final String prompt;

  /// Hint for the user's own answer.
  final String helper;
  final List<VisionAnswerOption> options;
}

class StatementTemplate {
  const StatementTemplate({
    required this.categoryCode,
    required this.isPrimary,
    required this.body,
  });

  final String categoryCode;
  final bool isPrimary;
  final String body;
}

/// The published Vision catalog in one locale, from `assets/content/vision.json`.
class VisionCatalog {
  const VisionCatalog({
    required this.categories,
    required this.feelings,
    required this.questions,
    required this.templates,
  });

  factory VisionCatalog.fromJson(Map<String, dynamic> json, SoulLocale locale) {
    String text(Map<String, dynamic> item, String field) =>
        ((item['text'] as Map<String, dynamic>)[locale.name]
                as Map<String, dynamic>)[field]
            as String;
    List<Map<String, dynamic>> items(String key) =>
        (json[key] as List).cast<Map<String, dynamic>>();

    final options = <String, List<VisionAnswerOption>>{};
    for (final answer in items('answers')) {
      options
          .putIfAbsent(answer['questionCode'] as String, () => [])
          .add(
            VisionAnswerOption(
              valueCode: answer['valueCode'] as String,
              label: text(answer, 'label'),
            ),
          );
    }
    return VisionCatalog(
      categories: [
        for (final item in items('categories'))
          VisionCategory(
            code: item['code'] as String,
            icon: item['icon'] as String?,
            name: text(item, 'name'),
          ),
      ],
      feelings: [
        for (final item in items('feelings'))
          VisionFeeling(
            code: item['code'] as String,
            label: text(item, 'label'),
            suggestedCategoryCodes:
                (item['suggestedCategoryCodes'] as List).cast<String>(),
          ),
      ],
      questions: [
        for (final item in items('questions'))
          VisionQuestion(
            code: item['code'] as String,
            categoryCode: item['categoryCode'] as String,
            fieldKey: item['fieldKey'] as String,
            maxSelect: item['maxSelect'] as int,
            required: item['required'] as bool,
            prompt: text(item, 'prompt'),
            helper: text(item, 'helper'),
            options: options[item['code']] ?? const [],
          ),
      ],
      templates: [
        for (final item in items('templates'))
          StatementTemplate(
            categoryCode: item['categoryCode'] as String,
            isPrimary: item['kind'] == 'primary',
            body: text(item, 'body'),
          ),
      ],
    );
  }

  final List<VisionCategory> categories;
  final List<VisionFeeling> feelings;
  final List<VisionQuestion> questions;
  final List<StatementTemplate> templates;

  VisionCategory? category(String code) =>
      categories.where((category) => category.code == code).firstOrNull;

  VisionFeeling? feeling(String code) =>
      feelings.where((feeling) => feeling.code == code).firstOrNull;

  List<VisionQuestion> questionsFor(String categoryCode) =>
      questions.where((q) => q.categoryCode == categoryCode).toList();

  /// Feelings suggested for [categoryCode] first; every feeling stays
  /// selectable because feelings are independent of categories.
  List<VisionFeeling> feelingsFor(String categoryCode) => [
    ...feelings.where((f) => f.suggestedCategoryCodes.contains(categoryCode)),
    ...feelings.where((f) => !f.suggestedCategoryCodes.contains(categoryCode)),
  ];
}

final visionCatalogProvider = FutureProvider.family<VisionCatalog, SoulLocale>((
  ref,
  locale,
) {
  return ref.watch(contentRepositoryProvider).visionCatalog(locale);
});

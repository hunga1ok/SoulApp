import '../../core/localization/soul_locale.dart';
import '../../data/content/vision_catalog.dart';

/// A guided-question answer: chosen suggestion codes and/or the user's own
/// words.
class VisionAnswer {
  const VisionAnswer({this.valueCodes = const [], this.customText = ''});

  final List<String> valueCodes;
  final String customText;

  bool get isEmpty => valueCodes.isEmpty && customText.trim().isEmpty;
}

/// Maximum Vision statement length in characters.
const visionStatementMaxLength = 2000;

/// Drafts a statement from the category's templates: the primary template
/// when every placeholder can be filled, otherwise the short one, otherwise
/// an empty draft for the user to write.
String draftVisionStatement({
  required VisionCatalog catalog,
  required String categoryCode,
  required Map<String, VisionAnswer> answers,
  required List<String> feelingCodes,
  required SoulLocale locale,
}) {
  final values = <String, String>{};
  for (final question in catalog.questionsFor(categoryCode)) {
    final answer = answers[question.code];
    if (answer == null || answer.isEmpty) continue;
    final labels = [
      for (final option in question.options)
        if (answer.valueCodes.contains(option.valueCode))
          _lowerFirst(option.label),
      if (answer.customText.trim().isNotEmpty) answer.customText.trim(),
    ];
    values[question.fieldKey] = _joinList(labels, locale);
  }
  // Never fall back to generic aspirations when the user supplied answers.
  // Keep each answer in its question's context, including the concrete action.
  if (values.isNotEmpty) {
    final category = catalog.category(categoryCode)?.name ?? '';
    final parts = <String>[
      locale == SoulLocale.vi
          ? 'Tầm nhìn của tôi — $category.'
          : 'My vision — $category.',
      for (final question in catalog.questionsFor(categoryCode))
        if (values[question.fieldKey] case final value?)
          '${question.summaryPrefix} $value.',
    ];
    final feelings = [
      for (final code in feelingCodes)
        if (catalog.feeling(code) case final feeling?)
          _lowerFirst(feeling.label),
    ];
    if (feelings.isNotEmpty) {
      parts.add(
        locale == SoulLocale.vi
            ? 'Tôi muốn cảm thấy ${_joinList(feelings, locale)} khi sống với tầm nhìn này.'
            : 'I want to feel ${_joinList(feelings, locale)} as I live this vision.',
      );
    }
    return parts.join('\n\n');
  }
  for (final (index, code) in feelingCodes.indexed) {
    final feeling = catalog.feeling(code);
    if (feeling != null) {
      values['feeling_${index + 1}'] = _lowerFirst(feeling.label);
    }
  }

  final templates =
      catalog.templates.where((t) => t.categoryCode == categoryCode).toList()
        ..sort((a, b) => (a.isPrimary ? 0 : 1).compareTo(b.isPrimary ? 0 : 1));
  for (final template in templates) {
    final placeholders = RegExp(
      r'\{(\w+)\}',
    ).allMatches(template.body).map((match) => match[1]!);
    if (placeholders.every(values.containsKey)) {
      return template.body.replaceAllMapped(
        RegExp(r'\{(\w+)\}'),
        (match) => values[match[1]]!,
      );
    }
  }
  return '';
}

String _lowerFirst(String text) =>
    text.isEmpty ? text : text[0].toLowerCase() + text.substring(1);

String _joinList(List<String> items, SoulLocale locale) {
  if (items.length < 2) return items.join();
  final and = locale == SoulLocale.vi ? 'và' : 'and';
  return '${items.sublist(0, items.length - 1).join(', ')} $and ${items.last}';
}

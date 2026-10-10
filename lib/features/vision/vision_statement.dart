import '../../core/localization/soul_locale.dart';
import '../../data/content/vision_catalog.dart';
import '../../data/repositories/vision_repository.dart';

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

final _legacyHeaderPattern = RegExp(
  r'^(?:Tầm nhìn của tôi|My vision|나의 비전|私のビジョン|Ma vision|我的愿景)\s*[—\-–][^\n]*\n*',
  caseSensitive: false,
);

/// Removes legacy "My vision — Category." header lines when a category tag pill
/// is already displayed above the statement.
String cleanVisionStatement(String statement) {
  final cleaned = statement.replaceFirst(_legacyHeaderPattern, '').trim();
  return cleaned.isEmpty ? statement.trim() : cleaned;
}

/// Resolves the localized Vision statement for [locale], re-drafting from the
/// user's structured answers when the app language changes.
String resolveVisionStatement({
  required Vision vision,
  required VisionCatalog? catalog,
  required SoulLocale locale,
}) {
  if (catalog != null &&
      vision.answers.isNotEmpty &&
      vision.locale != locale.name) {
    final answerMap = <String, VisionAnswer>{
      for (final entry in vision.answers.entries)
        entry.key: VisionAnswer(
          valueCodes: entry.value.valueCodes,
          customText: entry.value.customText,
        ),
    };
    final redrafted = draftVisionStatement(
      catalog: catalog,
      categoryCode: vision.categoryCode,
      answers: answerMap,
      feelingCodes: vision.feelingCodes,
      locale: locale,
    );
    if (redrafted.trim().isNotEmpty) {
      return cleanVisionStatement(redrafted);
    }
  }
  return cleanVisionStatement(vision.statement);
}

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
    final parts = <String>[
      for (final question in catalog.questionsFor(categoryCode))
        if (values[question.fieldKey] case final value?)
          _formatAnswerSentence(question.summaryPrefix, value, locale),
    ];
    final feelings = [
      for (final code in feelingCodes)
        if (catalog.feeling(code) case final feeling?)
          _lowerFirst(feeling.label),
    ];
    if (feelings.isNotEmpty) {
      final joinedFeelings = _joinList(feelings, locale);
      final feelingSentence = switch (locale) {
        SoulLocale.vi =>
          'Tôi muốn cảm thấy $joinedFeelings khi sống với tầm nhìn này.',
        SoulLocale.en =>
          'I want to feel $joinedFeelings as I live this vision.',
        SoulLocale.ko => '이 비전을 살아가며 $joinedFeelings 감정을 느끼고 싶습니다.',
        SoulLocale.ja => 'このビジョンを生きながら、$joinedFeelings気持ちを感じたいです。',
        SoulLocale.fr =>
          'Je veux me sentir $joinedFeelings en vivant cette vision.',
        SoulLocale.zh => '当我活出这个愿景时，我希望能感受到$joinedFeelings。',
      };
      parts.add(feelingSentence);
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

String _formatAnswerSentence(
  String summaryPrefix,
  String value,
  SoulLocale locale,
) {
  final prefix = summaryPrefix.trim();
  final cleanVal = value.trim();
  final endPunct =
      (locale == SoulLocale.ja || locale == SoulLocale.zh) ? '。' : '.';
  if (prefix.isEmpty) {
    return cleanVal.endsWith('.') || cleanVal.endsWith('。')
        ? cleanVal
        : '$cleanVal$endPunct';
  }
  final separator =
      (locale == SoulLocale.ja || locale == SoulLocale.zh) ? '' : ' ';
  final combined = '$prefix$separator$cleanVal';
  return combined.endsWith('.') || combined.endsWith('。')
      ? combined
      : '$combined$endPunct';
}

String _lowerFirst(String text) =>
    text.isEmpty ? text : text[0].toLowerCase() + text.substring(1);

String _joinList(List<String> items, SoulLocale locale) {
  if (items.length < 2) return items.join();
  final and = switch (locale) {
    SoulLocale.vi => 'và',
    SoulLocale.en => 'and',
    SoulLocale.ko => '그리고',
    SoulLocale.ja => 'と',
    SoulLocale.fr => 'et',
    SoulLocale.zh => '与',
  };
  return '${items.sublist(0, items.length - 1).join(', ')} $and ${items.last}';
}

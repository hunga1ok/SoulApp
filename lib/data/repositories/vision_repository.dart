import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/localization/soul_locale.dart';
import '../local/soul_database.dart';

/// A Vision with its feelings in the order the user chose them.
class Vision {
  const Vision({
    required this.id,
    required this.categoryCode,
    required this.statement,
    required this.feelingCodes,
    required this.imagePath,
    required this.createdAt,
    this.locale = 'vi',
    this.answers = const {},
  });

  final String id;
  final String categoryCode;
  final String statement;
  final List<String> feelingCodes;

  /// Relative to the app support directory.
  final String? imagePath;
  final DateTime createdAt;
  final String locale;
  final Map<String, ({List<String> valueCodes, String customText})> answers;
}

/// Everything needed to save a new Vision.
class NewVision {
  const NewVision({
    required this.id,
    required this.categoryCode,
    required this.statement,
    required this.feelingCodes,
    required this.answers,
    required this.locale,
    this.imagePath,
  });

  /// Client-generated when the builder opens, so a repeated save is a no-op.
  final String id;
  final String categoryCode;
  final String statement;
  final List<String> feelingCodes;

  /// Question code → (suggested value codes, own text).
  final Map<String, ({List<String> valueCodes, String customText})> answers;
  final SoulLocale locale;
  final String? imagePath;
}

final visionRepositoryProvider = Provider<VisionRepository>((ref) {
  return VisionRepository(ref.watch(soulDatabaseProvider));
});

class VisionRepository {
  VisionRepository(this._database, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final SoulDatabase _database;
  final DateTime Function() _now;

  /// Active Visions, newest first.
  Future<List<Vision>> active() async {
    final rows =
        await (_database.select(_database.visions)
              ..where((row) => row.status.equals('active'))
              ..orderBy([
                (row) => OrderingTerm.desc(row.createdAt),
                (row) => OrderingTerm.asc(row.id),
              ]))
            .get();
    return [for (final row in rows) await _withFeelings(row)];
  }

  Future<Vision?> find(String id) async {
    final row =
        await (_database.select(_database.visions)
          ..where((row) => row.id.equals(id))).getSingleOrNull();
    return row == null ? null : _withFeelings(row);
  }

  /// Saves [vision]; saving the same id again changes nothing.
  Future<void> create(NewVision vision) {
    if (vision.feelingCodes.isEmpty || vision.feelingCodes.length > 3) {
      throw ArgumentError.value(
        vision.feelingCodes,
        'feelingCodes',
        'A Vision needs 1 to 3 feelings.',
      );
    }
    return _database.transaction(() async {
      if (await find(vision.id) != null) return;
      final now = _now();
      await _database
          .into(_database.visions)
          .insert(
            VisionsCompanion.insert(
              id: vision.id,
              categoryCode: vision.categoryCode,
              statement: vision.statement.trim(),
              imagePath: Value(vision.imagePath),
              locale: vision.locale.name,
              status: 'active',
              createdAt: now,
              updatedAt: now,
            ),
          );
      for (final (index, code) in vision.feelingCodes.indexed) {
        await _database
            .into(_database.visionFeelings)
            .insert(
              VisionFeelingsCompanion.insert(
                visionId: vision.id,
                feelingCode: code,
                position: index + 1,
              ),
            );
      }
      for (final MapEntry(key: questionCode, value: answer)
          in vision.answers.entries) {
        final customText = answer.customText.trim();
        await _database
            .into(_database.visionAnswers)
            .insert(
              VisionAnswersCompanion.insert(
                visionId: vision.id,
                questionCode: questionCode,
                valueCodes: jsonEncode(answer.valueCodes),
                customText: Value(customText.isEmpty ? null : customText),
              ),
            );
      }
    });
  }

  /// Removes the Vision from the board; nothing is deleted.
  Future<void> archive(String id) async {
    final now = _now();
    await (_database.update(_database.visions)
      ..where((row) => row.id.equals(id) & row.status.equals('active'))).write(
      VisionsCompanion(
        status: const Value('archived'),
        archivedAt: Value(now),
        updatedAt: Value(now),
      ),
    );
  }

  Future<Vision> _withFeelings(VisionRow row) async {
    final feelings =
        await (_database.select(_database.visionFeelings)
              ..where((feeling) => feeling.visionId.equals(row.id))
              ..orderBy([(feeling) => OrderingTerm.asc(feeling.position)]))
            .get();
    final answerRows =
        await (_database.select(_database.visionAnswers)
          ..where((answer) => answer.visionId.equals(row.id))).get();
    final answers = <String, ({List<String> valueCodes, String customText})>{
      for (final answer in answerRows)
        answer.questionCode: (
          valueCodes:
              (jsonDecode(answer.valueCodes) as List<dynamic>).cast<String>(),
          customText: answer.customText ?? '',
        ),
    };
    return Vision(
      id: row.id,
      categoryCode: row.categoryCode,
      statement: row.statement,
      feelingCodes: [for (final feeling in feelings) feeling.feelingCode],
      imagePath: row.imagePath,
      createdAt: row.createdAt,
      locale: row.locale,
      answers: answers,
    );
  }
}

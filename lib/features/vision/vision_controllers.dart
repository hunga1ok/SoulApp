import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../app/app_state.dart';
import '../../data/content/vision_catalog.dart';
import '../../data/local/image_store.dart';
import '../../data/repositories/vision_repository.dart';
import 'vision_statement.dart';

/// Active Visions on the board, newest first.
final visionsProvider = FutureProvider.autoDispose<List<Vision>>((ref) {
  return ref.watch(visionRepositoryProvider).active();
});

final visionProvider = FutureProvider.autoDispose.family<Vision?, String>((
  ref,
  id,
) {
  return ref.watch(visionRepositoryProvider).find(id);
});

/// The catalog in the active locale.
final activeVisionCatalogProvider = FutureProvider.autoDispose<VisionCatalog>((
  ref,
) {
  final locale = ref.watch(appStateProvider.select((s) => s.locale));
  return ref.watch(visionCatalogProvider(locale ?? SoulLocale.en).future);
});

/// Archives a Vision and refreshes the board.
Future<void> archiveVision(WidgetRef ref, String id) async {
  await ref.read(visionRepositoryProvider).archive(id);
  ref.invalidate(visionsProvider);
}

class VisionBuilderState {
  const VisionBuilderState({
    required this.id,
    this.categoryCode,
    this.answers = const {},
    this.feelingCodes = const [],
    this.statement = '',
    this.statementEdited = false,
    this.imageSourcePath,
    this.save = const AsyncData(false),
  });

  /// Client-generated Vision id, so a repeated save is a no-op.
  final String id;
  final String? categoryCode;
  final Map<String, VisionAnswer> answers;
  final List<String> feelingCodes;
  final String statement;

  /// Once edited, the statement is no longer redrafted from choices.
  final bool statementEdited;

  /// Picked photo, copied into app storage only when the Vision is saved.
  final String? imageSourcePath;

  /// `true` once saved; an error keeps every builder choice for a retry.
  final AsyncValue<bool> save;

  VisionBuilderState copyWith({
    String? categoryCode,
    Map<String, VisionAnswer>? answers,
    List<String>? feelingCodes,
    String? statement,
    bool? statementEdited,
    String? Function()? imageSourcePath,
    AsyncValue<bool>? save,
  }) => VisionBuilderState(
    id: id,
    categoryCode: categoryCode ?? this.categoryCode,
    answers: answers ?? this.answers,
    feelingCodes: feelingCodes ?? this.feelingCodes,
    statement: statement ?? this.statement,
    statementEdited: statementEdited ?? this.statementEdited,
    imageSourcePath:
        imageSourcePath == null ? this.imageSourcePath : imageSourcePath(),
    save: save ?? this.save,
  );
}

final visionBuilderProvider =
    NotifierProvider.autoDispose<VisionBuilderController, VisionBuilderState>(
      VisionBuilderController.new,
    );

/// Builder choices live here while the builder route is open, so moving
/// back and forth between steps never loses an answer.
class VisionBuilderController extends AutoDisposeNotifier<VisionBuilderState> {
  static const maxFeelings = 3;

  @override
  VisionBuilderState build() => VisionBuilderState(id: const Uuid().v4());

  /// Choosing another category clears answers that belong to the old one.
  void selectCategory(String code) {
    if (state.categoryCode == code) return;
    state = state.copyWith(
      categoryCode: code,
      answers: const {},
      statement: '',
      statementEdited: false,
    );
  }

  void toggleOption(VisionQuestion question, String valueCode) {
    final answer = state.answers[question.code] ?? const VisionAnswer();
    final codes = [...answer.valueCodes];
    if (codes.contains(valueCode)) {
      codes.remove(valueCode);
    } else if (question.maxSelect == 1) {
      codes
        ..clear()
        ..add(valueCode);
    } else if (codes.length < question.maxSelect) {
      codes.add(valueCode);
    }
    _setAnswer(
      question,
      VisionAnswer(valueCodes: codes, customText: answer.customText),
    );
  }

  void setCustomText(VisionQuestion question, String text) {
    final answer = state.answers[question.code] ?? const VisionAnswer();
    _setAnswer(
      question,
      VisionAnswer(valueCodes: answer.valueCodes, customText: text),
    );
  }

  void _setAnswer(VisionQuestion question, VisionAnswer answer) {
    state = state.copyWith(answers: {...state.answers, question.code: answer});
  }

  /// Toggles a feeling; a fourth one is ignored.
  void toggleFeeling(String code) {
    final codes = [...state.feelingCodes];
    if (!codes.remove(code)) {
      if (codes.length >= maxFeelings) return;
      codes.add(code);
    }
    state = state.copyWith(feelingCodes: codes);
  }

  /// Drafts the statement from the current choices unless the user has
  /// already edited it.
  void draftStatement(VisionCatalog catalog, SoulLocale locale) {
    if (state.statementEdited || state.categoryCode == null) return;
    state = state.copyWith(
      statement: draftVisionStatement(
        catalog: catalog,
        categoryCode: state.categoryCode!,
        answers: state.answers,
        feelingCodes: state.feelingCodes,
        locale: locale,
      ),
    );
  }

  void editStatement(String text) {
    state = state.copyWith(statement: text, statementEdited: true);
  }

  void setImage(String? path) {
    state = state.copyWith(imageSourcePath: () => path);
  }

  /// Copies the photo into app storage, then saves the Vision. On failure
  /// the builder keeps every choice so the user can retry or remove the
  /// photo.
  Future<void> save() async {
    if (state.save.isLoading || state.save.valueOrNull == true) return;
    state = state.copyWith(save: const AsyncLoading());
    final result = await AsyncValue.guard(() async {
      final source = state.imageSourcePath;
      final imagePath =
          source == null
              ? null
              : await ref.read(imageStoreProvider).saveVisionImage(source);
      try {
        await ref
            .read(visionRepositoryProvider)
            .create(
              NewVision(
                id: state.id,
                categoryCode: state.categoryCode!,
                statement: state.statement,
                feelingCodes: state.feelingCodes,
                answers: {
                  for (final MapEntry(key: code, value: answer)
                      in state.answers.entries)
                    if (!answer.isEmpty)
                      code: (
                        valueCodes: answer.valueCodes,
                        customText: answer.customText,
                      ),
                },
                locale: ref.read(appStateProvider).locale ?? SoulLocale.en,
                imagePath: imagePath,
              ),
            );
      } catch (_) {
        // Do not leave an unreferenced copy behind; the retry copies again.
        if (imagePath != null) {
          await ref.read(imageStoreProvider).delete(imagePath);
        }
        rethrow;
      }
      ref.invalidate(visionsProvider);
      return true;
    });
    state = state.copyWith(save: result);
  }
}

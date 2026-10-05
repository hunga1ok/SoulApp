import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/design_system/design_system.dart';
import '../../core/platform/image_picking.dart';
import '../../data/content/vision_catalog.dart';
import '../../l10n/app_localizations.dart';
import 'vision_controllers.dart';
import 'vision_statement.dart';
import 'vision_widgets.dart';

/// Guided Vision builder: category, the category's questions, 1–3 feelings,
/// statement, optional photo, then preview and save. Back (header or system)
/// returns to the previous step without losing answers.
class VisionBuilderScreen extends ConsumerStatefulWidget {
  const VisionBuilderScreen({super.key});

  @override
  ConsumerState<VisionBuilderScreen> createState() =>
      _VisionBuilderScreenState();
}

class _VisionBuilderScreenState extends ConsumerState<VisionBuilderScreen> {
  var _step = 0;

  void _leave() => context.go('/app/vision');

  void _back() => _step == 0 ? _leave() : setState(() => _step--);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final catalog = ref.watch(activeVisionCatalogProvider);
    final state = ref.watch(visionBuilderProvider);
    final controller = ref.read(visionBuilderProvider.notifier);
    final locale = ref.watch(appStateProvider).locale ?? SoulLocale.en;

    ref.listen(visionBuilderProvider.select((s) => s.save), (_, save) {
      if (save.valueOrNull == true) _leave();
    });

    final Widget content;
    if (catalog.hasError) {
      content = SoulErrorState(
        onRetry: () => ref.invalidate(activeVisionCatalogProvider),
      );
    } else if (!catalog.hasValue) {
      content = const SoulLoadingState();
    } else {
      final data = catalog.value!;
      final questions =
          state.categoryCode == null
              ? const <VisionQuestion>[]
              : data.questionsFor(state.categoryCode!);
      // Steps: category, questions…, feelings, statement, photo, preview.
      final feelingsStep = 1 + questions.length;
      final total = feelingsStep + 4;
      final categoryName = data.category(state.categoryCode ?? '')?.name ?? '';
      String eyebrow() =>
          l10n.visionStepLabel(categoryName.toUpperCase(), _step + 1, total);
      void next() => setState(() => _step++);

      if (_step == 0) {
        content = _CategoryStep(
          categories: data.categories,
          onSelected: (code) {
            controller.selectCategory(code);
            next();
          },
        );
      } else if (_step < feelingsStep) {
        final question = questions[_step - 1];
        content = _QuestionStep(
          key: ValueKey(question.code),
          eyebrow: eyebrow(),
          question: question,
          answer: state.answers[question.code] ?? const VisionAnswer(),
          onToggle: (value) => controller.toggleOption(question, value),
          onCustomText: (text) => controller.setCustomText(question, text),
          onNext: next,
          onQuickStart: () => setState(() => _step = feelingsStep),
        );
      } else if (_step == feelingsStep) {
        content = _FeelingsStep(
          eyebrow: eyebrow(),
          feelings: data.feelingsFor(state.categoryCode!),
          selected: state.feelingCodes,
          onToggle: controller.toggleFeeling,
          onNext: () {
            controller.draftStatement(data, locale);
            next();
          },
        );
      } else if (_step == feelingsStep + 1) {
        content = _StatementStep(
          eyebrow: eyebrow(),
          statement: state.statement,
          onChanged: controller.editStatement,
          onNext: next,
        );
      } else if (_step == feelingsStep + 2) {
        content = _PhotoStep(
          eyebrow: eyebrow(),
          imagePath: state.imageSourcePath,
          onPicked: controller.setImage,
          onNext: next,
        );
      } else {
        content = _PreviewStep(
          eyebrow: eyebrow(),
          categoryName: categoryName,
          statement: state.statement,
          feelingLabels: [
            for (final code in state.feelingCodes)
              data.feeling(code)?.label ?? code,
          ],
          imagePath: state.imageSourcePath,
          save: state.save,
          onSave: controller.save,
        );
      }
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        appBar: SoulAppBar(title: l10n.createVision, onBack: _back),
        body: content,
      ),
    );
  }
}

/// Scrollable step body with a heading and a bottom action.
class _StepLayout extends StatelessWidget {
  const _StepLayout({
    this.eyebrow,
    required this.title,
    this.body,
    required this.children,
    this.footer,
  });

  final String? eyebrow;
  final String title;
  final String? body;
  final List<Widget> children;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        SoulSpace.lg,
        SoulSpace.xs,
        SoulSpace.lg,
        SoulSpace.xl,
      ),
      children: [
        if (eyebrow != null) ...[
          Text(
            eyebrow!,
            style: textTheme.bodyMedium?.copyWith(letterSpacing: 1.1),
          ),
          const SizedBox(height: SoulSpace.xs),
        ],
        Text(title, style: textTheme.headlineSmall),
        if (body != null) ...[
          const SizedBox(height: SoulSpace.xs),
          Text(body!, style: textTheme.bodyLarge),
        ],
        const SizedBox(height: SoulSpace.lg),
        ...children,
        if (footer != null) ...[const SizedBox(height: SoulSpace.lg), footer!],
      ],
    );
  }
}

class _CategoryStep extends StatelessWidget {
  const _CategoryStep({required this.categories, required this.onSelected});

  final List<VisionCategory> categories;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _StepLayout(
      title: l10n.chooseCategoryTitle,
      body: l10n.chooseCategoryBody,
      children: [
        for (final category in categories)
          Padding(
            padding: const EdgeInsets.only(bottom: SoulSpace.xs),
            child: SoulCard(
              onTap: () => onSelected(category.code),
              child: Row(
                children: [
                  if (category.icon != null) ...[
                    ExcludeSemantics(
                      child: Text(
                        category.icon!,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(width: SoulSpace.sm),
                  ],
                  Expanded(child: Text(category.name)),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _QuestionStep extends StatefulWidget {
  const _QuestionStep({
    super.key,
    required this.eyebrow,
    required this.question,
    required this.answer,
    required this.onToggle,
    required this.onCustomText,
    required this.onNext,
    required this.onQuickStart,
  });

  final String eyebrow;
  final VisionQuestion question;
  final VisionAnswer answer;
  final ValueChanged<String> onToggle;
  final ValueChanged<String> onCustomText;
  final VoidCallback onNext;
  final VoidCallback onQuickStart;

  @override
  State<_QuestionStep> createState() => _QuestionStepState();
}

class _QuestionStepState extends State<_QuestionStep> {
  late final _custom = TextEditingController(text: widget.answer.customText);

  @override
  void dispose() {
    _custom.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final question = widget.question;
    final answer = widget.answer;
    final full = answer.valueCodes.length >= question.maxSelect;
    final canContinue = !question.required || !answer.isEmpty;
    return _StepLayout(
      eyebrow: widget.eyebrow,
      title: question.prompt,
      body: question.maxSelect > 1 ? l10n.chooseUpTo(question.maxSelect) : null,
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!canContinue) ...[
            Text(
              l10n.answerRequiredHint,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: SoulSpace.xs),
          ],
          SoulButton(
            label: l10n.continueLabel,
            onPressed: canContinue ? widget.onNext : null,
          ),
          const SizedBox(height: SoulSpace.xs),
          TextButton(
            onPressed: widget.onQuickStart,
            child: Text(l10n.visionQuickStart),
          ),
        ],
      ),
      children: [
        Wrap(
          spacing: SoulSpace.xs,
          runSpacing: SoulSpace.xs,
          children: [
            for (final option in question.options)
              SoulChip(
                label: option.label,
                selected: answer.valueCodes.contains(option.valueCode),
                // Single choice replaces; a full multi choice disables the
                // rest until one is deselected.
                onSelected:
                    question.maxSelect > 1 &&
                            full &&
                            !answer.valueCodes.contains(option.valueCode)
                        ? null
                        : (_) => widget.onToggle(option.valueCode),
              ),
          ],
        ),
        const SizedBox(height: SoulSpace.md),
        SoulTextField(
          controller: _custom,
          label: question.helper,
          textCapitalization: TextCapitalization.sentences,
          onChanged: widget.onCustomText,
        ),
      ],
    );
  }
}

class _FeelingsStep extends StatelessWidget {
  const _FeelingsStep({
    required this.eyebrow,
    required this.feelings,
    required this.selected,
    required this.onToggle,
    required this.onNext,
  });

  final String eyebrow;
  final List<VisionFeeling> feelings;
  final List<String> selected;
  final ValueChanged<String> onToggle;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final full = selected.length >= VisionBuilderController.maxFeelings;
    return _StepLayout(
      eyebrow: eyebrow,
      title: l10n.feelingsTitle,
      body: full ? l10n.feelingsLimitReached : l10n.feelingsHint,
      footer: SoulButton(
        label: l10n.continueLabel,
        onPressed: selected.isEmpty ? null : onNext,
      ),
      children: [
        Wrap(
          spacing: SoulSpace.xs,
          runSpacing: SoulSpace.xs,
          children: [
            for (final feeling in feelings)
              SoulChip(
                label: feeling.label,
                selected: selected.contains(feeling.code),
                onSelected:
                    full && !selected.contains(feeling.code)
                        ? null
                        : (_) => onToggle(feeling.code),
              ),
          ],
        ),
      ],
    );
  }
}

class _StatementStep extends StatefulWidget {
  const _StatementStep({
    required this.eyebrow,
    required this.statement,
    required this.onChanged,
    required this.onNext,
  });

  final String eyebrow;
  final String statement;
  final ValueChanged<String> onChanged;
  final VoidCallback onNext;

  @override
  State<_StatementStep> createState() => _StatementStepState();
}

class _StatementStepState extends State<_StatementStep> {
  late final _controller = TextEditingController(text: widget.statement);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final text = _controller.text.trim();
    final tooLong = text.length > visionStatementMaxLength;
    return _StepLayout(
      eyebrow: widget.eyebrow,
      title: l10n.statementTitle,
      body: widget.statement.isEmpty ? l10n.statementEmpty : l10n.statementBody,
      footer: SoulButton(
        label: l10n.continueLabel,
        onPressed: text.isEmpty || tooLong ? null : widget.onNext,
      ),
      children: [
        SoulTextField(
          controller: _controller,
          label: l10n.statementLabel,
          maxLines: 6,
          textCapitalization: TextCapitalization.sentences,
          errorText:
              tooLong ? l10n.statementTooLong(visionStatementMaxLength) : null,
          onChanged: (value) {
            widget.onChanged(value);
            setState(() {});
          },
        ),
      ],
    );
  }
}

class _PhotoStep extends ConsumerWidget {
  const _PhotoStep({
    required this.eyebrow,
    required this.imagePath,
    required this.onPicked,
    required this.onNext,
  });

  final String eyebrow;
  final String? imagePath;
  final ValueChanged<String?> onPicked;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    Future<void> pick({required bool fromCamera}) async {
      final path = await ref
          .read(imagePickingProvider)
          .pick(fromCamera: fromCamera);
      if (path != null) onPicked(path);
    }

    return _StepLayout(
      eyebrow: eyebrow,
      title: l10n.visionImageTitle,
      body: l10n.visionImageBody,
      footer: SoulButton(label: l10n.continueLabel, onPressed: onNext),
      children: [
        if (imagePath != null) ...[
          VisionPhoto(filePath: imagePath),
          const SizedBox(height: SoulSpace.sm),
        ],
        SoulButton(
          label: l10n.chooseFromLibrary,
          variant: SoulButtonVariant.secondary,
          icon: const Icon(Icons.photo_library_outlined),
          onPressed: () => pick(fromCamera: false),
        ),
        const SizedBox(height: SoulSpace.xs),
        SoulButton(
          label: l10n.takePhoto,
          variant: SoulButtonVariant.secondary,
          icon: const Icon(Icons.photo_camera_outlined),
          onPressed: () => pick(fromCamera: true),
        ),
        if (imagePath != null) ...[
          const SizedBox(height: SoulSpace.xs),
          TextButton(
            onPressed: () => onPicked(null),
            child: Text(l10n.removePhoto),
          ),
        ],
      ],
    );
  }
}

class _PreviewStep extends StatelessWidget {
  const _PreviewStep({
    required this.eyebrow,
    required this.categoryName,
    required this.statement,
    required this.feelingLabels,
    required this.imagePath,
    required this.save,
    required this.onSave,
  });

  final String eyebrow;
  final String categoryName;
  final String statement;
  final List<String> feelingLabels;
  final String? imagePath;
  final AsyncValue<bool> save;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return _StepLayout(
      eyebrow: eyebrow,
      title: l10n.reviewVisionTitle,
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (save.hasError) ...[
            Semantics(
              liveRegion: true,
              child: Text(
                l10n.visionSaveFailed,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(color: SoulColors.error),
              ),
            ),
            const SizedBox(height: SoulSpace.xs),
          ],
          SoulButton(
            label: save.hasError ? l10n.retry : l10n.saveToVisionBoard,
            onPressed: save.isLoading ? null : onSave,
          ),
        ],
      ),
      children: [
        SoulCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (imagePath != null) ...[
                VisionPhoto(filePath: imagePath, height: 160),
                const SizedBox(height: SoulSpace.sm),
              ],
              Text(
                categoryName.toUpperCase(),
                style: textTheme.bodyMedium?.copyWith(letterSpacing: 1.1),
              ),
              const SizedBox(height: SoulSpace.xs),
              Text(statement.trim(), style: textTheme.titleLarge),
              const SizedBox(height: SoulSpace.sm),
              FeelingLabels(labels: feelingLabels),
            ],
          ),
        ),
      ],
    );
  }
}

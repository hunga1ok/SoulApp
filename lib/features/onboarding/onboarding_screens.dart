import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/design_system/design_system.dart';
import '../../data/content/content_repository.dart';
import '../../data/repositories/reminder_repository.dart';
import '../../l10n/app_localizations.dart';
import 'language_suggestion.dart';
import 'onboarding_controllers.dart';
import 'preferred_name_validation.dart';

/// Language-neutral gate. Both choices are always shown as endonyms. The
/// device-suggested language is highlighted as the primary button, but no
/// locale is stored until the user taps one of the choices.
class LanguageGateScreen extends ConsumerWidget {
  const LanguageGateScreen({super.key});

  static const _maxChoiceWidth = 240.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final suggested = ref.watch(suggestedLocaleProvider);
    final choices = {
      SoulLocale.vi: l10n.languageEndonymVi,
      SoulLocale.en: l10n.languageEndonymEn,
    };

    return _OnboardingLayout(
      padding: const EdgeInsets.all(SoulSpace.xl),
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _Logo(width: 138, semanticLabel: l10n.appTitle),
        const SizedBox(height: SoulSpace.xl + SoulSpace.lg),
        for (final MapEntry(key: locale, value: label) in choices.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: SoulSpace.sm),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _maxChoiceWidth),
              child: SoulButton(
                label: label,
                variant:
                    locale == suggested
                        ? SoulButtonVariant.primary
                        : SoulButtonVariant.secondary,
                onPressed: () async {
                  await ref.read(appStateProvider).selectLocale(locale);
                  if (context.mounted) context.go('/onboarding/name');
                },
              ),
            ),
          ),
      ],
    );
  }
}

/// Asks what Soul should call the user, right after the language choice
/// ([isEditing] false) or from Profile ([isEditing] true). Nothing is saved
/// until the user confirms.
class PreferredNameScreen extends ConsumerStatefulWidget {
  const PreferredNameScreen({super.key, this.isEditing = false});

  final bool isEditing;

  @override
  ConsumerState<PreferredNameScreen> createState() =>
      _PreferredNameScreenState();
}

class _PreferredNameScreenState extends ConsumerState<PreferredNameScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(appStateProvider).preferredName,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (validatePreferredName(_controller.text) != null) return;
    await ref.read(appStateProvider).savePreferredName(_controller.text);
    // After onboarding the router guard moves on to Today by itself.
    if (widget.isEditing && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final issue = validatePreferredName(_controller.text);
    final canSave = issue == null;
    final layout = _OnboardingLayout(
      children: [
        const Spacer(),
        Text(
          l10n.whatShouldWeCallYou,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: SoulSpace.lg),
        SoulTextField(
          controller: _controller,
          label: l10n.nameHint,
          errorText:
              issue == PreferredNameIssue.tooLong
                  ? l10n.nameTooLong(preferredNameMaxLength)
                  : null,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          autofocus: true,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => canSave ? _save() : null,
        ),
        const Spacer(),
        const SizedBox(height: SoulSpace.lg),
        SoulButton(
          label: widget.isEditing ? l10n.save : l10n.saveAndContinue,
          onPressed: canSave ? _save : null,
        ),
      ],
    );
    if (!widget.isEditing) return layout;
    return Scaffold(
      appBar: SoulAppBar(title: l10n.editName, onBack: () => context.pop()),
      body: layout,
    );
  }
}

/// Asks what brings the user to Soul. At least one intention is required;
/// several may be chosen.
class IntentionScreen extends ConsumerStatefulWidget {
  const IntentionScreen({super.key});

  @override
  ConsumerState<IntentionScreen> createState() => _IntentionScreenState();
}

class _IntentionScreenState extends ConsumerState<IntentionScreen> {
  late final Set<String> _selected = {...ref.read(appStateProvider).intentions};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = ref.watch(appStateProvider).locale ?? SoulLocale.en;
    final intentions = ref.watch(intentionsProvider(locale));
    return _OnboardingLayout(
      children: [
        _StepHeading(title: l10n.intentionTitle, body: l10n.intentionBody),
        const SizedBox(height: SoulSpace.lg),
        switch (intentions) {
          AsyncData(:final value) => Wrap(
            spacing: SoulSpace.xs,
            runSpacing: SoulSpace.xs,
            children: [
              for (final intention in value)
                SoulChip(
                  label: intention.label,
                  selected: _selected.contains(intention.code),
                  onSelected:
                      (selected) => setState(
                        () =>
                            selected
                                ? _selected.add(intention.code)
                                : _selected.remove(intention.code),
                      ),
                ),
            ],
          ),
          // The state views scroll, so they cannot sit in this column.
          AsyncError() => Column(
            children: [
              Text(l10n.somethingWentWrong, textAlign: TextAlign.center),
              TextButton(
                onPressed: () => ref.invalidate(intentionsProvider(locale)),
                child: Text(l10n.retry),
              ),
            ],
          ),
          _ => const SoulLoadingState(),
        },
        const SizedBox(height: SoulSpace.lg),
        if (_selected.isEmpty && intentions.hasValue) ...[
          Text(
            l10n.intentionChooseOne,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: SoulSpace.xs),
        ],
        SoulButton(
          label: l10n.continueLabel,
          onPressed:
              _selected.isEmpty
                  ? null
                  : () => ref
                      .read(appStateProvider)
                      .saveIntentions(_selected.toList()),
        ),
      ],
    );
  }
}

/// Morning and evening reminder times, each of which can be turned off; the
/// whole step can be skipped.
class ReminderScreen extends ConsumerStatefulWidget {
  const ReminderScreen({super.key});

  @override
  ConsumerState<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends ConsumerState<ReminderScreen> {
  var _saving = false;

  Future<void> _finish(Future<void> Function() action) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final choices = ref.watch(reminderStepProvider);
    final controller = ref.read(reminderStepProvider.notifier);
    final labels = {
      ReminderKind.morning: l10n.reminderMorning,
      ReminderKind.evening: l10n.reminderEvening,
    };
    return _OnboardingLayout(
      children: [
        _StepHeading(title: l10n.remindersTitle, body: l10n.remindersBody),
        const SizedBox(height: SoulSpace.lg),
        for (final MapEntry(key: kind, value: label) in labels.entries)
          _ReminderRow(
            label: label,
            choice: choices[kind]!,
            onEnabled: (enabled) => controller.setEnabled(kind, enabled),
            onTime: (time) => controller.setTime(kind, time),
          ),
        const SizedBox(height: SoulSpace.lg),
        SoulButton(
          label: l10n.continueLabel,
          onPressed: _saving ? null : () => _finish(controller.confirm),
        ),
        const SizedBox(height: SoulSpace.xs),
        SoulButton(
          label: l10n.skipForNow,
          variant: SoulButtonVariant.secondary,
          onPressed: _saving ? null : () => _finish(controller.skip),
        ),
      ],
    );
  }
}

class _ReminderRow extends StatelessWidget {
  const _ReminderRow({
    required this.label,
    required this.choice,
    required this.onEnabled,
    required this.onTime,
  });

  final String label;
  final ReminderChoice choice;
  final ValueChanged<bool> onEnabled;
  final ValueChanged<TimeOfDay> onTime;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final time = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(choice.time, alwaysUse24HourFormat: true);
    return Padding(
      padding: const EdgeInsets.only(bottom: SoulSpace.xs),
      child: SoulCard(
        padding: const EdgeInsets.symmetric(
          horizontal: SoulSpace.md,
          vertical: SoulSpace.xxs,
        ),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            Semantics(
              button: true,
              label: l10n.changeReminderTime(label, time),
              excludeSemantics: true,
              child: TextButton(
                onPressed:
                    choice.enabled
                        ? () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: choice.time,
                          );
                          if (picked != null) onTime(picked);
                        }
                        : null,
                child: Text(time),
              ),
            ),
            Semantics(
              label: label,
              child: Switch(value: choice.enabled, onChanged: onEnabled),
            ),
          ],
        ),
      ),
    );
  }
}

/// Final onboarding step: starts Day 1 of the journey.
class JourneyReadyScreen extends ConsumerWidget {
  const JourneyReadyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final start = ref.watch(journeyStartProvider);
    return _OnboardingLayout(
      children: [
        _StepHeading(
          title: l10n.journeyReadyTitle,
          body: l10n.journeyReadyBody,
        ),
        const SizedBox(height: SoulSpace.xl),
        if (start.hasError) ...[
          Semantics(
            liveRegion: true,
            child: Text(
              l10n.somethingWentWrong,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: SoulColors.error),
            ),
          ),
          const SizedBox(height: SoulSpace.sm),
        ],
        SoulButton(
          label: start.hasError ? l10n.retry : l10n.beginDayOne,
          onPressed:
              start.isLoading
                  ? null
                  : () => ref.read(journeyStartProvider.notifier).start(),
        ),
      ],
    );
  }
}

class _StepHeading extends StatelessWidget {
  const _StepHeading({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: textTheme.displaySmall),
        const SizedBox(height: SoulSpace.sm),
        Text(body, style: textTheme.bodyLarge),
      ],
    );
  }
}

/// Scrollable onboarding page: content is centered when it fits and scrolls
/// on small screens, at large text scales and above the keyboard.
class _OnboardingLayout extends StatelessWidget {
  const _OnboardingLayout({
    required this.children,
    this.padding = const EdgeInsets.all(SoulSpace.lg),
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: padding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: crossAxisAlignment,
                  children: children,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({required this.width, required this.semanticLabel});

  final double width;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/soul_logo.png',
      width: width,
      semanticLabel: semanticLabel,
      errorBuilder: (context, error, stackTrace) => Text(semanticLabel),
    );
  }
}

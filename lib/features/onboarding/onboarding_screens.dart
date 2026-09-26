import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import 'language_suggestion.dart';
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

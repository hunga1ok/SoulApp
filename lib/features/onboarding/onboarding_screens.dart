import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/design_system/design_system.dart';
import '../../l10n/app_localizations.dart';
import 'language_suggestion.dart';

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
                  if (context.mounted) context.go('/auth');
                },
              ),
            ),
          ),
      ],
    );
  }
}

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return _OnboardingLayout(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: _Logo(width: 130, semanticLabel: l10n.appTitle),
        ),
        const SizedBox(height: SoulSpace.xl),
        Text(l10n.appTitle, style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: SoulSpace.sm),
        Text(l10n.authTagline, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: SoulSpace.xl + SoulSpace.xs),
        SoulButton(
          label: l10n.continueWithGoogle,
          icon: const Icon(Icons.g_mobiledata, size: 28),
          onPressed:
              kDebugMode
                  ? () async {
                    await ref
                        .read(appStateProvider)
                        .completeDevelopmentSignIn();
                    if (context.mounted) context.go('/onboarding/name');
                  }
                  : null,
        ),
        if (kDebugMode) ...[
          const SizedBox(height: SoulSpace.sm),
          Text(
            l10n.developmentAuthHint,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}

class PreferredNameScreen extends ConsumerStatefulWidget {
  const PreferredNameScreen({super.key});

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

  bool get _canSave => _controller.text.trim().isNotEmpty;

  Future<void> _save() async {
    if (!_canSave) return;
    await ref.read(appStateProvider).savePreferredName(_controller.text);
    if (mounted) context.go('/app/today');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _OnboardingLayout(
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
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          autofocus: true,
          onChanged: (_) => setState(() {}),
          onSubmitted: (_) => _save(),
        ),
        const Spacer(),
        const SizedBox(height: SoulSpace.lg),
        SoulButton(
          label: l10n.saveAndContinue,
          onPressed: _canSave ? _save : null,
        ),
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

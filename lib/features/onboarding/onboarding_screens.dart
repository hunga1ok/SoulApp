import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/design_system/design_system.dart';
import '../../core/errors/error_messages.dart';
import '../../l10n/app_localizations.dart';
import '../auth/session_controller.dart';
import '../auth/sign_in_controller.dart';
import 'language_suggestion.dart';
import 'preferred_name_controller.dart';

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
    final signIn = ref.watch(signInControllerProvider);
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
        // DEVELOPMENT BOUNDARY: debug builds sign in through the backend's
        // development login; release builds keep the button disabled until
        // Google Sign-In (OB-002) is configured.
        SoulButton(
          label: l10n.continueWithGoogle,
          icon: const Icon(Icons.g_mobiledata, size: 28),
          onPressed:
              kDebugMode && !signIn.isLoading
                  ? () =>
                      ref
                          .read(signInControllerProvider.notifier)
                          .signInForDevelopment()
                  : null,
        ),
        if (signIn.hasError) ...[
          const SizedBox(height: SoulSpace.sm),
          _ErrorText(errorMessage(l10n, signIn.error)),
        ],
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

/// Asks what Soul should call the user, right after the first sign-in
/// ([isEditing] false) or from Profile ([isEditing] true). The Google
/// account name may prefill the field as a suggestion; nothing is saved
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
    final me = ref.read(sessionControllerProvider).valueOrNull;
    _controller = TextEditingController(
      text: me?.profile.preferredName ?? me?.googleDisplayName,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final saved = await ref
        .read(preferredNameControllerProvider.notifier)
        .save(_controller.text);
    // After onboarding the router guard moves on to Today by itself.
    if (saved && widget.isEditing && mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final saveState = ref.watch(preferredNameControllerProvider);
    final issue = validatePreferredName(_controller.text);
    final canSave = issue == null && !saveState.isLoading;
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
        if (saveState.hasError) ...[
          const SizedBox(height: SoulSpace.sm),
          _ErrorText(errorMessage(l10n, saveState.error)),
        ],
        const Spacer(),
        const SizedBox(height: SoulSpace.lg),
        SoulButton(
          label:
              saveState.hasError
                  ? l10n.retry
                  : widget.isEditing
                  ? l10n.save
                  : l10n.saveAndContinue,
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

/// Localized error announced to assistive technology when it appears.
class _ErrorText extends StatelessWidget {
  const _ErrorText(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: SoulColors.error),
      ),
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

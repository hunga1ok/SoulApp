import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/design_system/soul_theme.dart';
import '../../l10n/app_localizations.dart';

class LanguageGateScreen extends ConsumerWidget {
  const LanguageGateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(SoulSpace.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/soul_logo.png',
                  width: 138,
                  semanticLabel: 'Soul',
                ),
                const SizedBox(height: 52),
                _LanguageChoice(
                  label: 'VI',
                  onPressed: () async {
                    await ref
                        .read(appStateProvider)
                        .selectLocale(SoulLocale.vi);
                    if (context.mounted) context.go('/auth');
                  },
                ),
                const SizedBox(height: SoulSpace.sm),
                _LanguageChoice(
                  label: 'EN',
                  onPressed: () async {
                    await ref
                        .read(appStateProvider)
                        .selectLocale(SoulLocale.en);
                    if (context.mounted) context.go('/auth');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageChoice extends StatelessWidget {
  const _LanguageChoice({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          foregroundColor: SoulColors.plum,
          side: const BorderSide(color: SoulColors.line),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 2),
        ),
      ),
    );
  }
}

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(SoulSpace.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/soul_logo.png',
                  width: 130,
                  alignment: Alignment.centerLeft,
                  semanticLabel: 'Soul',
                ),
                const SizedBox(height: SoulSpace.xl),
                Text(
                  l10n.appTitle,
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: SoulSpace.sm),
                Text(
                  l10n.authTagline,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 42),
                ElevatedButton.icon(
                  onPressed:
                      kDebugMode
                          ? () async {
                            await ref
                                .read(appStateProvider)
                                .completeDevelopmentSignIn();
                            if (context.mounted) context.go('/onboarding/name');
                          }
                          : null,
                  icon: const Icon(Icons.g_mobiledata, size: 28),
                  label: Text(l10n.continueWithGoogle),
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
            ),
          ),
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(SoulSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                l10n.whatShouldWeCallYou,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: SoulSpace.lg),
              TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.words,
                autofocus: true,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(hintText: l10n.nameHint),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed:
                    _controller.text.trim().isEmpty
                        ? null
                        : () async {
                          await ref
                              .read(appStateProvider)
                              .savePreferredName(_controller.text);
                          if (context.mounted) context.go('/app/today');
                        },
                child: Text(l10n.saveAndContinue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

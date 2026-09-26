import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../soul_theme.dart';
import 'soul_button.dart';

/// Empty state: icon, serif title, message and an optional action.
class SoulEmptyState extends StatelessWidget {
  const SoulEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return _StateLayout(
      children: [
        CircleAvatar(
          radius: 34,
          backgroundColor: SoulColors.lilac,
          foregroundColor: SoulColors.plum,
          child: Icon(icon, size: 32),
        ),
        const SizedBox(height: SoulSpace.lg),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: SoulSpace.sm),
        Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        if (action != null) ...[const SizedBox(height: SoulSpace.lg), action!],
      ],
    );
  }
}

/// Recoverable error with a retry action.
class SoulErrorState extends StatelessWidget {
  const SoulErrorState({super.key, required this.onRetry, this.message});

  final VoidCallback onRetry;

  /// Defaults to a generic localized message.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _StateLayout(
      children: [
        const Icon(Icons.cloud_off_outlined, size: 40, color: SoulColors.error),
        const SizedBox(height: SoulSpace.md),
        Text(
          message ?? l10n.somethingWentWrong,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: SoulSpace.lg),
        SoulButton(
          label: l10n.retry,
          variant: SoulButtonVariant.secondary,
          icon: const Icon(Icons.refresh),
          onPressed: onRetry,
        ),
      ],
    );
  }
}

/// Loading indicator announced with a localized label.
class SoulLoadingState extends StatelessWidget {
  const SoulLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: SoulColors.lilacStrong,
        semanticsLabel: AppLocalizations.of(context)!.loading,
      ),
    );
  }
}

class _StateLayout extends StatelessWidget {
  const _StateLayout({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(SoulSpace.lg),
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}

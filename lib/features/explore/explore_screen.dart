import 'package:flutter/material.dart';

import '../../core/design_system/soul_theme.dart';
import '../../l10n/app_localizations.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(SoulSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.exploreTitle,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          const SizedBox(height: SoulSpace.sm),
          Text(l10n.exploreBody, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: SoulSpace.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(SoulSpace.lg),
            decoration: BoxDecoration(
              color: SoulColors.lilac,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.explore_outlined,
              size: 44,
              color: SoulColors.plum,
            ),
          ),
        ],
      ),
    );
  }
}

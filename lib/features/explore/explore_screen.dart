import 'package:flutter/material.dart';

import '../../core/design_system/design_system.dart';
import '../../l10n/app_localizations.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(SoulSpace.lg),
      children: [
        Text(
          l10n.exploreTitle,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        const SizedBox(height: SoulSpace.sm),
        Text(l10n.exploreBody, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: SoulSpace.lg),
        const SoulCard(
          color: SoulColors.lilac,
          padding: EdgeInsets.all(SoulSpace.lg),
          child: ExcludeSemantics(
            child: Icon(
              Icons.explore_outlined,
              size: 44,
              color: SoulColors.plum,
            ),
          ),
        ),
      ],
    );
  }
}

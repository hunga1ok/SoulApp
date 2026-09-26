import 'package:flutter/material.dart';

import '../../core/design_system/soul_theme.dart';
import '../../l10n/app_localizations.dart';

class VisionScreen extends StatelessWidget {
  const VisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(SoulSpace.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 34,
              backgroundColor: SoulColors.lilac,
              foregroundColor: SoulColors.plum,
              child: Icon(Icons.auto_awesome_outlined, size: 32),
            ),
            const SizedBox(height: SoulSpace.lg),
            Text(
              l10n.visionEmptyTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SoulSpace.sm),
            Text(
              l10n.visionEmptyBody,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SoulSpace.lg),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(l10n.createVision),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

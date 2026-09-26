import 'package:flutter/material.dart';

import '../../core/design_system/design_system.dart';
import '../../l10n/app_localizations.dart';

class VisionScreen extends StatelessWidget {
  const VisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SoulEmptyState(
      icon: Icons.auto_awesome_outlined,
      title: l10n.visionEmptyTitle,
      message: l10n.visionEmptyBody,
      action: SoulButton(label: l10n.createVision, onPressed: () {}),
    );
  }
}

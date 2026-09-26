import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../soul_theme.dart';

/// Sound row (`.playlist-item`): icon tile, title, subtitle and a
/// play/pause control with a localized label.
class SoulAudioRow extends StatelessWidget {
  const SoulAudioRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onPlayPause,
    this.isPlaying = false,
    this.icon = Icons.graphic_eq,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onPlayPause;
  final bool isPlaying;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.fromLTRB(
        SoulSpace.sm,
        SoulSpace.xs,
        SoulSpace.xxs,
        SoulSpace.xs,
      ),
      decoration: BoxDecoration(
        color: SoulColors.surface,
        borderRadius: BorderRadius.circular(SoulRadius.row),
        border: Border.all(color: SoulColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: SoulSizes.iconTile,
            height: SoulSizes.iconTile,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SoulRadius.iconTile),
              gradient: const LinearGradient(
                colors: [SoulColors.iconTileStart, SoulColors.iconTileEnd],
              ),
            ),
            child: Icon(icon, size: 18, color: SoulColors.plum),
          ),
          const SizedBox(width: SoulSpace.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(subtitle, style: textTheme.bodyMedium),
              ],
            ),
          ),
          IconButton(
            onPressed: onPlayPause,
            tooltip: isPlaying ? l10n.pause : l10n.play,
            color: SoulColors.softInk,
            icon: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../soul_theme.dart';

/// Rounded paper card (`.card`). When [onTap] is set, the whole card is the
/// touch target.
class SoulCard extends StatelessWidget {
  const SoulCard({
    super.key,
    required this.child,
    this.onTap,
    this.color = SoulColors.surface,
    this.padding = const EdgeInsets.all(SoulSpace.md),
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color color;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(SoulRadius.card);
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: SoulShadows.card,
      ),
      child: Material(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: const BorderSide(color: Colors.white),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

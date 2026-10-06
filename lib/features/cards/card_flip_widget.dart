import 'dart:math';
import 'package:flutter/material.dart';

import '../../core/design_system/design_system.dart';

/// Interactive 3D flip card widget using Matrix4 perspective transform.
class CardFlipWidget extends StatelessWidget {
  const CardFlipWidget({
    super.key,
    required this.isFlipped,
    required this.front,
    required this.back,
    this.duration = const Duration(milliseconds: 700),
    this.curve = Curves.easeInOutCubic,
  });

  final bool isFlipped;
  final Widget front;
  final Widget back;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: isFlipped ? 1 : 0),
      duration: duration,
      curve: curve,
      builder: (context, value, child) {
        final angle = value * pi;
        final isFrontSide = angle >= (pi / 2);

        return Transform(
          alignment: Alignment.center,
          transform:
              Matrix4.identity()
                ..setEntry(3, 2, 0.0012)
                ..rotateY(angle),
          child:
              isFrontSide
                  ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: front,
                  )
                  : back,
        );
      },
    );
  }
}

/// Artistic back of card widget aligned with SoulApp design language.
class SoulCardBack extends StatelessWidget {
  const SoulCardBack({
    super.key,
    required this.deckTitle,
    this.color = SoulColors.plum,
    this.accentColor = SoulColors.rose,
  });

  final String deckTitle;
  final Color color;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(SoulRadius.card),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, color.withValues(alpha: 0.85)],
          ),
          border: Border.all(
            color: accentColor.withValues(alpha: 0.4),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(SoulSpace.md),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SoulRadius.button),
            border: Border.all(
              color: accentColor.withValues(alpha: 0.25),
              width: 1,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome,
                  size: 44,
                  color: accentColor.withValues(alpha: 0.9),
                ),
                const SizedBox(height: SoulSpace.sm),
                Text(
                  'SOUL',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: SoulColors.surface,
                    letterSpacing: 4.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: SoulSpace.xxs),
                Text(
                  deckTitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: SoulColors.surface.withValues(alpha: 0.75),
                    letterSpacing: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

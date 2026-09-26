import 'package:flutter/material.dart';

import '../soul_theme.dart';

/// Rounded linear progress with the prototype peach-to-rose gradient.
class SoulProgressBar extends StatelessWidget {
  const SoulProgressBar({
    super.key,
    required this.value,
    required this.semanticsLabel,
    this.trackColor = Colors.white,
  });

  /// Progress from 0 to 1.
  final double value;
  final String semanticsLabel;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    final radius = BorderRadius.circular(SoulSizes.progressHeight);
    return Semantics(
      label: semanticsLabel,
      value: '${(clamped * 100).round()}%',
      child: ClipRRect(
        borderRadius: radius,
        child: Container(
          height: SoulSizes.progressHeight,
          color: trackColor,
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: clamped,
            heightFactor: 1,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: const LinearGradient(
                  colors: [SoulColors.progressStart, SoulColors.progressEnd],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

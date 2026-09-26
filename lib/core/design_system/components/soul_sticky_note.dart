import 'package:flutter/material.dart';

import '../soul_theme.dart';

/// Journal sticky note: warm-white paper with horizontal ruled lines only
/// (no vertical margin line, no yellow), a tape strip and a soft shadow.
/// The whole card is tappable when [onTap] is set.
class SoulStickyNote extends StatelessWidget {
  const SoulStickyNote({
    super.key,
    required this.eyebrow,
    required this.body,
    this.onTap,
    this.maxLines = 2,
  });

  final String eyebrow;
  final String body;
  final VoidCallback? onTap;
  final int? maxLines;

  static const _ruleSpacing = 28.0;
  static const _minHeight = 102.0;
  static const _tapeWidth = 58.0;
  static const _tapeHeight = 18.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: onTap != null,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            constraints: const BoxConstraints(minHeight: _minHeight),
            decoration: const BoxDecoration(
              borderRadius: SoulRadius.stickyNote,
              boxShadow: SoulShadows.stickyNote,
            ),
            child: Material(
              color: SoulColors.notePaper,
              shape: const RoundedRectangleBorder(
                borderRadius: SoulRadius.stickyNote,
                side: BorderSide(color: SoulColors.noteBorder),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                child: CustomPaint(
                  painter: const _HorizontalRulePainter(spacing: _ruleSpacing),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      SoulSpace.md,
                      SoulSpace.md,
                      SoulSpace.xl + SoulSpace.xs,
                      SoulSpace.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eyebrow,
                          style: const TextStyle(
                            color: SoulColors.noteDate,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.9,
                          ),
                        ),
                        const SizedBox(height: SoulSpace.xs),
                        Text(
                          body,
                          maxLines: maxLines,
                          overflow:
                              maxLines == null ? null : TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: SoulColors.noteInk,
                            fontSize: 16,
                            height: 1.38,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            top: -5,
            left: 0,
            right: 0,
            child: Center(
              child: ExcludeSemantics(
                child: SizedBox(
                  width: _tapeWidth,
                  height: _tapeHeight,
                  child: ColoredBox(color: SoulColors.noteTape),
                ),
              ),
            ),
          ),
          if (onTap != null)
            const Positioned(
              right: SoulSpace.md,
              bottom: SoulSpace.md,
              child: ExcludeSemantics(
                child: Icon(
                  Icons.north_east,
                  size: 18,
                  color: SoulColors.noteDate,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HorizontalRulePainter extends CustomPainter {
  const _HorizontalRulePainter({required this.spacing});

  final double spacing;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = SoulColors.noteRule
          ..strokeWidth = 1;
    for (var y = spacing; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HorizontalRulePainter oldDelegate) =>
      oldDelegate.spacing != spacing;
}

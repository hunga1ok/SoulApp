import 'package:flutter/material.dart';

import '../../core/design_system/soul_theme.dart';
import '../../l10n/app_localizations.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        SoulSpace.lg,
        SoulSpace.md,
        SoulSpace.lg,
        SoulSpace.xl,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.recent, style: Theme.of(context).textTheme.headlineSmall),
            Text(l10n.oneNote, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: SoulSpace.md),
        const _LinedNote(),
      ],
    );
  }
}

class _LinedNote extends StatelessWidget {
  const _LinedNote();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Semantics(
      button: true,
      label: l10n.gratitudeNote,
      child: InkWell(
        onTap:
            () => showModalBottomSheet<void>(
              context: context,
              backgroundColor: Colors.transparent,
              builder:
                  (context) => _NoteSheet(
                    title: l10n.gratitudeToday,
                    body: l10n.gratitudeNote,
                  ),
            ),
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          height: 142,
          decoration: BoxDecoration(
            color: SoulColors.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Color(0x11000000),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: CustomPaint(
            painter: _RulePainter(),
            child: Padding(
              padding: const EdgeInsets.all(SoulSpace.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.gratitudeToday,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: SoulColors.lilacStrong,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: SoulSpace.xs),
                  Text(
                    l10n.gratitudeNote,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Spacer(),
                  const Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      Icons.north_east,
                      color: SoulColors.lilacStrong,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RulePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = SoulColors.line
          ..strokeWidth = 1;
    for (var y = 55.0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RulePainter oldDelegate) => false;
}

class _NoteSheet extends StatelessWidget {
  const _NoteSheet({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(SoulSpace.md),
      padding: const EdgeInsets.all(SoulSpace.lg),
      decoration: BoxDecoration(
        color: SoulColors.surface,
        borderRadius: BorderRadius.circular(28),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: SoulSpace.sm),
            Text(body, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}

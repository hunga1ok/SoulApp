import 'package:flutter/material.dart';

import '../soul_theme.dart';

enum SoulButtonVariant { primary, secondary }

/// Full-width call to action. Primary uses the prototype `.cta` gradient;
/// secondary uses the `.cta.soft` fill.
class SoulButton extends StatelessWidget {
  const SoulButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = SoulButtonVariant.primary,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final SoulButtonVariant variant;
  final Widget? icon;

  bool get _isPrimary => variant == SoulButtonVariant.primary;

  @override
  Widget build(BuildContext context) {
    final foreground = _isPrimary ? Colors.white : SoulColors.softInk;
    final style = FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(SoulSizes.buttonHeight),
      padding: const EdgeInsets.symmetric(
        horizontal: SoulSpace.md,
        vertical: SoulSpace.sm,
      ),
      backgroundColor: Colors.transparent,
      disabledBackgroundColor: Colors.transparent,
      foregroundColor: foreground,
      disabledForegroundColor: foreground.withValues(alpha: 0.72),
      textStyle: Theme.of(context).textTheme.labelLarge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SoulRadius.button),
      ),
      backgroundBuilder: (context, states, child) {
        final disabled = states.contains(WidgetState.disabled);
        return Opacity(
          opacity: disabled ? 0.5 : 1,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SoulRadius.button),
              color: _isPrimary ? null : SoulColors.softFill,
              gradient:
                  _isPrimary
                      ? const LinearGradient(
                        colors: [SoulColors.ctaStart, SoulColors.ctaEnd],
                      )
                      : null,
              boxShadow: _isPrimary && !disabled ? SoulShadows.button : null,
            ),
            child: child,
          ),
        );
      },
    );
    final text = Text(label, textAlign: TextAlign.center);
    return icon == null
        ? FilledButton(onPressed: onPressed, style: style, child: text)
        : FilledButton.icon(
          onPressed: onPressed,
          style: style,
          icon: icon,
          label: text,
        );
  }
}

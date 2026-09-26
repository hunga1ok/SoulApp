import 'package:flutter/material.dart';

import '../soul_theme.dart';

/// Selectable pill for moods and feelings. Selection shows a check mark, a
/// stronger border and fill, so it never relies on color alone.
class SoulChip extends StatelessWidget {
  const SoulChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      showCheckmark: true,
      checkmarkColor: SoulColors.selectedInk,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: Colors.white,
      selectedColor: SoulColors.selectedFill,
      labelStyle: TextStyle(
        color: selected ? SoulColors.selectedInk : SoulColors.plum,
        fontSize: 14,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: SoulSpace.xs,
        vertical: SoulSpace.xxs,
      ),
      shape: const StadiumBorder(),
      side: BorderSide(
        color: selected ? SoulColors.selectedBorder : SoulColors.inputBorder,
      ),
    );
  }
}

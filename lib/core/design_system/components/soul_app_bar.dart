import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../soul_theme.dart';

/// App bar. Without [title] it shows the left-aligned Soul logo; with
/// [onBack] it shows a localized back button.
class SoulAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SoulAppBar({super.key, this.title, this.onBack, this.actions});

  final String? title;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  static const _height = 68.0;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppBar(
      toolbarHeight: _height,
      automaticallyImplyLeading: false,
      titleSpacing: onBack == null ? SoulSpace.md : 0,
      leading:
          onBack == null
              ? null
              : IconButton(
                onPressed: onBack,
                tooltip: l10n.back,
                icon: const Icon(Icons.arrow_back),
              ),
      title:
          title == null
              ? Image.asset(
                'assets/images/soul_logo.png',
                width: 86,
                alignment: Alignment.centerLeft,
                semanticLabel: l10n.appTitle,
                errorBuilder:
                    (context, error, stackTrace) => Text(l10n.appTitle),
              )
              : Text(
                title!,
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
      actions: [...?actions, const SizedBox(width: SoulSpace.xs)],
    );
  }
}

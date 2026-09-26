import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/design_system/soul_theme.dart';
import '../../l10n/app_localizations.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(appStateProvider);
    final labels = [l10n.today, l10n.vision, l10n.journal, l10n.explore];
    const icons = [
      Icons.wb_sunny_outlined,
      Icons.auto_awesome_outlined,
      Icons.menu_book_outlined,
      Icons.explore_outlined,
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        titleSpacing: SoulSpace.md,
        title: Image.asset(
          'assets/images/soul_logo.png',
          width: 86,
          alignment: Alignment.centerLeft,
          semanticLabel: 'Soul',
        ),
        actions: [
          Semantics(
            button: true,
            label: state.soundEnabled ? l10n.soundOn : l10n.soundOff,
            child: IconButton(
              tooltip: state.soundEnabled ? l10n.soundOn : l10n.soundOff,
              onPressed: () => ref.read(appStateProvider).toggleSound(),
              icon: Icon(
                state.soundEnabled
                    ? Icons.volume_up_outlined
                    : Icons.volume_off_outlined,
              ),
            ),
          ),
          Semantics(
            button: true,
            label: l10n.profile,
            child: IconButton(
              tooltip: l10n.profile,
              onPressed: () => context.push('/profile'),
              icon: CircleAvatar(
                radius: 16,
                backgroundColor: SoulColors.lilac,
                foregroundColor: SoulColors.plum,
                child: Text(
                  (state.preferredName ?? 'S').characters.first.toUpperCase(),
                ),
              ),
            ),
          ),
          const SizedBox(width: SoulSpace.xs),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        height: 76,
        backgroundColor: SoulColors.surface,
        indicatorColor: SoulColors.rose,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected:
            (index) => navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            ),
        destinations: [
          for (var index = 0; index < labels.length; index++)
            NavigationDestination(
              icon: Icon(icons[index]),
              selectedIcon: Icon(icons[index]),
              label: labels[index],
            ),
        ],
      ),
    );
  }
}

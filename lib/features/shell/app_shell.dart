import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/design_system/design_system.dart';
import '../../core/errors/api_exception.dart';
import '../../core/errors/error_messages.dart';
import '../../l10n/app_localizations.dart';
import '../auth/session_controller.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _maxNavigationTextScale = 1.3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(sessionControllerProvider).valueOrNull?.profile;
    final soundEnabled = profile?.audioEnabled ?? true;
    final labels = [l10n.today, l10n.vision, l10n.journal, l10n.explore];
    const icons = [
      Icons.wb_sunny_outlined,
      Icons.auto_awesome_outlined,
      Icons.menu_book_outlined,
      Icons.explore_outlined,
    ];
    // Filled icons mark the selected tab without relying on color alone.
    const selectedIcons = [
      Icons.wb_sunny,
      Icons.auto_awesome,
      Icons.menu_book,
      Icons.explore,
    ];

    return Scaffold(
      appBar: SoulAppBar(
        actions: [
          IconButton(
            tooltip: soundEnabled ? l10n.soundOn : l10n.soundOff,
            onPressed: () => toggleSound(context, ref, !soundEnabled),
            isSelected: soundEnabled,
            icon: Icon(
              soundEnabled
                  ? Icons.volume_up_outlined
                  : Icons.volume_off_outlined,
            ),
          ),
          IconButton(
            tooltip: l10n.profile,
            onPressed: () => context.push('/profile'),
            icon: ExcludeSemantics(
              child: CircleAvatar(
                radius: 16,
                backgroundColor: SoulColors.lilac,
                foregroundColor: SoulColors.plum,
                child: Text(
                  (profile?.preferredName ?? 'S').characters.first
                      .toUpperCase(),
                ),
              ),
            ),
          ),
        ],
      ),
      body: navigationShell,
      // Tab labels cap at 130% text scale, like platform tab bars, so the
      // fixed-height bar never clips them; screen content scales to 200%.
      bottomNavigationBar: MediaQuery.withClampedTextScaling(
        maxScaleFactor: _maxNavigationTextScale,
        child: NavigationBar(
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
                selectedIcon: Icon(selectedIcons[index]),
                label: labels[index],
              ),
          ],
        ),
      ),
    );
  }
}

/// Optimistically switches the global sound setting; a failed save is
/// reverted by the controller and reported here.
Future<void> toggleSound(
  BuildContext context,
  WidgetRef ref,
  bool enabled,
) async {
  try {
    await ref
        .read(sessionControllerProvider.notifier)
        .updateAudioEnabled(enabled);
  } on ApiException catch (error) {
    if (context.mounted) showErrorSnackBar(context, error);
  }
}

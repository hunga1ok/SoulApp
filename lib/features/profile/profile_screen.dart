import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/design_system/soul_theme.dart';
import '../../l10n/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(appStateProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
          tooltip: l10n.back,
        ),
        title: Text(l10n.profile),
      ),
      body: ListView(
        padding: const EdgeInsets.all(SoulSpace.lg),
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: SoulColors.lilac,
            foregroundColor: SoulColors.plum,
            child: Text(
              (state.preferredName ?? 'S').characters.first.toUpperCase(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: SoulSpace.sm),
          Text(
            state.preferredName ?? '',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SoulSpace.lg),
          _SettingRow(
            icon:
                state.soundEnabled
                    ? Icons.volume_up_outlined
                    : Icons.volume_off_outlined,
            label: state.soundEnabled ? l10n.soundOn : l10n.soundOff,
            onTap: () => ref.read(appStateProvider).toggleSound(),
          ),
          _SettingRow(
            icon: Icons.language_outlined,
            label: l10n.language,
            onTap: () => _showLanguagePicker(context, ref),
          ),
          _SettingRow(
            icon: Icons.logout_outlined,
            label: l10n.signOut,
            onTap: () async {
              await ref.read(appStateProvider).signOut();
              if (context.mounted) context.go('/auth');
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showLanguagePicker(BuildContext context, WidgetRef ref) async {
    await showModalBottomSheet<void>(
      context: context,
      builder:
          (sheetContext) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(AppLocalizations.of(context)!.vietnameseLanguage),
                  onTap: () async {
                    await ref
                        .read(appStateProvider)
                        .selectLocale(SoulLocale.vi);
                    if (sheetContext.mounted) Navigator.pop(sheetContext);
                  },
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.englishLanguage),
                  onTap: () async {
                    await ref
                        .read(appStateProvider)
                        .selectLocale(SoulLocale.en);
                    if (sheetContext.mounted) Navigator.pop(sheetContext);
                  },
                ),
              ],
            ),
          ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: SoulSpace.sm,
      leading: Icon(icon, color: SoulColors.plum),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

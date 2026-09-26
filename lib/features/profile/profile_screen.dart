import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/design_system/design_system.dart';
import '../../l10n/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(appStateProvider);
    final preferredName = state.preferredName;
    final soundEnabled = state.soundEnabled;
    return Scaffold(
      appBar: SoulAppBar(title: l10n.profile, onBack: () => context.pop()),
      body: ListView(
        padding: const EdgeInsets.all(SoulSpace.lg),
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: SoulColors.lilac,
            foregroundColor: SoulColors.plum,
            child: Text(
              (preferredName ?? 'S').characters.first.toUpperCase(),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: SoulSpace.sm),
          Text(
            preferredName ?? '',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SoulSpace.lg),
          _SettingRow(
            icon: Icons.edit_outlined,
            label: l10n.editName,
            onTap: () => context.push('/profile/name'),
          ),
          _SettingRow(
            icon:
                soundEnabled
                    ? Icons.volume_up_outlined
                    : Icons.volume_off_outlined,
            label: soundEnabled ? l10n.soundOn : l10n.soundOff,
            onTap: () => state.setSoundEnabled(!soundEnabled),
          ),
          _SettingRow(
            icon: Icons.language_outlined,
            label: l10n.language,
            onTap: () => _showLanguagePicker(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _showLanguagePicker(BuildContext context, WidgetRef ref) async {
    await showSoulBottomSheet<void>(
      context: context,
      builder:
          (sheetContext) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(AppLocalizations.of(context)!.vietnameseLanguage),
                onTap: () {
                  Navigator.pop(sheetContext);
                  ref.read(appStateProvider).selectLocale(SoulLocale.vi);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.englishLanguage),
                onTap: () {
                  Navigator.pop(sheetContext);
                  ref.read(appStateProvider).selectLocale(SoulLocale.en);
                },
              ),
            ],
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

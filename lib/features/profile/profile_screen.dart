import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/design_system/design_system.dart';
import '../../core/errors/api_exception.dart';
import '../../core/errors/error_messages.dart';
import '../../l10n/app_localizations.dart';
import '../auth/session_controller.dart';
import '../shell/app_shell.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(sessionControllerProvider).valueOrNull?.profile;
    final preferredName = profile?.preferredName;
    final soundEnabled = profile?.audioEnabled ?? true;
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
            onTap: () => toggleSound(context, ref, !soundEnabled),
          ),
          _SettingRow(
            icon: Icons.language_outlined,
            label: l10n.language,
            onTap: () => _showLanguagePicker(context, ref),
          ),
          _SettingRow(
            icon: Icons.logout_outlined,
            label: l10n.signOut,
            // The router guard returns to sign-in once the session ends.
            onTap: () => ref.read(sessionControllerProvider.notifier).signOut(),
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
                  _updateLocale(context, ref, SoulLocale.vi);
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.englishLanguage),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _updateLocale(context, ref, SoulLocale.en);
                },
              ),
            ],
          ),
    );
  }
}

/// Optimistic locale change; a failed save is reverted by the controller and
/// reported here.
Future<void> _updateLocale(
  BuildContext context,
  WidgetRef ref,
  SoulLocale locale,
) async {
  try {
    await ref.read(sessionControllerProvider.notifier).updateLocale(locale);
  } on ApiException catch (error) {
    if (context.mounted) showErrorSnackBar(context, error);
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

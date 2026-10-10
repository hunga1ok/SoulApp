import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_state.dart';
import '../../core/audio/audio_playback_controller.dart';
import '../../core/design_system/design_system.dart';
import '../../core/platform/device_services.dart';
import '../../data/repositories/reminder_repository.dart';
import '../../l10n/app_localizations.dart';
import '../onboarding/onboarding_screens.dart';
import 'home_widget_screen.dart';
import 'reminder_settings_screen.dart';

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
            onTap: () async {
              final newSound = !soundEnabled;
              await state.setSoundEnabled(newSound);
              if (!newSound) {
                await ref.read(audioPlaybackProvider).stop();
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: SoulSpace.sm),
            child: Row(
              children: [
                const Icon(Icons.language_rounded, color: SoulColors.plum),
                const SizedBox(width: SoulSpace.md),
                Expanded(
                  child: Text(
                    l10n.language,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(width: SoulSpace.sm),
                Flexible(
                  child: Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<SoulLocale>(
                          value: state.locale ?? SoulLocale.vi,
                          isDense: true,
                          alignment: AlignmentDirectional.centerEnd,
                          borderRadius: BorderRadius.circular(
                            SoulRadius.button,
                          ),
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color: SoulColors.plum,
                            fontWeight: FontWeight.w600,
                          ),
                          icon: const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: SoulColors.plum,
                              size: 20,
                            ),
                          ),
                          items: [
                            for (final itemLocale in SoulLocale.values)
                              DropdownMenuItem(
                                value: itemLocale,
                                child: Text(switch (itemLocale) {
                                  SoulLocale.vi => l10n.vietnameseLanguage,
                                  SoulLocale.en => l10n.englishLanguage,
                                  _ => itemLocale.endonym,
                                }),
                              ),
                          ],
                          onChanged: (locale) async {
                            if (locale == null) return;
                            await ref.read(audioPlaybackProvider).stop();
                            await ref
                                .read(appStateProvider)
                                .selectLocale(locale);
                            final choices =
                                await ref
                                    .read(reminderRepositoryProvider)
                                    .load();
                            await ref
                                .read(notificationPermissionsProvider)
                                .scheduleDailyReminders(
                                  choices: choices,
                                  locale: locale,
                                  preferredName:
                                      ref.read(appStateProvider).preferredName,
                                );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _SettingRow(
            icon: Icons.widgets_outlined,
            label: l10n.homeWidgetTitle,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeWidgetScreen()),
                ),
          ),
          _SettingRow(
            icon: Icons.notifications_none_rounded,
            label: l10n.reminderSettingsTitle,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ReminderSettingsScreen(),
                  ),
                ),
          ),
          _SettingRow(
            icon: Icons.auto_awesome_outlined,
            label: l10n.revisitOnboarding,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => const WelcomeIntroScreen(isRevisiting: true),
                  ),
                ),
          ),
          _SettingRow(
            icon: Icons.logout_rounded,
            label: l10n.signOut,
            onTap: () => _confirmSignOut(context, ref, l10n),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmSignOut(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final confirmed = await showSoulConfirmDialog(
      context: context,
      title: l10n.signOutConfirmTitle,
      message: l10n.signOutConfirmBody,
      confirmLabel: l10n.signOut,
    );
    if (!confirmed) return;
    await ref.read(audioPlaybackProvider).stop();
    await ref.read(appStateProvider).resetAll();
    if (context.mounted) {
      context.go('/language');
    }
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

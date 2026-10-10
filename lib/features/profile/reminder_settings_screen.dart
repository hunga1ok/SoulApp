import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_state.dart';
import '../../core/design_system/design_system.dart';
import '../../core/platform/device_services.dart';
import '../../data/repositories/reminder_repository.dart';
import '../../l10n/app_localizations.dart';

class ReminderSettingsScreen extends ConsumerStatefulWidget {
  const ReminderSettingsScreen({super.key});

  @override
  ConsumerState<ReminderSettingsScreen> createState() =>
      _ReminderSettingsScreenState();
}

class _ReminderSettingsScreenState
    extends ConsumerState<ReminderSettingsScreen> {
  Map<ReminderKind, ReminderChoice> _choices = defaultReminders;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentReminders();
  }

  Future<void> _loadCurrentReminders() async {
    final loaded = await ref.read(reminderRepositoryProvider).load();
    if (mounted) {
      setState(() {
        _choices = loaded;
        _isLoading = false;
      });
    }
  }

  Future<void> _save() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final timezone = await ref.read(deviceTimezoneProvider).current();
      await ref
          .read(reminderRepositoryProvider)
          .save(_choices, timezone: timezone);

      final appState = ref.read(appStateProvider);
      final permissions = ref.read(notificationPermissionsProvider);
      if (_choices.values.any((c) => c.enabled)) {
        await permissions.request();
      }
      await permissions.scheduleDailyReminders(
        choices: _choices,
        locale: appState.locale ?? SoulLocale.en,
        preferredName: appState.preferredName,
      );

      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.settingsSaved)));
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isSaving = false);
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.somethingWentWrong)));
      }
    }
  }

  Future<void> _sendSampleNotification(
    AppLocalizations l10n,
    String displayName,
  ) async {
    final locale = ref.read(appStateProvider).locale ?? SoulLocale.en;
    await ref
        .read(notificationPermissionsProvider)
        .showSampleNotification(
          title: l10n.notificationMorningTitle(displayName),
          body: l10n.notificationMorningBody,
          locale: locale,
        );
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.notificationTestSent)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final preferredName = ref.watch(appStateProvider).preferredName;
    final displayName =
        (preferredName != null && preferredName.trim().isNotEmpty)
            ? preferredName.trim()
            : 'Soul';
    final labels = {
      ReminderKind.morning: l10n.reminderMorning,
      ReminderKind.evening: l10n.reminderEvening,
    };
    final morningTime = MaterialLocalizations.of(context).formatTimeOfDay(
      _choices[ReminderKind.morning]!.time,
      alwaysUse24HourFormat: true,
    );
    final eveningTime = MaterialLocalizations.of(context).formatTimeOfDay(
      _choices[ReminderKind.evening]!.time,
      alwaysUse24HourFormat: true,
    );

    return Scaffold(
      backgroundColor: SoulColors.paper,
      appBar: SoulAppBar(
        title: l10n.reminderSettingsTitle,
        onBack: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                  padding: const EdgeInsets.all(SoulSpace.lg),
                  children: [
                    Text(
                      l10n.reminderSettingsSubtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: SoulColors.muted,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: SoulSpace.lg),
                    for (final MapEntry(key: kind, value: label)
                        in labels.entries) ...[
                      _ReminderSettingCard(
                        label: label,
                        choice: _choices[kind]!,
                        onEnabled: (val) {
                          setState(() {
                            _choices = {
                              ..._choices,
                              kind: _choices[kind]!.copyWith(enabled: val),
                            };
                          });
                        },
                        onTime: (time) {
                          setState(() {
                            _choices = {
                              ..._choices,
                              kind: _choices[kind]!.copyWith(time: time),
                            };
                          });
                        },
                      ),
                      const SizedBox(height: SoulSpace.sm),
                    ],
                    const SizedBox(height: SoulSpace.md),
                    SoulButton(
                      label: l10n.saveSettings,
                      onPressed: _isSaving ? null : _save,
                    ),
                    const SizedBox(height: SoulSpace.xl),
                    Text(
                      l10n.notificationPreviewSectionTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: SoulColors.plum,
                      ),
                    ),
                    const SizedBox(height: SoulSpace.xs),
                    _NotificationPreviewCard(
                      timeLabel: morningTime,
                      icon: Icons.wb_sunny_outlined,
                      title: l10n.notificationMorningTitle(displayName),
                      body: l10n.notificationMorningBody,
                    ),
                    const SizedBox(height: SoulSpace.xs),
                    _NotificationPreviewCard(
                      timeLabel: eveningTime,
                      icon: Icons.nightlight_round,
                      title: l10n.notificationEveningTitle(displayName),
                      body: l10n.notificationEveningBody,
                    ),
                    const SizedBox(height: SoulSpace.xs),
                    Container(
                      padding: const EdgeInsets.all(SoulSpace.sm),
                      decoration: BoxDecoration(
                        color: SoulColors.lilac.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(SoulRadius.card),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.lock_outline_rounded,
                            size: 18,
                            color: SoulColors.plum,
                          ),
                          const SizedBox(width: SoulSpace.xs),
                          Expanded(
                            child: Text(
                              l10n.notificationPrivacyNote,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: SoulColors.softInk),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: SoulSpace.md),
                    SoulButton(
                      label: l10n.notificationSendTest,
                      variant: SoulButtonVariant.secondary,
                      onPressed:
                          () => _sendSampleNotification(l10n, displayName),
                    ),
                  ],
                ),
      ),
    );
  }
}

class _NotificationPreviewCard extends StatelessWidget {
  const _NotificationPreviewCard({
    required this.timeLabel,
    required this.icon,
    required this.title,
    required this.body,
  });

  final String timeLabel;
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SoulSpace.md),
      decoration: BoxDecoration(
        color: SoulColors.surface,
        borderRadius: BorderRadius.circular(SoulRadius.card),
        border: Border.all(color: SoulColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: SoulColors.plum),
              const SizedBox(width: 6),
              Text(
                'SOUL',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: SoulColors.plum,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
              const Spacer(),
              Text(
                timeLabel,
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: SoulColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: SoulColors.softInk,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReminderSettingCard extends StatelessWidget {
  const _ReminderSettingCard({
    required this.label,
    required this.choice,
    required this.onEnabled,
    required this.onTime,
  });

  final String label;
  final ReminderChoice choice;
  final ValueChanged<bool> onEnabled;
  final ValueChanged<TimeOfDay> onTime;

  @override
  Widget build(BuildContext context) {
    final timeStr = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(choice.time, alwaysUse24HourFormat: true);

    return SoulCard(
      padding: const EdgeInsets.symmetric(
        horizontal: SoulSpace.md,
        vertical: SoulSpace.xs,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  choice.enabled
                      ? timeStr
                      : AppLocalizations.of(context)!.skipForNow,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                        choice.enabled ? SoulColors.softInk : SoulColors.muted,
                  ),
                ),
              ],
            ),
          ),
          if (choice.enabled) ...[
            TextButton(
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: choice.time,
                );
                if (picked != null) onTime(picked);
              },
              child: Text(
                timeStr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: SoulColors.plum,
                  fontSize: 16,
                ),
              ),
            ),
          ],
          Switch(
            value: choice.enabled,
            activeTrackColor: SoulColors.lilac,
            activeThumbColor: SoulColors.plum,
            onChanged: onEnabled,
          ),
        ],
      ),
    );
  }
}

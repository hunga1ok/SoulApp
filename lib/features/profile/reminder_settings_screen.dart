import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

      if (_choices.values.any((c) => c.enabled)) {
        await ref.read(notificationPermissionsProvider).request();
      }

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = {
      ReminderKind.morning: l10n.reminderMorning,
      ReminderKind.evening: l10n.reminderEvening,
    };

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
                    const SizedBox(height: SoulSpace.xl),
                    SoulButton(
                      label: l10n.saveSettings,
                      onPressed: _isSaving ? null : _save,
                    ),
                  ],
                ),
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

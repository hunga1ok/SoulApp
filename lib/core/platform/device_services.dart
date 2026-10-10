import 'dart:ui' show Locale;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

import '../../data/repositories/reminder_repository.dart';
import '../../l10n/app_localizations.dart';
import '../localization/soul_locale.dart';

final deviceTimezoneProvider = Provider<DeviceTimezone>(
  (ref) => const DeviceTimezone(),
);

final notificationPermissionsProvider = Provider<NotificationPermissions>(
  (ref) => NotificationPermissions(FlutterLocalNotificationsPlugin()),
);

/// The device's IANA timezone, e.g. `Asia/Ho_Chi_Minh`.
class DeviceTimezone {
  const DeviceTimezone();

  Future<String> current() async {
    try {
      return (await FlutterTimezone.getLocalTimezone()).identifier;
    } on Exception {
      return 'UTC';
    }
  }
}

/// Asks the OS for permission to show local reminders and schedules localized
/// notifications matching the user's selected [SoulLocale].
class NotificationPermissions {
  NotificationPermissions(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static (String name, String description) _channelForLocale(
    SoulLocale locale,
  ) => switch (locale) {
    SoulLocale.vi => (
      'Nhắc nhở thực hành Soul',
      'Lời nhắc buổi sáng và buổi tối dịu dàng từ Soul',
    ),
    SoulLocale.en => (
      'Soul Daily Reminders',
      'Gentle morning and evening reminders from Soul',
    ),
    SoulLocale.ko => ('Soul 일일 알림', 'Soul이 전하는 아침과 저녁의 다정한 알림'),
    SoulLocale.ja => ('Soul デイリーリマインダー', 'Soulからの朝と夜の優しいリマインダー'),
    SoulLocale.fr => (
      'Rappels quotidiens Soul',
      'Rappels doux du matin et du soir par Soul',
    ),
    SoulLocale.zh => ('Soul 每日提醒', '来自 Soul 的清晨与夜晚温柔提醒'),
  };

  /// Returns whether reminders may be shown. A denial is not an error.
  Future<bool> request() async {
    try {
      // Initializing must not prompt; the prompt belongs to [request].
      const darwin = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: darwin,
          macOS: darwin,
        ),
      );
      final granted = switch (defaultTargetPlatform) {
        TargetPlatform.android =>
          await _plugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.requestNotificationsPermission(),
        TargetPlatform.iOS => await _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >()
            ?.requestPermissions(alert: true, badge: true, sound: true),
        _ => false,
      };
      return granted ?? false;
    } on Exception {
      return false;
    }
  }

  /// Sends an immediate sample notification using Soul's localized reminder channel.
  Future<bool> showSampleNotification({
    required String title,
    required String body,
    SoulLocale locale = SoulLocale.vi,
  }) async {
    try {
      await request();
      final (channelName, channelDesc) = _channelForLocale(locale);
      final androidDetails = AndroidNotificationDetails(
        'soul_daily_reminders',
        channelName,
        channelDescription: channelDesc,
        importance: Importance.high,
        priority: Priority.high,
        visibility: NotificationVisibility.public,
      );
      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      await _plugin.show(
        id: 1001,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(
          android: androidDetails,
          iOS: darwinDetails,
          macOS: darwinDetails,
        ),
      );
      return true;
    } on Exception {
      return false;
    }
  }

  /// Schedules or updates daily morning & evening notifications in the user's
  /// active [locale] (`vi`, `en`, `ko`, `ja`, `fr`, `zh`).
  Future<void> scheduleDailyReminders({
    required Map<ReminderKind, ReminderChoice> choices,
    required SoulLocale locale,
    String? preferredName,
  }) async {
    try {
      final l10n = lookupAppLocalizations(Locale(locale.name));
      final displayName =
          (preferredName != null && preferredName.trim().isNotEmpty)
              ? preferredName.trim()
              : 'Soul';
      final (channelName, channelDesc) = _channelForLocale(locale);
      final details = NotificationDetails(
        android: AndroidNotificationDetails(
          'soul_daily_reminders',
          channelName,
          channelDescription: channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          visibility: NotificationVisibility.public,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
        macOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      final morning = choices[ReminderKind.morning];
      if (morning == null || !morning.enabled) {
        await _plugin.cancel(id: 2001);
      } else {
        await _plugin.periodicallyShow(
          id: 2001,
          title: l10n.notificationMorningTitle(displayName),
          body: l10n.notificationMorningBody,
          repeatInterval: RepeatInterval.daily,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }

      final evening = choices[ReminderKind.evening];
      if (evening == null || !evening.enabled) {
        await _plugin.cancel(id: 2002);
      } else {
        await _plugin.periodicallyShow(
          id: 2002,
          title: l10n.notificationEveningTitle(displayName),
          body: l10n.notificationEveningBody,
          repeatInterval: RepeatInterval.daily,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    } on Exception {
      // Safe fallback when platform notifications plugin is unavailable.
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

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

/// Asks the OS for permission to show local reminders.
class NotificationPermissions {
  NotificationPermissions(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

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
}

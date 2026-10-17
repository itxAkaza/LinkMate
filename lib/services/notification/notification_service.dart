import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'dart:io';

class NotificationServices {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // --- Initialization ---
  Future<void> initNotification(bool isEnabled) async {
    if (_isInitialized) return;
    if (!isEnabled) return; // Do not boot up if user disabled them in settings

    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const initSettingAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
    const initSettingIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
    );

    const initSetting = InitializationSettings(
      android: initSettingAndroid,
      iOS: initSettingIOS,
    );

    await notificationPlugin.initialize(
      settings: initSetting,
      // Optional: Add onDidReceiveNotificationResponse here later to handle clicks
    );
    _isInitialized = true;
  }

  // --- Toggle Handling ---
  /// Call this when the user flips the "Enable Notifications" toggle in Settings
  Future<void> handleSettingsToggle(bool isEnabled) async {
    if (!isEnabled) {
      // If user turns off notifications, wipe all pending scheduled reminders
      await cancelAllNotifications();
      _isInitialized = false;
    } else {
      // If user turns them on, initialize the service
      await initNotification(true);
    }
  }

  // --- Core Actions ---
  Future<void> cancelAllNotifications() async {
    await notificationPlugin.cancelAll();
  }

  Future<void> cancelNotification(int id) async {
    await notificationPlugin.cancel(id: id);
  }

  // --- Permission Handling ---
  Future<bool> requestAndCheckPermissions() async {
    if (Platform.isAndroid) {
      final androidPlugin = notificationPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        final bool? granted = await androidPlugin.requestNotificationsPermission();
        await androidPlugin.requestExactAlarmsPermission();
        return granted ?? false;
      }
    } else if (Platform.isIOS) {
      final iosPlugin = notificationPlugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

      if (iosPlugin != null) {
        final bool? granted = await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
    }
    return false;
  }

  // --- Notification Details & Scheduling ---
  NotificationDetails _scheduleNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "linkvault_reminders_channel", // Updated for LinkVault
        "Link Reminders",              // Updated for LinkVault
        channelDescription: "Reminders to revisit saved links and videos",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showScheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    if (!_isInitialized) return; // Prevent crash if notifications are toggled off

    final tz.TZDateTime scheduleTime = tz.TZDateTime.from(scheduledDate, tz.local);

    if (scheduleTime.isBefore(tz.TZDateTime.now(tz.local))) {
      return; // Don't schedule if the time is already in the past
    }

    await notificationPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduleTime,
      notificationDetails: _scheduleNotificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
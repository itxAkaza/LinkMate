import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // --- Initialization ---
  Future<void> initNotification(bool isEnabled) async {
    if (_isInitialized) return;
    if (!isEnabled) return; // Do not boot up if user disabled them in settings

    tz.initializeTimeZones();
    try {
      final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone));
    } catch (e) {
      debugPrint("Timezone initialization fallback: $e");
    }

    const initSettingAndroid = AndroidInitializationSettings('@drawable/ic_stat_linkmate');
    const initSettingIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
    );

    const initSetting = InitializationSettings(
      android: initSettingAndroid,
      iOS: initSettingIOS,
    );

    try {
      await notificationPlugin.initialize(
        settings: initSetting,
      );
      _isInitialized = true;
    } catch (e) {
      debugPrint("Notification plugin init error: $e");
    }
  }

  // --- Toggle Handling ---
  /// Call this when the user flips the "Enable Notifications" toggle in Settings
  Future<void> handleSettingsToggle(bool isEnabled) async {
    if (!isEnabled) {
      await cancelAllNotifications();
      _isInitialized = false;
    } else {
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
        "linkmate_reminders_channel_v2",
        "LinkMate Reminders",
        channelDescription: "Reminders to revisit saved links and videos",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        icon: '@drawable/ic_stat_linkmate',
        color: Color(0xFF2B7FFF),
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
    if (!_isInitialized) {
      await initNotification(true);
    }

    final DateTime now = DateTime.now();
    Duration diff = scheduledDate.difference(now);

    // If MetadataFetch took a few seconds and pushed the selected minute slightly into the past,
    // fire it 5 seconds from now instead of silently dropping it!
    if (diff.inSeconds <= 0) {
      diff = const Duration(seconds: 5);
    }

    final tz.TZDateTime scheduleTime = tz.TZDateTime.now(tz.local).add(diff);

    try {
      // 1. Try to schedule with exact precision
      await notificationPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduleTime,
        notificationDetails: _scheduleNotificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e) {
      debugPrint("Exact alarm schedule failed ($e), trying inexact fallback...");
      try {
        // 2. Android 14+ Fallback: Inexact scheduling wrapped safely
        await notificationPlugin.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: scheduleTime,
          notificationDetails: _scheduleNotificationDetails(),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      } catch (fallbackError) {
        debugPrint("Inexact notification schedule also failed: $fallbackError");
      }
    }
  }
}
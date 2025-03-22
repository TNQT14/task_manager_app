import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(settings);
  }

  /// Kiểm tra và yêu cầu quyền trước khi đặt thông báo
  static Future<bool> checkExactAlarmPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.scheduleExactAlarm.status;
      if (status.isGranted) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  /// Yêu cầu cấp quyền và mở cài đặt nếu cần
  static Future<void> requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      if (!await checkExactAlarmPermission()) {
        print("Exact alarms are not permitted. Yêu cầu cấp quyền.");
        AppSettings.openAppSettings();
      }
    }
  }

  static Future<void> scheduleTaskNotification(
      int id, String title, String body, DateTime dueDate) async {
    try {
      bool hasPermission = await checkExactAlarmPermission();
      if (!hasPermission) {
        await requestExactAlarmPermission();
        return;
      }
      await _notificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(dueDate, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'task_channel',
              'Nhắc nhở công việc',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          matchDateTimeComponents: DateTimeComponents.time,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
    } on PlatformException catch (e) {
      if (e.code == "exact_alarms_not_permitted") {
        print("Exact alarms are not permitted. Yêu cầu cấp quyền.");
        await requestExactAlarmPermission();
      }
    }
  }
}

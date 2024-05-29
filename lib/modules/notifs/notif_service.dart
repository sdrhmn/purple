import 'dart:core';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timely/modules/completed_tasks/task_model.dart';
import 'package:timezone/timezone.dart' as tz;

// NOTE: This class is a singleton.
// IMPR: Using Riverpod might have been better than a singleton.
class NotifService {
  static final NotifService _notifService = NotifService._internal();

  factory NotifService() {
    return _notifService;
  }

  NotifService._internal();

  // --------- --------- ---------- ---------

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: '');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> scheduleNotif(Task task, DateTime notifDateTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'scheduled title',
        'scheduled body',
        tz.TZDateTime.from(
          notifDateTime.subtract(
            const Duration(minutes: 5),
          ),
          tz.local,
        ),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelNotif(id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifs() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

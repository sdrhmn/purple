import 'dart:core';
import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
        AndroidInitializationSettings('purple_time_app_icon');

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

    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    }

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<void> scheduleNotif(dynamic model, DateTime notifDateTime) async {
    try {
      await FlutterLocalNotificationsPlugin().zonedSchedule(
        model.notifId,
        model.name,
        "You have a task to work on!",
        tz.TZDateTime.from(
          notifDateTime.subtract(
            const Duration(minutes: 0),
          ),
          tz.local,
        ),
        const NotificationDetails(
            linux: LinuxNotificationDetails(),
            iOS: DarwinNotificationDetails(),
            android: AndroidNotificationDetails('', 'Purple Time',
                channelDescription: '',
                priority: Priority.high,
                importance: Importance.high)),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> cancelNotif(id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifs() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

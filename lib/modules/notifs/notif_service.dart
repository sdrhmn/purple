import 'dart:core';
import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
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

    DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            requestSoundPermission: false,
            requestBadgePermission: false,
            requestAlertPermission: false,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: '');

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );

    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestNotificationsPermission();
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
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
            iOS: DarwinNotificationDetails(
              presentSound: true,
              presentList: true,
              presentAlert: true,
              presentBadge: true,
              presentBanner: true,
            ),
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

  /// Schedules notifs for today, tomorrow and also schedules reminders if present.
  Future<void> scheduleRepeatTaskNotifs(SchedulingModel model) async {
    // ------ Schedule Notifs for today? -------
    DateTime nextDate = model.getNextOccurenceDateTime();
    if (DateTime(nextDate.year, nextDate.month, nextDate.day) ==
        DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day)) {
      NotifService().scheduleNotif(model, nextDate);
    }
    print("Scheduled for today");

    // Tomorrow?
    scheduleNotifForNextDay(model);

    // Reminders
    scheduleReminders(model);
  }

  Future<void> scheduleNotifForNextDay(SchedulingModel model) async {
    // '''If applicable, schedules a notif for the next day'''
    if (model.getNextOccurenceDateTime(
            st: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 11, 59)) ==
        DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day + 1)) {
      NotifService().scheduleNotif(
          model.copyWith(notifId: model.notifId! + 1),
          model.getNextOccurenceDateTime(
              st: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day, 11, 59)));
    }
    print("Scheduled for next day");
  }

  Future<void> scheduleReminders(SchedulingModel model) async {
    if (model.reminders != null) {
      for (var entry in model.reminders!.entries) {
        try {
          await FlutterLocalNotificationsPlugin().zonedSchedule(
            entry.key,
            model.name,
            "You have a task to work on!",
            tz.TZDateTime.from(
              model.getNextOccurenceDateTime().subtract(
                    entry.value, // yani, subtract the duration
                  ),
              tz.local,
            ),
            const NotificationDetails(
                linux: LinuxNotificationDetails(),
                iOS: DarwinNotificationDetails(
                  presentSound: true,
                  presentList: true,
                  presentAlert: true,
                  presentBadge: true,
                  presentBanner: true,
                ),
                android: AndroidNotificationDetails('', 'Purple Time',
                    channelDescription: '',
                    priority: Priority.high,
                    importance: Importance.high)),
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
          print("Scheduled reminder");
        } catch (e) {
          // ignore: avoid_print
          print(e.toString());
        }
      }
    }
  }

  Future<void> cancelNotif(id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifs() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> cancelRepeatTaskNotifs(SchedulingModel model) async {
    // Cancel today's and tomo's
    await Future.wait([
      for (int id in [model.notifId!, model.notifId! + 1])
        flutterLocalNotificationsPlugin.cancel(id)
    ]);

    // Cancel reminders
    if (model.reminders != null) {
      await Future.wait([
        for (int id in model.reminders!.keys)
          flutterLocalNotificationsPlugin.cancel(id)
      ]);
    }
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {}
}

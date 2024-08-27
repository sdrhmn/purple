import 'dart:core';
import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
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
      // print("IS ANDROID = TRUE");
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
        model.activity,
        "Due now",
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
      // print(e.toString());
    }
  }

  // [-][-][-][-][-] Repeating Notifs [-][-][-][-][-]

  /// Schedules notifs for today, tomorrow and also schedules reminders if present.
  Future<void> scheduleRepeatTaskNotifs(Task task) async {
    // ------ Schedule Notifs for today? -------
    DateTime nextDate = task.repeatRule!.getNextOccurrenceDateTime();
    if (DateTime(nextDate.year, nextDate.month, nextDate.day) ==
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))
    // Yani, if the task is to occur today
    {
      NotifService().scheduleNotif(task, nextDate);

      // Schedule reminders for today
      scheduleReminders(task, dateTime: nextDate);
    }
  }

  // Future<void> scheduleRepeatTaskNotifForNextDay(SchedulingModel model) async {
  //   // '''If applicable, schedules a notif for the next day'''
  //   if (model.getNextOccurrenceDateTime(
  //           st: DateTime(DateTime.now().year, DateTime.now().month,
  //               DateTime.now().day, 23, 59)) ==
  //       DateTime(DateTime.now().year, DateTime.now().month,
  //           DateTime.now().day + 1)) {
  //     NotifService().scheduleNotif(
  //         model.copyWith(notifId: model.notifId! + 1),
  //         model.getNextOccurrenceDateTime(
  //             st: DateTime(DateTime.now().year, DateTime.now().month,
  //                 DateTime.now().day, 23, 59)));
  //   }
  //   // print("Scheduled for next day");
  // }

  Future<void> scheduleReminders(Task model, {DateTime? dateTime}) async {
    for (var entry in model.reminders.entries) {
      try {
        await FlutterLocalNotificationsPlugin().zonedSchedule(
          entry.key,
          model.name,
          "Due in ${entry.value.inMinutes} minutes",
          tz.TZDateTime.from(
            (dateTime ?? model.repeatRule!.getNextOccurrenceDateTime())
                .subtract(
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
        // print(
        //     "Scheduled reminder at ${(dateTime ?? model.getNextOccurrenceDateTime()).subtract(
        //   entry.value, // yani, subtract the duration
        // )}");
      } catch (e) {
        // print(
        //     "Scheduled reminder at ${(dateTime ?? model.getNextOccurrenceDateTime()).subtract(
        //   entry.value, // yani, subtract the duration
        // )}");
        // ignore: avoid_print
        // print(e.toString());
      }
    }
  }

  // [-][-][-][-][-] Ad Hoc Notifs [-][-][-][-][-]

  Future<void> scheduleAdHocTaskNotifs(Task model) async {
    //----- Schedule Notification --------
    NotifService().scheduleNotif(
        model,
        DateTime(model.date!.year, model.date!.month, model.date!.day,
            model.time!.hour, model.time!.minute));

    // Reminders
    NotifService().scheduleReminders(model,
        dateTime: model.date!
            .copyWith(hour: model.time!.hour, minute: model.time!.minute));
  }

  Future<void> cancelNotif(id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
    // print("Cancelled notif");
  }

  Future<void> cancelAllNotifs() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    // print("Cancelled notifs");
  }

  Future<void> cancelReminders(reminders) async {
    // Cancel reminders
    await Future.wait([
      for (int id in reminders!.keys)
        flutterLocalNotificationsPlugin.cancel(id),
      for (int id in reminders!.keys)
        flutterLocalNotificationsPlugin.cancel(id + 1)
    ]);
  }

  Future<void> cancelRepeatTaskNotifs(Task task) async {
    // Cancel today's and tomo's
    await Future.wait([
      for (int id in [task.notifId, task.notifId + 1])
        flutterLocalNotificationsPlugin.cancel(id)
    ]);

    await cancelReminders(task.reminders);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {}
}

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/common/scheduling/scheduling_repository.dart';
import 'package:timely/modules/notifs/notif_service.dart';
import 'package:timely/reusables.dart';

final repeatingNotifsSchedulerProvider = FutureProvider<void>((ref) async {
  File file = (await ref.read(dbFilesProvider.future))[2]![0];
  DateTime now = DateTime.now();
  DateTime nextDay = DateTime(now.year, now.month, now.day + 1);

  // Schedule notifs and rems for today
  // |- Fetch all tasks due today
  List<SchedulingModel> models = await ref
      .read(schedulingRepositoryServiceProvider.notifier)
      .getActivitiesByDate(
        SchedulingModel.fromJson,
        file,
        nextDay.copyWith(day: nextDay.day - 1),
      );

  for (SchedulingModel model in models) {
    // Schedule reminders for it
    NotifService()
        .scheduleReminders(model, dateTime: model.getNextOccurrenceDateTime());

    // Schedule notif for it
    NotifService().scheduleNotif(model, model.getNextOccurrenceDateTime());
  }

  // Schedule notifs and rems for tomorrow in case the user does not open the app
  // tomorrow
  // |- Fetch all tasks due tomorrow
  models = await ref
      .read(schedulingRepositoryServiceProvider.notifier)
      .getActivitiesByDate(SchedulingModel.fromJson, file, nextDay,
          startDate: DateTime(now.year, now.month, now.day, 23, 59));

  for (SchedulingModel model in models) {
    print(model.reminders);
    model = model.copyWith(
      reminders: model.reminders!.map((i, d) => MapEntry(i + 1, d)),
    );
    print(model.reminders);

    print(
        "Next OCCURENCE: ${model.getNextOccurrenceDateTime(st: DateTime(now.year, now.month, now.day, 23, 59))}");

    // Schedule reminders for it
    NotifService().scheduleReminders(model,
        dateTime: model.getNextOccurrenceDateTime(
            st: DateTime(now.year, now.month, now.day, 23, 59)));

    // Schedule notifs for it
    NotifService().scheduleRepeatTaskNotifForNextDay(model);
  }

  return;
});

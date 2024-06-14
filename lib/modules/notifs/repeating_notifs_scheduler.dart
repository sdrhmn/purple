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

  // Fetch all tasks due tomorrow
  List<SchedulingModel> models = await ref
      .read(schedulingRepositoryServiceProvider.notifier)
      .getActivitiesByDate(SchedulingModel.fromJson, file, nextDay,
          startDate: DateTime(now.year, now.month, now.day, 11, 59));

  for (SchedulingModel model in models) {
    // Schedule reminders for them
    NotifService().scheduleReminders(model,
        dateTime: model.getNextOccurrenceDateTime(
            st: DateTime(now.year, now.month, now.day, 11, 59)));

    // Schedule notifs for them
    NotifService().scheduleNotifForNextDay(model);
  }

  return;
});

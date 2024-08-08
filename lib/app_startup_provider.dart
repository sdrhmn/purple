import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/modules/tasks/models/repetition_data_model.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/objectbox.g.dart';
import 'package:timely/reusables.dart';

final appStartupProvider = FutureProvider<void>((ref) async {
  // ObjectBox
  await ref.read(storeProvider.future);

  // Modify repeat tasks
  // Get all repeat tasks
  // Loop over those whose next occurence is today
  // Change the task.date to the next occurence
  // Save to the database
  await () async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    Store taskStore = ref.read(storeProvider).requireValue;
    Box<RepetitionData> repeatTaskBox = taskStore.box<RepetitionData>();
    Box<DataTask> taskBox = taskStore.box<DataTask>();

    final query = (taskBox.query(DataTask_.date.betweenDate(
            DateTime(now.year, now.month, now.day, 0, 0),
            DateTime(now.year, now.month, now.day, 23, 59))))
        .build();

    List<RepetitionData> repetitionDatas = (await repeatTaskBox.getAllAsync());
    List<Task> todaysTasks =
        (await query.findAsync()).map((e) => Task.fromDataTask(e)).toList();

    List<DataTask> _ = [];

    for (RepetitionData repetitionData in repetitionDatas) {
      Task task = Task.fromJson(jsonDecode(repetitionData.task))
        ..repeatRule = SchedulingModel.fromJson(jsonDecode(repetitionData.data))
        ..repetitionDataId = repetitionData.id;
      DateTime next = task.repeatRule!.getNextOccurrenceDateTime();

      task.date = DateTime(next.year, next.month, next.day);

      if (DateTime(next.year, next.month, next.day) == today &&
          today.isBefore(
              task.repeatRule!.endDate ?? today.copyWith(day: today.day + 1))) {
        // Check if it exists in today's tasks or not
        if (todaysTasks
            .where((task) => task.repeatRule != null)
            .map((task) => task.repetitionDataId)
            .toList()
            .contains(repetitionData.id)) {
        }
        // If it does NOT contain
        else {
          _.add(
            DataTask(
                date: next.copyWith(
                  hour: task.time?.hour,
                  minute: task.time!.minute,
                ),
                data: jsonEncode(task.toJson()))
              ..repetitionData.target = repetitionData,
          );
        }
      }
    }

    taskBox.putManyAsync(_);
  }();

  return;
});

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tasks/task_model.dart';
import 'package:timely/objectbox.g.dart';
import 'package:timely/reusables.dart';

final appStartupProvider = FutureProvider<void>((ref) async {
  // ObjectBox
  await ref.read(storesProvider.future);

  // Modify repeat tasks
  // Get all repeat tasks
  // Loop over those whose next occurence is today
  // Change the task.date to the next occurence
  // Save to the database
  await () async {
    Store taskStore = ref.read(storesProvider).requireValue.first;
    Box taskBox = taskStore.box<DataTask>();

    List dataTasks = await taskBox.getAllAsync();
    List<Task> tasks = [
      for (DataTask dataTask in dataTasks) Task.fromDataTask(dataTask)
    ];

    List<Task> repeatTasks =
        tasks.where((task) => task.repeatRule != null).toList();

    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);

    List<DataTask> _ = [];
    for (Task task in repeatTasks) {
      DateTime next = (task.repeatRule!.getNextOccurrenceDateTime());
      if (DateTime(next.year, next.month, next.day) == date) {
        task.date = date;
        _.add(DataTask(
            id: task.id,
            date: task.date?.copyWith(
                    hour: task.time?.hour, minute: task.time?.minute) ??
                DateTime.now(),
            data: jsonEncode(task.toJson())));
      }
    }

    await taskBox.putManyAsync(_);
  }();

  return;
});

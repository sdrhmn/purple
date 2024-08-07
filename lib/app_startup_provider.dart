import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tasks/data/task_repository.dart';
import 'package:timely/modules/tasks/models/repeat_task_model.dart';
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
    Store taskStore = ref.read(storeProvider).requireValue;
    Box<DataRepeatTask> repeatTaskBox = taskStore.box<DataRepeatTask>();

    List<DataRepeatTask> dataRepeatTasks = (await repeatTaskBox.getAllAsync());

    List<Task> todaysTasks =
        (await ref.read(taskRepositoryProvider.notifier).getTodaysTasks());

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    List<DataTask> _ = [];

    for (DataRepeatTask dataRepeatTask in dataRepeatTasks) {
      RepeatTask repeatTask = RepeatTask.fromDataRepeatTask(dataRepeatTask);
      // Task task = Task.fromJson(jsonDecode(dataRepeatTask.task));
      DateTime next = repeatTask.repeatRule.getNextOccurrenceDateTime();
      if (DateTime(next.year, next.month, next.day) == today) {
        // Check if it exists in today's tasks or not
        if (todaysTasks
            .where((task) => task.repeatTask != null)
            .map((task) => task.repeatTask!.id)
            .toList()
            .contains(repeatTask.id)) {
        }
        // If it does NOT contain
        else {
          _.add(DataTask(date: DateTime.now(), data: dataRepeatTask.task));
        }
      }
    }

    taskStore.box<DataTask>().putManyAsync(_);
  }();

  return;
});

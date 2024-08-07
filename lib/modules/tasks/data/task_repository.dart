import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tasks/models/repeat_task_model.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/objectbox.g.dart';
import 'package:timely/reusables.dart';

class TaskRepositoryNotifier extends AsyncNotifier<void> {
  late final Store taskStore;

  // Boxes
  late final Box<DataTask> taskBox;
  late final Box<DataRepeatTask> repeatTaskBox;

  @override
  FutureOr<void> build() {
    taskStore = ref.read(storeProvider).requireValue;

    // Boxes
    taskBox = taskStore.box<DataTask>();
    repeatTaskBox = taskStore.box<DataRepeatTask>();
  }

  // Methods
  Future<List<Task>> getTodaysTasks() async {
    DateTime now = DateTime.now();
    final query = (taskBox.query(DataTask_.date
            .lessOrEqualDate(DateTime(now.year, now.month, now.day, 23, 59))
            .and(DataTask_.completed.equals(false))
            .or(DataTask_.date.betweenDate(
                DateTime(now.year, now.month, now.day, 0, 0),
                DateTime(now.year, now.month, now.day, 23, 59)))))
        .build();

    List<DataTask> dataTasks = await query.findAsync();

    dataTasks.sort((a, b) => a.date.difference(b.date).inSeconds);

    List<Task> tasks = [];

    for (DataTask dataTask in dataTasks) {
      Task task = Task.fromDataTask(dataTask);

      print(task.repeatTask);

      tasks.add(Task.fromDataTask(dataTask));
    }

    return tasks;
  }

  Future<Map<DateTime, List<Task>>> getUpcomingTasks() async {
    DateTime now = DateTime.now();
    final query = (taskBox.query(DataTask_.date
            .greaterThanDate(DateTime(now.year, now.month, now.day, 23, 59))))
        .build();

    List<DataTask> dataTasks = await query.findAsync();

    List<Task> tasks = [];

    for (DataTask dataTask in dataTasks) {
      tasks.add(Task.fromDataTask(dataTask));
    }

    tasks.sort((a, b) => b.date!.difference(a.date!).inSeconds);

    return {
      for (DateTime date in Set.from(
          List.generate(tasks.length, (index) => tasks[index].date!)))
        date: tasks.where((task) => task.date == date).toList()
    };
  }

  Future<Map<DateTime, List<Task>>> getCompletedTasks() async {
    final query = (taskBox.query(DataTask_.completed.equals(true))).build();

    List<DataTask> dataTasks = await query.findAsync();

    List<Task> tasks = [];

    for (DataTask dataTask in dataTasks) {
      Task task = Task.fromDataTask(dataTask);
      task.date ??= dataTask.date;
      tasks.add(task);
    }

    tasks.sort((a, b) => b.date!.difference(a.date!).inSeconds);

    return {
      for (DateTime date in Set.from(List.generate(
          tasks.length,
          (index) => DateTime(tasks[index].date!.year, tasks[index].date!.month,
              tasks[index].date!.day))))
        date: tasks
            .where((task) =>
                DateTime(task.date!.year, task.date!.month, task.date!.day) ==
                date)
            .toList()
    };
  }

  writeTask(Task task) {
    if (task.repeatTask != null) {
      task.repeatTask!.id = repeatTaskBox.put(
        DataRepeatTask(
          data: jsonEncode(
            task.repeatTask!.repeatRule.toJson(),
          ),
          task: jsonEncode(task.toJson()),
        ),
      );
    }

    taskBox.put(
      DataTask(
        date: task.date
                ?.copyWith(hour: task.time?.hour, minute: task.time?.minute) ??
            DateTime.now()
                .copyWith(hour: task.time?.hour, minute: task.time?.minute),
        data: jsonEncode(
          task.toJson(),
        ),
      ),
    );
  }

  updateTask(Task task) {
    if (task.repeatTask != null) {
      task.repeatTask!.id = repeatTaskBox.put(
        DataRepeatTask(
          id: task.repeatTask!.id,
          data: jsonEncode(
            task.repeatTask!.repeatRule.toJson(),
          ),
          task: jsonEncode(task.toJson()),
        ),
      );
    }

    taskBox.put(
      DataTask(
        date: task.date
                ?.copyWith(hour: task.time?.hour, minute: task.time?.minute) ??
            DateTime.now()
                .copyWith(hour: task.time?.hour, minute: task.time?.minute),
        id: task.id!,
        data: jsonEncode(
          task.toJson(),
        ),
        completed: task.isComplete,
      ),
    );
  }

  deleteTask(Task task) {
    taskBox.remove(task.id!);
  }

  completeTask(Task task) {
    taskBox.put(
      DataTask(
        date: task.date
                ?.copyWith(hour: task.time?.hour, minute: task.time?.minute) ??
            DateTime.now()
                .copyWith(hour: task.time?.hour, minute: task.time?.minute),
        id: task.id!,
        data: jsonEncode(
          task.toJson(),
        ),
        completed: task.isComplete,
      ),
    );
  }
}

final taskRepositoryProvider =
    AsyncNotifierProvider<TaskRepositoryNotifier, void>(
        TaskRepositoryNotifier.new);

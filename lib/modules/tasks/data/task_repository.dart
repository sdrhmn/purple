import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tasks/task_model.dart';
import 'package:timely/objectbox.g.dart';
import 'package:timely/reusables.dart';

class TaskRepositoryNotifier extends AsyncNotifier<void> {
  late final Store taskStore;
  late final Box<DataTask> taskBox;

  // late final Store taskHistoryStore;
  // late final Box<DataTask> taskBox;

  @override
  FutureOr<void> build() {
    taskStore = ref.read(storesProvider).requireValue.first;
    taskBox = taskStore.box<DataTask>();

    // taskHistoryStore = ref.read(storesProvider).requireValue.last;
    // taskBox = taskHistoryStore.box<DataTask>();
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
      tasks.add(Task.fromJson(jsonDecode(dataTask.data))..id = dataTask.id);
    }

    return tasks;
  }

  Future<List<Task>> getUpcomingTasks() async {
    DateTime now = DateTime.now();
    final query = (taskBox.query(DataTask_.date
            .greaterThanDate(DateTime(now.year, now.month, now.day, 23, 59))))
        .build();

    List<DataTask> dataTasks = await query.findAsync();

    List<Task> tasks = [];

    for (DataTask dataTask in dataTasks) {
      tasks.add(Task.fromJson(jsonDecode(dataTask.data))..id = dataTask.id);
    }

    tasks.sort((a, b) => a.date!.difference(b.date!).inSeconds);

    return tasks;
  }

  writeTask(Task task) {
    taskBox.put(
      DataTask(
        date: task.date
                ?.copyWith(hour: task.time?.hour, minute: task.time?.minute) ??
            DateTime.now(),
        data: jsonEncode(
          task.toJson(),
        ),
      ),
    );
  }

  updateTask(Task task) {
    taskBox.put(
      DataTask(
        date: task.date
                ?.copyWith(hour: task.time?.hour, minute: task.time?.minute) ??
            DateTime.now(),
        id: task.id,
        data: jsonEncode(
          task.toJson(),
        ),
      ),
    );
  }

  deleteTask(Task task) {
    taskBox.remove(task.id);
  }

  completeTask(Task task) {
    taskBox.put(
      DataTask(
          date: task.date?.copyWith(
                  hour: task.time?.hour, minute: task.time?.minute) ??
              DateTime.now(),
          id: task.id,
          data: jsonEncode(
            task.toJson(),
          ),
          completed: true),
    );
  }
}

final taskRepositoryProvider =
    AsyncNotifierProvider<TaskRepositoryNotifier, void>(
        TaskRepositoryNotifier.new);

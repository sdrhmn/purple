import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tasks/task_model.dart';
import 'package:timely/objectbox.g.dart';
import 'package:timely/reusables.dart';

class TaskRepositoryNotifier extends AsyncNotifier<void> {
  late final Store taskStore;
  late final Store taskHistoryStore;

  late final Box<DataTask> taskBox;
  late final Box<DataTask> taskHistoryBox;

  @override
  FutureOr<void> build() {
    taskStore = ref.read(storesProvider).requireValue.first;
    taskHistoryStore = ref.read(storesProvider).requireValue.last;

    taskBox = taskStore.box<DataTask>();
    taskHistoryBox = taskHistoryStore.box<DataTask>();
  }

  // Methods
  Future<List<Task>> getTodaysTasks() async {
    DateTime now = DateTime.now();
    final query0 = (taskHistoryBox.query(DataTask_.date
            .betweenDate(DateTime(now.year, now.month, now.day, 0, 0),
                DateTime(now.year, now.month, now.day, 23, 59))
            .and(DataTask_.deleted.isNull())))
        .build();
    final query1 = (taskBox.query(DataTask_.date
            .lessOrEqualDate(DateTime(now.year, now.month, now.day, 23, 59))))
        .build();

    List<DataTask> dataTasks = [];

    List results =
        (await Future.wait([query1.findAsync(), query0.findAsync()]));

    List.generate(results.length, (index) {
      dataTasks.addAll(results[index]);
    });

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
    task.isComplete
        ? taskHistoryBox.put(
            DataTask(
              date: task.date ?? DateTime.now(),
              id: task.id,
              data: jsonEncode(
                task.toJson(),
              ),
            ),
          )
        : taskBox.put(
            DataTask(
              date: task.date ?? DateTime.now(),
              id: task.id,
              data: jsonEncode(
                task.toJson(),
              ),
            ),
          );
  }

  deleteTask(Task task) {
    taskBox.remove(task.id);
    taskHistoryBox.put(
      DataTask(
        id: task.id,
        date: task.date ?? DateTime.now(),
        data: jsonEncode(
          task.toJson(),
        ),
        deleted: true,
      ),
    );
  }

  completeTask(Task task) {
    if (task.isComplete) {
      taskBox.remove(task.id);
      taskHistoryBox.put(
        DataTask(
          id: task.id,
          date: task.date ?? DateTime.now(),
          data: jsonEncode(
            task.toJson(),
          ),
        ),
      );
    } else
    // If task is marked INCOMPLETE
    {
      // Reverse
      taskHistoryBox.remove(task.id);
      taskBox.put(
        DataTask(
          id: task.id,
          date: task.date ?? DateTime.now(),
          data: jsonEncode(
            task.toJson(),
          ),
        ),
      );
    }
  }
}

final taskRepositoryProvider =
    AsyncNotifierProvider<TaskRepositoryNotifier, void>(
        TaskRepositoryNotifier.new);

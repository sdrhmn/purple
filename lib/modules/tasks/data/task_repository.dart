import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tasks/models/repetition_data_model.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/objectbox.g.dart';
import 'package:timely/reusables.dart';

class TaskRepositoryNotifier extends AsyncNotifier<void> {
  late final Store taskStore;

  // Boxes
  late final Box<DataTask> taskBox;
  late final Box<RepetitionData> repetitionDataBox;

  @override
  FutureOr<void> build() {
    taskStore = ref.read(storeProvider).requireValue;

    // Boxes
    taskBox = taskStore.box<DataTask>();
    repetitionDataBox = taskStore.box<RepetitionData>();
  }

  // Methods
  Future<List<Task>> getTodaysTasks() async {
    DateTime now = DateTime.now();
    final query = (taskBox.query(DataTask_.dateTime
            .lessOrEqualDate(DateTime(now.year, now.month, now.day, 23, 59))
            .and(DataTask_.completed.equals(false))
            .or(DataTask_.dateTime
                .isNull()
                .and(DataTask_.completed.equals(false)))
            .or(DataTask_.dateTime.betweenDate(
                DateTime(now.year, now.month, now.day, 0, 0),
                DateTime(now.year, now.month, now.day, 23, 59)))))
        .build();

    List<DataTask> dataTasks = await query.findAsync();

    List<Task> tasks = [];

    for (DataTask dataTask in dataTasks) {
      tasks.add(Task.fromDataTask(dataTask));
    }

    tasks.sort((a, b) {
      return (a.date?.copyWith(
                  hour: a.time?.hour ?? 23, minute: a.time?.minute ?? 59) ??
              DateTime.now().copyWith(hour: 23, minute: 59))
          .difference(b.date?.copyWith(
                  hour: b.time?.hour ?? 23, minute: b.time?.minute ?? 59) ??
              DateTime.now().copyWith(hour: 23, minute: 59))
          .inSeconds;
    });

    return tasks;
  }

  Future<Map<DateTime, List<Task>>> getUpcomingTasks() async {
    DateTime now = DateTime.now();
    final query = (taskBox.query(DataTask_.dateTime
            .greaterThanDate(DateTime(now.year, now.month, now.day, 23, 59))))
        .build();

    List<DataTask> dataTasks = await query.findAsync();

    List<Task> tasks = [];

    for (DataTask dataTask in dataTasks) {
      tasks.add(Task.fromDataTask(dataTask));
    }

    return {
      for (DateTime date in Set.from(
          List.generate(tasks.length, (index) => tasks[index].date!)))
        date: tasks.where((task) => task.date == date).toList()
          ..sort((a, b) => a.date!
              .copyWith(hour: a.time?.hour, minute: a.time?.minute)
              .difference(
                  b.date!.copyWith(hour: b.time?.hour, minute: b.time?.minute))
              .inSeconds)
    };
  }

  Future<Map<DateTime?, List<Task>>> getCompletedTasks() async {
    final query = (taskBox.query(DataTask_.completed.equals(true))).build();

    List<DataTask> dataTasks = await query.findAsync();

    List<Task> tasks = [];

    for (DataTask dataTask in dataTasks) {
      Task task = Task.fromDataTask(dataTask);
      task.date ??= dataTask.dateTime;
      tasks.add(task);
    }

    tasks.sort((a, b) => b.completedAt!.difference(a.completedAt!).inSeconds);

    return {
      for (DateTime? date in Set.from(
        List.generate(
          tasks.length,
          (index) => tasks[index].completedAt,
        ),
      ))
        DateTime(date!.year, date.month, date.day): tasks
            .where((task) =>
                DateTime(task.completedAt!.year, task.completedAt!.month,
                    task.completedAt!.day) ==
                DateTime(date.year, date.month, date.day))
            .toList()
    };
  }

  writeTask(Task task) {
    RepetitionData? repetitionData;
    if (task.repeatRule != null) {
      repetitionData = RepetitionData(
        data: jsonEncode(task.repeatRule!.toJson()),
        task: jsonEncode(task.toJson()),
      );
      repetitionDataBox.put(repetitionData);
    }

    taskBox.put(
      DataTask(
        dateTime: task.date
            ?.copyWith(hour: task.time?.hour, minute: task.time?.minute),
        data: jsonEncode(
          task.toJson(),
        ),
      )..repetitionData.target = repetitionData,
    );
  }

  updateTask(Task task) {
    RepetitionData? repetitionData;
    if (task.repeatRule != null) {
      repetitionData = RepetitionData(
        id: task.repetitionDataId,
        data: jsonEncode(task.repeatRule!.toJson()),
        task: jsonEncode(task.toJson()),
      );
      repetitionDataBox.put(repetitionData);
    }

    taskBox.put(
      DataTask(
        dateTime: task.date
            ?.copyWith(hour: task.time?.hour, minute: task.time?.minute),
        id: task.id!,
        data: jsonEncode(
          task.toJson(),
        ),
        completed: task.isComplete,
      )..repetitionData.target = repetitionData,
    );
  }

  deleteTask(Task task) {
    taskBox.remove(task.id!);
  }

  completeTask(Task task) {
    RepetitionData? repetitionData;
    if (task.repeatRule != null) {
      repetitionData = RepetitionData(
        id: task.repetitionDataId,
        data: jsonEncode(task.repeatRule!.toJson()),
        task: jsonEncode(task.toJson()),
      );
      repetitionDataBox.put(repetitionData);
    }

    taskBox.put(
      DataTask(
        dateTime: task.date
            ?.copyWith(hour: task.time?.hour, minute: task.time?.minute),
        id: task.id!,
        data: jsonEncode(
          task.toJson(),
        ),
        completed: task.isComplete,
      )..repetitionData.target = repetitionData,
    );
  }
}

final taskRepositoryProvider =
    AsyncNotifierProvider<TaskRepositoryNotifier, void>(
        TaskRepositoryNotifier.new);

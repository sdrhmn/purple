import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/projects/project_model.dart';
import 'package:timely/modules/tasks/models/repetition_data_model.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/objectbox.g.dart';
import 'package:timely/reusables.dart';

class TaskRepositoryNotifier extends AsyncNotifier<void> {
  late final Store store;

  // Boxes
  late final Box<DataTask> taskBox;
  late final Box<RepetitionData> repetitionDataBox;
  late final Box<Project> projectBox;

  @override
  FutureOr<void> build() {
    store = ref.read(storeProvider).requireValue;

    // Boxes
    taskBox = store.box<DataTask>();
    repetitionDataBox = store.box<RepetitionData>();
    projectBox = store.box<Project>();
  }

  // Methods
  Future<List<Task>> getTodaysTasks() async {
    DateTime now = DateTime.now();
    final query = taskBox
        .query(DataTask_.dateTime
            .isNull()
            .and(DataTask_.completed.equals(false))
            .or(DataTask_.dateTime.betweenDate(
                DateTime(now.year, now.month, now.day, 0, 0),
                DateTime(now.year, now.month, now.day, 23, 59))))
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

    tasks.where((task) => task.position != null).forEach((task) {
      if (task.position! < tasks.length) {
        tasks.remove(task);
        tasks.insert(task.position!, task);
      }
    });

    query.close();

    return tasks;
  }

  Future<List<Task>> getOverdueTasks() async {
    DateTime now = DateTime.now();
    final query = taskBox
        .query(
          DataTask_.dateTime
              .lessThanDate(
                DateTime(now.year, now.month, now.day),
              )
              .and(
                DataTask_.completed.equals(false),
              ),
        )
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

    query.close();

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

    List<DateTime> dates = List.from(
        Set.from(List.generate(tasks.length, (index) => tasks[index].date!)))
      ..sort();

    query.close();

    return {
      for (DateTime date in dates)
        date: tasks.where((task) => task.date == date).toList()
          ..sort((a, b) => a.date!
              .copyWith(hour: a.time?.hour, minute: a.time?.minute)
              .difference(
                  b.date!.copyWith(hour: b.time?.hour, minute: b.time?.minute))
              .inSeconds)
    };
  }

  Future<Map<DateTime?, List<Task>>> getCompletedTasks(
      // {int page = 1}
      ) async {
    final query = (taskBox.query(DataTask_.completed.equals(true))).build();

    List<DataTask> dataTasks = await (query
        // ..limit = page * 5
        // ..offset = (page - 1) * 5
        )
        .findAsync();

    List<Task> tasks = [];

    for (DataTask dataTask in dataTasks) {
      Task task = Task.fromDataTask(dataTask);
      task.date ??= dataTask.dateTime;
      tasks.add(task);
    }

    tasks.sort((a, b) => b.completedAt!.difference(a.completedAt!).inSeconds);

    query.close();

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

  writeTask(Task task, {Project? project}) {
    RepetitionData? repetitionData;
    if (task.repeatRule != null) {
      repetitionData = RepetitionData(
        data: jsonEncode(task.repeatRule!.toJson()),
        task: jsonEncode(task.toJson()),
      );
      repetitionDataBox.put(repetitionData);
    }

    DataTask dataTask = DataTask(
      dateTime:
          task.date?.copyWith(hour: task.time?.hour, minute: task.time?.minute),
      data: jsonEncode(
        task.toJson(),
      ),
    )
      ..repetitionData.target = repetitionData
      ..project.target = project;

    taskBox.put(dataTask);

    // TODO InShaaAllah :: Add SoC by creating
    // projectRepository with addTask method
    if (project != null) {
      project.tasks.add(dataTask);
      projectBox.put(project);
    }
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

    DataTask dataTask = DataTask(
      dateTime:
          task.date?.copyWith(hour: task.time?.hour, minute: task.time?.minute),
      id: task.id!,
      data: jsonEncode(
        task.toJson(),
      ),
      completed: task.isComplete,
    )
      ..repetitionData.target = repetitionData
      ..project.target = task.project.target;
    taskBox.put(dataTask);
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

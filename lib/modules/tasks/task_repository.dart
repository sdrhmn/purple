import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tasks/task_model.dart';
import 'package:timely/objectbox.g.dart';
import 'package:timely/reusables.dart';

class TaskRepositoryNotifier extends AsyncNotifier<void> {
  late final Store store;
  late final Box<DataTask> box;

  @override
  FutureOr<void> build() {
    store = ref.read(storeProvider).requireValue;
    box = store.box<DataTask>();
  }

  // Methods
  Future<List<Task>> getTasks() async {
    DateTime now = DateTime.now();
    final query = (box.query(DataTask_.date.betweenDate(
            DateTime(now.year, now.month, now.day, 0, 0),
            DateTime(now.year, now.month, now.day, 23, 59)))
          ..order(DataTask_.date))
        .build();
    List<DataTask> dataTasks = await query.findAsync();

    List<Task> tasks = [];

    for (DataTask dataTask in dataTasks) {
      tasks.add(Task.fromJson(jsonDecode(dataTask.data))..id = dataTask.id);
    }

    return tasks;
  }

  writeTask(Task task) {
    box.put(
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
    box.put(
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
    box.remove(task.id);
  }
}

final taskRepositoryProvider =
    AsyncNotifierProvider<TaskRepositoryNotifier, void>(
        TaskRepositoryNotifier.new);

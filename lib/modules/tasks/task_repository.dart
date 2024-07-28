import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objectbox/objectbox.dart';
import 'package:timely/modules/tasks/task_model.dart';
import 'package:timely/reusables.dart';

class TaskRepositoryNotifier extends AsyncNotifier<void> {
  late final Store store;
  late final Box box;

  @override
  FutureOr<void> build() {
    store = ref.read(storeProvider).requireValue;
    box = store.box<DataTask>();
  }

  // Methods
  writeTask(Task task) {
    box.put(
      DataTask(
        data: jsonEncode(
          task.toJson(),
        ),
      ),
    );
  }

  updateTask(Task task) {
    box.put(
      DataTask(
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

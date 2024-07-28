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
  Future<void> writeTask(Task task) async {
    await box.putAsync(
      DataTask(
        data: jsonEncode(
          task.toJson(),
        ),
      ),
    );
  }

  Future<void> updateTask(Task task) async {
    await box.putAsync(
      DataTask(
        id: task.id,
        data: jsonEncode(
          task.toJson(),
        ),
      ),
    );
  }
}

final taskRepositoryProvider =
    AsyncNotifierProvider<TaskRepositoryNotifier, void>(
        TaskRepositoryNotifier.new);

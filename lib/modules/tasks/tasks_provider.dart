import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tasks/task_model.dart';
import 'package:timely/reusables.dart';

final tasksProvider = FutureProvider<List<Task>>((ref) async {
  final store = ref.read(storeProvider).requireValue;
  final box = store.box<DataTask>();

  // Get all tasks
  List<DataTask> dataTasks = await box.getAllAsync();

  List<Task> tasks = [];

  for (DataTask dataTask in dataTasks) {
    tasks.add(Task.fromJson(jsonDecode(dataTask.data))..id = dataTask.id);
  }

  return tasks;
});

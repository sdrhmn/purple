import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/objectbox.g.dart';
import 'package:timely/reusables.dart';

final goalsProvider = FutureProvider.autoDispose<List<Task>>((ref) async {
  final Store taskStore = ref.read(storeProvider).requireValue;
  final Box<DataTask> taskBox = taskStore.box<DataTask>();

  final query = taskBox.query(DataTask_.type.equals("project")).build();

  List<Task> tasks =
      (await query.findAsync()).map((e) => Task.fromDataTask(e)).toList();

  return tasks;
});

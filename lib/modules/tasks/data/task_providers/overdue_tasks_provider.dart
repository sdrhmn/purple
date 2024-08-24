import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/modules/tasks/data/task_repository.dart';

final overdueTasksProvider =
    FutureProvider.autoDispose<List<Task>>((ref) async {
  // Get all tasks
  List<Task> tasks =
      await ref.read(taskRepositoryProvider.notifier).getOverdueTasks();

  return tasks;
});

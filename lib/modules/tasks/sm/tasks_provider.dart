import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tasks/task_model.dart';
import 'package:timely/modules/tasks/sm/task_repository.dart';

final tasksProvider = FutureProvider<List<Task>>((ref) async {
  // Get all tasks
  List<Task> tasks = await ref.read(taskRepositoryProvider.notifier).getTasks();

  return tasks;
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/completed_tasks/completed_tasks_repository.dart';
import 'package:timely/modules/completed_tasks/task_model.dart';

final completedTasksProvider =
    FutureProvider.autoDispose<Map<String, List<Task>>>((ref) async {
  return await ref
      .read(completedTasksRepositoryProvider.notifier)
      .fetchCompletedTasks();
});

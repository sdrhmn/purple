import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tasks/task_model.dart';
import 'package:timely/modules/tasks/data/task_repository.dart';

final upcomingTasksProvider =
    FutureProvider.autoDispose<Map<DateTime, List<Task>>>((ref) async {
  // Get all tasks
  Map<DateTime, List<Task>> tasks =
      await ref.read(taskRepositoryProvider.notifier).getUpcomingTasks();

  return tasks;
});

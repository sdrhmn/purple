import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/modules/tasks/data/task_repository.dart';

final todaysTasksProvider = StreamProvider<List<Task>>((ref) async* {
  // Get all tasks

  yield* ref.read(taskRepositoryProvider.notifier).getTodaysTasks();
});

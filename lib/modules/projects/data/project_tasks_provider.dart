import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/projects/data/project_repository.dart';
import 'package:timely/modules/tasks/models/task_model.dart';

final projectTasksProvider =
    FutureProvider.family.autoDispose<List<Task>, int>((ref, projectId) async {
  return await ref
      .read(projectRepositoryProvider.notifier)
      .getProjectTasks(projectId);
});

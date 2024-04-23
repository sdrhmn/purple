import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/home/models/task_today.dart';
import 'package:timely/modules/home/repositories/tasks_today_repo.dart';

class TasksTodayOutputNotifier extends AsyncNotifier<List<TaskToday>> {
  @override
  FutureOr<List<TaskToday>> build() async {
    return ref.read(tasksTodayRepositoryProvider.notifier).fetchTodaysTasks();
  }
}

final tasksTodayOutputProvider =
    AsyncNotifierProvider<TasksTodayOutputNotifier, List<TaskToday>>(
        TasksTodayOutputNotifier.new);

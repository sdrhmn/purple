import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/completed_tasks/completed_tasks_repository.dart';
import 'package:timely/modules/home/repositories/tasks_today_repo.dart';
import 'package:timely/modules/notifs/repeating_notifs_scheduler.dart';
import 'package:timely/modules/tab_1_new/incrementor.dart';
import 'package:timely/modules/tab_1_new/repository.dart';
import 'package:timely/reusables.dart';

final appStartupProvider = FutureProvider<void>((ref) async {
  // Initialize the files provider
  await ref.read(dbFilesProvider.future);

  // First, generate [Progress] model for today if it does not exist
  await ref
      .read(progressRepositoryProvider.notifier)
      .generateTodaysProgressData();

  // Once generated, start the incrementor timer
  ref.read(incrementorProvider.future);

  ref.read(completedTasksRepositoryProvider.notifier).build();

  // Generate all tasks due today
  await ref.read(tasksTodayRepositoryProvider.notifier).generateTodaysTasks();

  // Schedule notifications for the next day for repeat tasks
  await ref.read(repeatingNotifsSchedulerProvider.future);

  return;
});

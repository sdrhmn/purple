import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/home/repositories/tasks_today_repo.dart';
import 'package:timely/modules/tab_3/controllers/show_completed_controller.dart';
import 'package:timely/modules/tab_3/models/ad_hoc_model.dart';
import 'package:timely/modules/tab_3/repositories/tab_3_repo.dart';

class OutputNotifier extends AutoDisposeAsyncNotifier<Map<String, dynamic>> {
  final int tabNumber = 3;
  final repositoryServiceProvider = tab3RepositoryProvider;

  @override
  FutureOr<Map<String, dynamic>> build() async {
    return await ref.read(repositoryServiceProvider.notifier).fetchModels(
          fetchCompleted: ref.watch(
            shouldFetchCompletedProvider,
          ),
        );
  }

  Future<void> deleteModel(AdHocModel model) async {
    await ref.read(repositoryServiceProvider.notifier).deleteModel(model);
    await ref.read(tasksTodayRepositoryProvider.notifier).generateTodaysTasks();
  }

  Future<void> markComplete(AdHocModel model) async {
    await ref.read(repositoryServiceProvider.notifier).markComplete(model);
  }
}

final tab3OutputProvider =
    AutoDisposeAsyncNotifierProvider<OutputNotifier, Map<String, dynamic>>(
        OutputNotifier.new);

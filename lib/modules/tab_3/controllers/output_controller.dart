import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/home/controllers/tasks_today_controller.dart';
import 'package:timely/modules/home/providers/todays_model_maps_provider.dart';
import 'package:timely/modules/tab_3/models/tab_3_model.dart';
import 'package:timely/modules/tab_3/repositories/tab_3_repo.dart';

class OutputNotifier extends AutoDisposeAsyncNotifier<Map<String, dynamic>> {
  final int tabNumber = 3;
  final repositoryServiceProvider = tab3RepositoryProvider;

  @override
  FutureOr<Map<String, dynamic>> build() async {
    return await ref.read(repositoryServiceProvider.notifier).fetchModels();
  }

  Future<void> deleteModel(Tab3Model model) async {
    await ref.read(repositoryServiceProvider.notifier).deleteModel(model);

    ref.invalidate(todaysModelMapsProvider);
    ref.invalidate(tasksTodayOutputProvider);
  }

  Future<void> markModelAsComplete(Tab3Model model) async {}
}

final tab3OutputProvider =
    AutoDisposeAsyncNotifierProvider<OutputNotifier, Map<String, dynamic>>(
        OutputNotifier.new);

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/lifestyle/health/health_models.dart';
import 'package:timely/objectbox.g.dart';
import 'package:timely/reusables.dart';

class HealthRepositoryNotifier extends AsyncNotifier<void> {
  late final Store store;

  // Boxes
  late final Box<HealthProject> healthProjectBox;
  late final Box<HealthTask> healthTaskBox;

  @override
  FutureOr<void> build() {
    store = ref.read(storeProvider).requireValue;

    // Boxes
    healthProjectBox = store.box<HealthProject>();
    healthTaskBox = store.box<HealthTask>();
  }

  // Methods

  Future<List<HealthProject>> getAllHealthProjects() async {
    return await healthProjectBox.getAllAsync();
  }

  Future<List<HealthTask>> getHealthTasks(int projectId) async {
    return await healthTaskBox
        .query(HealthTask_.healthProject.equals(projectId))
        .build()
        .findAsync();
  }

  Future<void> writeHealthProject(HealthProject project) async {
    await healthProjectBox.putAsync(project);
  }

  Future<void> writeHealthTask(HealthTask task, HealthProject project) async {
    await healthTaskBox.putAsync(task..healthProject.target = project);
  }

  Future<void> deleteHealthProject(HealthProject project) async {
    await healthProjectBox.removeAsync(project.id);
  }

  Future<void> deleteHealthTask(HealthTask task) async {
    await healthTaskBox.removeAsync(task.id);
  }
}

final healthRepositoryProvider =
    AsyncNotifierProvider<HealthRepositoryNotifier, void>(
        HealthRepositoryNotifier.new);

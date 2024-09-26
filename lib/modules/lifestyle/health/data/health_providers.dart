import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/lifestyle/health/data/health_repository.dart';
import 'package:timely/modules/lifestyle/health/health_models.dart';

final healthProjectsProvider =
    FutureProvider.autoDispose<List<HealthProject>>((ref) async {
  final repository = ref.read(healthRepositoryProvider.notifier);
  return await repository.getAllHealthProjects();
});

final healthTasksProvider = FutureProvider.autoDispose
    .family<List<HealthTask>, int>((ref, projectId) async {
  final repository = ref.read(healthRepositoryProvider.notifier);
  return await repository.getHealthTasks(projectId);
});

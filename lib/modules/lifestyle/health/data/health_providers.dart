import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/lifestyle/health/data/health_repository.dart';
import 'package:timely/modules/lifestyle/health/health_models.dart';

// FutureProvider for HealthProjects
final healthProjectsProvider =
    FutureProvider.autoDispose<List<HealthProject>>((ref) async {
  final repository = ref.watch(healthRepositoryProvider.notifier);
  return await repository.getAllHealthProjects();
});

// FutureProvider.family for HealthTasks by projectId
final healthTasksProvider = FutureProvider.autoDispose
    .family<List<HealthTask>, int>((ref, projectId) async {
  final repository = ref.watch(healthRepositoryProvider.notifier);
  // Fetch tasks for the specific project
  return await repository.getHealthTasks(projectId);
});

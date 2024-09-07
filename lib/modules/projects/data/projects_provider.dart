import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/projects/data/project_repository.dart';
import 'package:timely/modules/projects/ui/project_model.dart';

final projectsProvider = FutureProvider.autoDispose<List<Project>>((ref) async {
  return await ref.read(projectRepositoryProvider.notifier).getAllProjects();
});

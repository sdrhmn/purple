import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/projects/ui/project_model.dart';
import 'package:timely/modules/tasks/models/repetition_data_model.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/objectbox.g.dart';
import 'package:timely/reusables.dart';

class ProjectRepositoryNotifier extends AsyncNotifier<void> {
  late final Store store;
  late final Box<RepetitionData> repetitionDataBox;
  late final Box<DataTask> taskBox;
  late final Box<Project> projectBox;

  @override
  FutureOr<void> build() {
    store = ref.read(storeProvider).requireValue;
    repetitionDataBox = store.box<RepetitionData>();
    taskBox = store.box<DataTask>();
    projectBox = store.box<Project>();
  }

  // ---- Methods -----
  Future<List<Project>> getAllProjects() async {
    return await projectBox.getAllAsync();
  }

  Future<void> writeProject(Project project) async {
    await projectBox.putAsync(project);
  }

  Future<List<Task>> getProjectTasks(int projectId) async {
    final query = taskBox.query(DataTask_.project.equals(projectId));
    return (await query.build().findAsync())
        .map((task) => Task.fromDataTask(task))
        .toList();
  }

  Future<void> deleteProject(Project project) async {
    await projectBox.removeAsync(project.id);
  }

  Future<void> addTask(Task task, Project project) async {
    () {
      RepetitionData? repetitionData;
      if (task.repeatRule != null) {
        repetitionData = RepetitionData(
          id: task.repetitionDataId ?? 0,
          data: jsonEncode(task.repeatRule!.toJson()),
          task: jsonEncode(task.toJson()),
        );
        repetitionDataBox.put(repetitionData);
      }

      DataTask dataTask = DataTask(
        id: task.id ?? 0,
        dateTime: task.date
            ?.copyWith(hour: task.time?.hour, minute: task.time?.minute),
        data: jsonEncode(
          task.toJson(),
        ),
      )..repetitionData.target = repetitionData;
      project.tasks.add(dataTask);
    };
    await projectBox.putAsync(project);
  }
}

final projectRepositoryProvider =
    AsyncNotifierProvider<ProjectRepositoryNotifier, void>(
        ProjectRepositoryNotifier.new);

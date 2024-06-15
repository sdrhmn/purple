import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timely/modules/completed_tasks/task_model.dart';

class CompletedTasksRepositoryNotifier extends AsyncNotifier<void> {
  late File file;

  @override
  FutureOr<void> build() async {
    // Create the file if not already there
    String path = (await getApplicationDocumentsDirectory()).path;
    file = File('$path/completed_tasks.json');

    if (!(await file.exists())) {
      // Then create the file
      await file.create();
    }

    // If the file is empty, make it JSONable
    if ((await file.readAsString()).isEmpty) {
      file.writeAsString("{}");
    }
  }

  // Methods
  Future<Map<String, List<Task>>> fetchCompletedTasks() async {
    Map json = jsonDecode(await file.readAsString());

    // Initialize empty Map
    Map<String, List<Task>> tasks = {};

    // Get all the dates from the json file and sort them
    List dates = json.keys.toList();
    dates.sort();

    for (String date in dates.reversed) {
      tasks[date] = [];

      for (Map taskJson in json[date]!) {
        tasks[date]!.add(Task.fromJson(taskJson));
      }

      // Sort the tasks
      tasks[date]!
          .sort((a, b) => a.timestamp!.difference(b.timestamp!).inSeconds);
    }

    return tasks;
  }

  Future<void> markGloballyComplete(Task task) async {
    String dateToday = DateTime.now().toString().substring(0, 10);
    Map json = jsonDecode(await file.readAsString());

    // Add the task to db
    json[dateToday] = [...json[dateToday] ?? {}, task.toJson()];

    // Persist
    await file.writeAsString(jsonEncode(json));
  }
}

final completedTasksRepositoryProvider =
    AsyncNotifierProvider<CompletedTasksRepositoryNotifier, void>(() {
  return CompletedTasksRepositoryNotifier();
});

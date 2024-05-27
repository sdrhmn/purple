import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/home/models/task_today.dart';
import 'package:timely/modules/home/providers/todays_model_maps_provider.dart';
import 'package:timely/reusables.dart';

class TasksTodayRepositoryNotifier extends Notifier<void> {
  @override
  void build() {
    return;
  }

  Future<void> generateTodaysTasks() async {
    await _createTodaysTasks();
  }

  Future<void> _createTodaysTasks() async {
    File file = ref.read(dbFilesProvider).requireValue[0]![0];
    File completedFile = ref.read(dbFilesProvider).requireValue[0]!.last;

    Map content = jsonDecode(await file.readAsString());
    Map completedContent = jsonDecode(await completedFile.readAsString());

    String dateToday = DateTime.now().toString().substring(0, 10);

    List modelMaps = (await ref.read(todaysModelMapsProvider.future));

    List<TaskToday> tasksToday = [];

    for (Map modelMap in modelMaps) {
      // Iterate through all the completed tasks for today's date
      // If the task exists then discard it
      // Else, add it
      bool alreadyExists = false;

      for (Map completedTask in completedContent[dateToday] ?? {}) {
        if (TaskToday.fromJson(completedTask).model.uuid ==
            TaskToday.fromJson(modelMap).model.uuid) {
          alreadyExists = true;
        }
      }

      if (!alreadyExists) {
        tasksToday.add(TaskToday.fromJson(modelMap));
      }
    }

    tasksToday.sort(
      (a, b) =>
          DateTime(0, 0, 0, a.startTime.hour, a.startTime.minute).compareTo(
        DateTime(
          0,
          0,
          0,
          b.startTime.hour,
          b.startTime.minute,
        ),
      ),
    );

    content[dateToday] = tasksToday.map((e) => e.toJson()).toList();

    await file.writeAsString(jsonEncode(content));
  }

  Future<List<TaskToday>> fetchTodaysTasks() async {
    File file = ref.read(dbFilesProvider).requireValue[0]![0];
    var content = jsonDecode(await file.readAsString());

    String dateToday = DateTime.now().toString().substring(0, 10);

    List<TaskToday> tasksToday = [];

    for (Map taskJson in content[dateToday] ?? {}) {
      tasksToday.add(TaskToday.fromJson(taskJson));
    }

    return tasksToday;
  }

  Future<void> markTaskAsComplete(TaskToday model) async {
    // Get the 'completed' file
    File tasksTodayCompletedFile =
        ref.read(dbFilesProvider).requireValue[0]!.last;
    // Get the 'pending' file
    File tasksTodayFile = ref.read(dbFilesProvider).requireValue[0]!.first;

    String dateToday = DateTime.now().toString().substring(0, 10);

    Map completedContent =
        jsonDecode(await tasksTodayCompletedFile.readAsString());

    if (!completedContent.keys.contains(dateToday)) {
      completedContent[dateToday] = [];
    }

    completedContent[dateToday] = [
      ...completedContent[dateToday],
      model.toJson(),
    ];

    // Save as completed
    await tasksTodayCompletedFile.writeAsString(jsonEncode(completedContent));

    // Delete the task from 'pending'
    Map content = jsonDecode(await tasksTodayFile.readAsString());
    for (String date in content.keys) {
      for (int i in Iterable.generate(content[date]!.length)) {
        TaskToday task = TaskToday.fromJson(content[date]![i]);
        if (task.model.uuid == model.model.uuid) {
          content[date]!.removeAt(i);
          break;
        }
      }
    }

    // If any dates are empty, delete them
    content.removeWhere((key, value) => value.isEmpty);

    // Persist
    await tasksTodayFile.writeAsString(jsonEncode(content));
  }
}

final tasksTodayRepositoryProvider =
    NotifierProvider<TasksTodayRepositoryNotifier, void>(
        TasksTodayRepositoryNotifier.new);

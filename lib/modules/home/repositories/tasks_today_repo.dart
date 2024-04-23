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
    File file = ref.read(dbFilesProvider).requireValue[0]![0];
    var content = jsonDecode(await file.readAsString());

    String dateToday = DateTime.now().toString().substring(0, 10);

    if (!content.keys.contains(dateToday)) {
      await createTodaysTasks();
    }
  }

  Future<void> createTodaysTasks() async {
    File file = ref.read(dbFilesProvider).requireValue[0]![0];
    var content = jsonDecode(await file.readAsString());

    String dateToday = DateTime.now().toString().substring(0, 10);

    List modelMaps = (await ref.read(todaysModelMapsProvider.future));

    List<TaskToday> tasksToday = [];

    for (Map modelMap in modelMaps) {
      tasksToday.add(TaskToday.fromJson(modelMap));
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

    file.writeAsString(jsonEncode(content));
  }

  Future<List<TaskToday>> fetchTodaysTasks() async {
    File file = ref.read(dbFilesProvider).requireValue[0]![0];
    var content = jsonDecode(await file.readAsString());

    String dateToday = DateTime.now().toString().substring(0, 10);

    List<TaskToday> tasksToday = [];

    for (Map taskJson in content[dateToday]) {
      tasksToday.add(TaskToday.fromJson(taskJson));
    }

    return tasksToday;
  }
}

final tasksTodayRepositoryProvider =
    NotifierProvider<TasksTodayRepositoryNotifier, void>(
        TasksTodayRepositoryNotifier.new);

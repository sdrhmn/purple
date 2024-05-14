import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/common/scheduling/scheduling_repository.dart';
import 'package:timely/modules/home/controllers/tasks_today_controller.dart';
import 'package:timely/modules/home/providers/todays_model_maps_provider.dart';
import 'package:timely/reusables.dart';

// This is the tab 2 output controller.
// You will see this controller being used in tabs 2, 6 and 7.
// This is because all three tabs share the same methods of fetching and deleting
// the entries so it is useful to separate the common parts between them instead
// of creating three controllers that do exactly the same thing.
// Here, we only create the class. We create the providers inside the tab folders.

class SchedulingOutputNotifier<T>
    extends AutoDisposeAsyncNotifier<Map<String, List<SchedulingModel>>> {
  SchedulingOutputNotifier(this.tabNumber);

  final int tabNumber;
  late File pendingFile;
  late File completedFile;
  late File currentFile;

  @override
  FutureOr<Map<String, List<SchedulingModel>>> build() async {
    pendingFile = (await ref.read(dbFilesProvider.future))[tabNumber]![0];
    completedFile = (await ref.read(dbFilesProvider.future))[tabNumber]![1];
    currentFile = (await ref.read(dbFilesProvider.future))[tabNumber]!.last;

    var models = await ref
        .read(schedulingRepositoryServiceProvider.notifier)
        .fetchActivities(SchedulingModel.fromJson, pendingFile);

    return models;
  }

  Future<TimeOfDay> fetchSleepTime() async {
    pendingFile = (await ref.read(dbFilesProvider.future))[tabNumber]![0];
    List<SchedulingModel> models = await ref
        .read(schedulingRepositoryServiceProvider.notifier)
        .getActivitiesForToday(SchedulingModel.fromJson, pendingFile);

    late SchedulingModel sleep;
    for (SchedulingModel model in models) {
      if (model.name == "Sleep") {
        sleep = model;
        break;
      }
    }

    return sleep.startTime;
  }

  Future<void> deleteModel(SchedulingModel model) async {
    pendingFile = (await ref.read(dbFilesProvider.future))[tabNumber]![0];
    completedFile = (await ref.read(dbFilesProvider.future))[tabNumber]![1];
    currentFile = (await ref.read(dbFilesProvider.future))[tabNumber]!.last;

    await ref
        .read(schedulingRepositoryServiceProvider.notifier)
        .deleteModel(model, pendingFile);

    ref.invalidate(todaysModelMapsProvider);
    ref.invalidate(tasksTodayOutputProvider);
  }
}

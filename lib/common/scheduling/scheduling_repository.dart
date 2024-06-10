import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/repos_and_controllers.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/reusables.dart';

class SchedulingRepostioryNotifier<T>
    extends ListStructRepositoryNotifier<SchedulingModel> {
  //
  //
  // ------------------------------------------------------------

  Future<Map<String, List<SchedulingModel>>> fetchActivities(
      Function modelizer, File file) async {
    // Get the models
    List models = await fetchModels(modelizer, file);

    List<SchedulingModel> activitiesForToday = [];
    List<SchedulingModel> upcomingActivities = [];

    for (final SchedulingModel model in models) {
      DateTime nextDate = model.getNextOccurenceDateTime();
      if (DateTime(nextDate.year, nextDate.month, nextDate.day) ==
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)) {
        activitiesForToday.add(model);
      } else if (DateTime(nextDate.year, nextDate.month, nextDate.day).isAfter(
            DateTime.now(),
          ) &&
          nextDate != DateTime(0)) {
        upcomingActivities.add(model);
      }
    }

    activitiesForToday.sort((a, b) {
      return DateTime(0, 0, 0, a.startTime.hour, a.startTime.minute)
          .difference(
            DateTime(0, 0, 0, b.startTime.hour, b.startTime.minute),
          )
          .inSeconds;
    });

    upcomingActivities.sort((a, b) {
      return DateTime(0, 0, 0, a.startTime.hour, a.startTime.minute)
          .difference(
            DateTime(0, 0, 0, b.startTime.hour, b.startTime.minute),
          )
          .inSeconds;
    });

    return {
      "today": activitiesForToday,
      "upcoming": upcomingActivities,
    };
  }

  Future<List<SchedulingModel>> getActivitiesByDate(
      Function modelizer, File file, DateTime date,
      {DateTime? startDate}) async {
    // Get the models
    List models = await fetchModels(modelizer, file);

    List<SchedulingModel> filteredModels = [];
    for (final SchedulingModel model in models) {
      DateTime nextDate = model.getNextOccurenceDateTime(st: startDate);
      if (DateTime(nextDate.year, nextDate.month, nextDate.day) == date) {
        filteredModels.add(model);
      }
    }
    return filteredModels;
  }

  Future<List<SchedulingModel>> getActivitiesForToday(
      Function modelizer, File file) async {
    // Get the models
    List models = await fetchModels(modelizer, file);

    List<SchedulingModel> filteredModels = [];
    for (final SchedulingModel model in models) {
      DateTime nextDate = model.getNextOccurenceDateTime();
      if (DateTime(nextDate.year, nextDate.month, nextDate.day) ==
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)) {
        filteredModels.add(model);
      }
    }
    return filteredModels;
  }

  Future<void> generateActivitiesForToday(
      int tabNumber, Function modelizer) async {
    // Grab the files
    final currentActivitiesFile =
        (await ref.read(dbFilesProvider.future))[tabNumber]!.last;
    final pendingFile =
        (await ref.read(dbFilesProvider.future))[tabNumber]!.first;

    // Save to the file
    await currentActivitiesFile.writeAsString(
        jsonEncode(await getActivitiesForToday(modelizer, pendingFile)));
  }
}

final schedulingRepositoryServiceProvider =
    NotifierProvider<SchedulingRepostioryNotifier<SchedulingModel>, void>(
        SchedulingRepostioryNotifier.new);

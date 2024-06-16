import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/common/scheduling/scheduling_repository.dart';
import 'package:timely/modules/tab_3/repositories/tab_3_repo.dart';
import 'package:timely/modules/tab_3/models/ad_hoc_model.dart';
import 'package:timely/reusables.dart';

// Get all entries from all tabs
// Separate them into timed, untimed, and non-scheduled
// The timed ones will be sorted
// For [Tab2Model]s, use the getNextOccurenceDateTime function
final todaysModelMapsProvider = FutureProvider.autoDispose<List>((ref) async {
  List modelMaps = [];

  // Fetch all models
  List datas = await Future.wait(
    [
      ref.read(schedulingRepositoryServiceProvider.notifier).fetchModels(
          SchedulingModel.fromJson,
          ref.read(dbFilesProvider).requireValue[2]![0]),
      ref.read(tab3RepositoryProvider.notifier).fetchModels(),
      ref.read(schedulingRepositoryServiceProvider.notifier).fetchModels(
          SchedulingModel.fromJson,
          ref.read(dbFilesProvider).requireValue[6]![0]),
    ],
  );

  // Tabs 2, 6 and 7
  for (SchedulingModel model in datas[0]) {
    var nextDateTime = model.getNextOccurrenceDateTime();
    var now = DateTime.now();
    if ("${now.year} ${now.month} ${now.day}" ==
            "${nextDateTime.year} ${nextDateTime.month} ${nextDateTime.day}" &&
        !model.name!.contains("Sleep")) {
      modelMaps.add({
        "Tab Number": 2,
        "Data": model.toJson(),
      });
    }
  }

  for (SchedulingModel model in datas.last) {
    var nextDateTime = model.getNextOccurrenceDateTime();
    var now = DateTime.now();
    if ("${now.year} ${now.month} ${now.day}" ==
            "${nextDateTime.year} ${nextDateTime.month} ${nextDateTime.day}" &&
        !model.name!.contains("This is a sample entry that repeats daily.")) {
      modelMaps.add(
        {
          "Tab Number": 6,
          "Data": model.toJson(),
        },
      );
    }
  }

  // Tab 3
  Map tab3Data = datas[1];
  String dateToday = DateFormat("yyyy-MM-dd").format(DateTime.now());

  for (String date in tab3Data["scheduled"].keys) {
    if (date == dateToday) {
      for (AdHocModel model in tab3Data["scheduled"][date]) {
        if (!model.name.contains("This is a sample entry.")) {
          modelMaps.add({
            "Tab Number": 3,
            "Data": {
              ...model.toJson(),
              "Start Date": date,
            },
          });
        }
      }
    }
  }

  return modelMaps;
});

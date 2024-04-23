import 'dart:io';

import 'package:timely/common/repos_and_controllers.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/modules/tab_12/models/entry_model.dart';
import 'package:timely/modules/tab_12/models/sub_entry_model.dart';

class Tab12RepositoryNotifier extends EntryStructPendingRepositoryNotifier<
    Tab12EntryModel, Tab12SubEntryModel> {
  // --------- --------- --------- --------- --------- --------- ---------

  Future<Map<Tab12EntryModel, List<Tab12SubEntryModel>>>
      fetchFilteredEntriesAndSubEntries(
    File file,
  ) async {
    Map<Tab12EntryModel, List<Tab12SubEntryModel>> entriesAndSubEntries =
        await fetchEntriesAndSubEntries(
            file, Tab12EntryModel.fromJson, Tab12SubEntryModel.fromJson);

    // We need to check the entry
    // If it falls today, then add to the filtered variable.

    Map<Tab12EntryModel, List<Tab12SubEntryModel>> filtered = {};

    for (Tab12EntryModel entry in entriesAndSubEntries.keys) {
      SchedulingModel model = entry.tab2Model;
      DateTime nextDate = model.getNextOccurenceDateTime();

      if (DateTime(nextDate.year, nextDate.month, nextDate.day) ==
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)) {
        filtered[entry] = entriesAndSubEntries[entry]!;
      }
    }

    return filtered;
  }
}

final tab12RepositoryProvider =
    NotifierProvider<Tab12RepositoryNotifier, void>(() {
  return Tab12RepositoryNotifier();
});

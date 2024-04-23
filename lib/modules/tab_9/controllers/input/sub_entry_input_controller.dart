import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timely/modules/tab_9/controllers/output/output_controller.dart';
import 'package:timely/modules/tab_9/models/entry_model.dart';
import 'package:timely/modules/tab_9/models/sub_entry_model.dart';
import 'package:timely/modules/tab_9/repositories/tab_9_repo.dart';
import 'package:timely/reusables.dart';

class Tab9SubEntryInputNotifier extends Notifier<Tab9SubEntryModel> {
  @override
  build() {
    return Tab9SubEntryModel(
      date: DateTime.now(),
      time: [TimeOfDay.now().hour, TimeOfDay.now().minute].join(":"),
      task: "",
      description: "",
    );
  }

  void setDate(DateTime date) => state = state.copyWith(date: date);
  void setTime(String time) => state = state.copyWith(time: time);
  void setTask(String task) => state = state.copyWith(task: task);
  void setDescription(String description) =>
      state = state.copyWith(description: description);
  String getFormattedDate() =>
      DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(state.date);
  void setModel(model) => state = model;

  Future<void> syncToDB(String entryUuid) async {
    final file = (await ref.read(dbFilesProvider.future))[9]![0];

    if (state.uuid != null) {
      await ref
          .read(tab9RepositoryProvider.notifier)
          .updateSubEntry(entryUuid, state, file, Tab9EntryModel.fromJson);
    } else {
      await ref.read(tab9RepositoryProvider.notifier).writeSubEntry(
          entryUuid,
          state,
          file,
          null,
          Tab9EntryModel.fromJson,
          Tab9SubEntryModel.fromJson);
    }

    ref.invalidate(tab9OutputProvider);
  }
}

final tab9SubEntryInputProvider =
    NotifierProvider<Tab9SubEntryInputNotifier, Tab9SubEntryModel>(() {
  return Tab9SubEntryInputNotifier();
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/modules/tab_12/controllers/input/entry_input_controller.dart';
import 'package:timely/modules/tab_12/controllers/output/output_controller.dart';
import 'package:timely/modules/tab_12/models/entry_model.dart';
import 'package:timely/modules/tab_12/models/sub_entry_model.dart';
import 'package:timely/modules/tab_12/repositories/tab_12_repo.dart';
import 'package:timely/reusables.dart';

class Tab12SubEntryInputNotifier extends Notifier<Tab12SubEntryModel> {
  @override
  Tab12SubEntryModel build() {
    return Tab12SubEntryModel(
        nextTask: "",
        date: ref
            .watch(tab12EntryInputProvider)
            .tab2Model
            .getNextOccurrenceDateTime()
            .copyWith(
                hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0));
  }

  // Setters
  void setNextTask(nextTask) {
    state = state.copyWith(nextTask: nextTask);
  }

  void setDate(date) {
    state = state.copyWith(date: date);
  }

  void setModel(model) {
    state = model;
  }

  Future<void> syncToDB(String entryUuid) async {
    final file = (await ref.read(dbFilesProvider.future))[12]![0];

    if (state.uuid != null) {
      await ref
          .read(tab12RepositoryProvider.notifier)
          .updateSubEntry(entryUuid, state, file, Tab12EntryModel.fromJson);
    } else {
      await ref.read(tab12RepositoryProvider.notifier).writeSubEntry(
            entryUuid,
            state,
            file,
            null,
            Tab12EntryModel.fromJson,
            SchedulingModel.fromJson,
          );
    }

    ref.invalidate(tab12OutputProvider);
  }
}

final tab12SubEntryInputProvider =
    NotifierProvider<Tab12SubEntryInputNotifier, Tab12SubEntryModel>(
        Tab12SubEntryInputNotifier.new);

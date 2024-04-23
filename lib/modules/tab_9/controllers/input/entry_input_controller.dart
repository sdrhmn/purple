import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_9/controllers/output/output_controller.dart';
import 'package:timely/modules/tab_9/models/entry_model.dart';
import 'package:timely/modules/tab_9/models/sub_entry_model.dart';
import 'package:timely/modules/tab_9/repositories/tab_9_repo.dart';
import 'package:timely/reusables.dart';

class Tab9InputNotifier extends Notifier<Tab9EntryModel> {
  @override
  build() {
    return const Tab9EntryModel(
      condition: "",
      criticality: 1,
      care: "",
      lessonLearnt: "",
    );
  }

  void setCondition(String condition) =>
      state = state.copyWith(condition: condition);
  void setCriticality(int criticality) {
    state = state.copyWith(criticality: criticality);
  }

  void setCare(String care) => state = state.copyWith(care: care);
  void setLessonLearnt(String lessonLearnt) =>
      state = state.copyWith(lessonLearnt: lessonLearnt);
  void setModel(model) => state = model;

  Future<void> syncToDB(Tab9SubEntryModel subEntry) async {
    final file = (await ref.read(dbFilesProvider.future))[9]![0];

    if (state.uuid != null) {
      await ref
          .read(tab9RepositoryProvider.notifier)
          .updateEntry(state, file, Tab9EntryModel.fromJson);
    } else {
      await ref
          .read(tab9RepositoryProvider.notifier)
          .writeEntry(state, file, [subEntry]);
    }

    ref.invalidate(tab9OutputProvider);
  }
}

final tab9EntryInputProvider =
    NotifierProvider<Tab9InputNotifier, Tab9EntryModel>(() {
  return Tab9InputNotifier();
});

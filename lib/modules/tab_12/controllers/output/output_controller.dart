import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/repos_and_controllers.dart';
import 'package:timely/modules/tab_12/models/entry_model.dart';
import 'package:timely/modules/tab_12/models/sub_entry_model.dart';
import 'package:timely/modules/tab_12/repositories/tab_12_repo.dart';
import 'package:timely/reusables.dart';

class Tab12OutputNotifier extends EntryStructOutputNotifier<Tab12EntryModel,
    Tab12SubEntryModel, Tab12RepositoryNotifier> {
  Tab12OutputNotifier(
      {required super.repoService,
      required super.entryModelizer,
      required super.subEntryModelizer});

  @override
  FutureOr<Map<Tab12EntryModel, List<Tab12SubEntryModel>>> build() async {
    pendingFile = (await ref.read(dbFilesProvider.future))[12]![0];
    completedFile = (await ref.read(dbFilesProvider.future))[12]![1];

    Map<Tab12EntryModel, List<Tab12SubEntryModel>> res = (await ref
        .read(repoService.notifier)
        .fetchEntriesAndSubEntries(pendingFile, Tab12EntryModel.fromJson,
            Tab12SubEntryModel.fromJson));

    return Map.fromEntries(res.entries.toList()
      ..sort((e1, e2) => e1.key.tab2Model
          .getNextOccurenceDateTime()
          .compareTo(e2.key.tab2Model.getNextOccurenceDateTime())));
  }
}

final tab12OutputProvider = AutoDisposeAsyncNotifierProvider<
    Tab12OutputNotifier, Map<Tab12EntryModel, List<Tab12SubEntryModel>>>(() {
  return Tab12OutputNotifier(
    repoService: tab12RepositoryProvider,
    entryModelizer: Tab12EntryModel.fromJson,
    subEntryModelizer: Tab12SubEntryModel.fromJson,
  );
});

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_12/models/entry_model.dart';
import 'package:timely/modules/tab_12/models/sub_entry_model.dart';
import 'package:timely/modules/tab_12/repositories/tab_12_repo.dart';
import 'package:timely/reusables.dart';

final tab12ArchivedProvider =
    FutureProvider<Map<Tab12EntryModel, List<Tab12SubEntryModel>>>((ref) async {
  final file = (await ref.read(dbFilesProvider.future))[12]![1];

  return await ref
      .read(tab12RepositoryProvider.notifier)
      .fetchEntriesAndSubEntries(
          file, Tab12EntryModel.fromJson, Tab12SubEntryModel.fromJson);
});

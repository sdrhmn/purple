import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/repos_and_controllers.dart';
import 'package:timely/modules/tab_9/models/entry_model.dart';
import 'package:timely/modules/tab_9/models/sub_entry_model.dart';
import 'package:timely/modules/tab_9/repositories/tab_9_repo.dart';

final tab9OutputProvider = AutoDisposeAsyncNotifierProvider<
    EntryStructOutputNotifier<Tab9EntryModel, Tab9SubEntryModel,
        EntryStructPendingRepositoryNotifier>,
    Map<Tab9EntryModel, List<Tab9SubEntryModel>>>(() {
  return EntryStructOutputNotifier(
      repoService: tab9RepositoryProvider,
      entryModelizer: Tab9EntryModel.fromJson,
      subEntryModelizer: Tab9SubEntryModel.fromJson);
});

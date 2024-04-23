import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_9/models/entry_model.dart';
import 'package:timely/modules/tab_9/models/sub_entry_model.dart';
import 'package:timely/common/repos_and_controllers.dart';

final tab9RepositoryProvider = NotifierProvider<
    EntryStructPendingRepositoryNotifier<Tab9EntryModel, Tab9SubEntryModel>,
    void>(() {
  return EntryStructPendingRepositoryNotifier();
});

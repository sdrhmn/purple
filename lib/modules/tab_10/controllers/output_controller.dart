import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/repos_and_controllers.dart';
import 'package:timely/modules/tab_10/repositories/tab_10_repositories.dart';
import 'package:timely/modules/tab_10/models/tab_10_model.dart';

final tab10OutputProvider = AutoDisposeAsyncNotifierProvider<
    OutputNotifier<Tab10Model>, List<Tab10Model>>(() {
  return OutputNotifier(
    tabNumber: 10,
    modelizer: Tab10Model.fromJson,
    repositoryServiceProvider: tab10RepositoryProvider,
  );
});

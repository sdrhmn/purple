import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/repos_and_controllers.dart';
import 'package:timely/modules/tab_11/models/tab_11_model.dart';
import 'package:timely/modules/tab_11/repositories/tab_11_repo.dart';

final tab11OutputProvider = AutoDisposeAsyncNotifierProvider<
    OutputNotifier<Tab11Model>, List<Tab11Model>>(() {
  return OutputNotifier(
      tabNumber: 11,
      modelizer: Tab11Model.fromJson,
      repositoryServiceProvider: tab11RepositoryProvider);
});

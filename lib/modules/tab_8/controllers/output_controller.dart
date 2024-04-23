import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/repos_and_controllers.dart';
import 'package:timely/modules/tab_8/models/tab_8_model.dart';
import 'package:timely/modules/tab_8/repositories/tab_8_repo.dart';

final tab8OutputProvider = AutoDisposeAsyncNotifierProvider<
    OutputNotifier<Tab8Model>, List<Tab8Model>>(() {
  return OutputNotifier(
    tabNumber: 8,
    modelizer: Tab8Model.fromJson,
    repositoryServiceProvider: tab8RepositoryProvider,
  );
});

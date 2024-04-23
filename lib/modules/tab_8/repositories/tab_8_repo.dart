import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/repos_and_controllers.dart';
import 'package:timely/modules/tab_8/models/tab_8_model.dart';

final tab8RepositoryProvider =
    NotifierProvider<ListStructRepositoryNotifier<Tab8Model>, void>(
        ListStructRepositoryNotifier.new);

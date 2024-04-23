import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/repos_and_controllers.dart';
import 'package:timely/modules/tab_11/models/tab_11_model.dart';

final tab11RepositoryProvider =
    NotifierProvider<ListStructRepositoryNotifier<Tab11Model>, void>(
        ListStructRepositoryNotifier.new);

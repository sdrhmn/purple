import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/lifestyle/kpi/kpi_model.dart';
import 'package:timely/objectbox.g.dart';
import 'package:timely/reusables.dart';

class KpiRepositoryNotifier extends AsyncNotifier<void> {
  late final Store store;
  late final Box<KPIModel> box;

  @override
  FutureOr<void> build() {
    store = ref.read(storeProvider).requireValue;
    box = store.box<KPIModel>();
  }

  // Methods
  write(KPIModel model) {
    box.put(model);
  }

  List<KPIModel> getAll() {
    return box.getAll();
  }
}

final kpiRepositoryProvider =
    AsyncNotifierProvider<KpiRepositoryNotifier, void>(
        KpiRepositoryNotifier.new);

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

  Future<void> write(KPIModel model) async {
    final query = box.query(KPIModel_.date.equalsDate(model.date)).build();
    KPIModel? previous = (await query.findAsync()).firstOrNull;
    if (previous != null) {
      model.id = previous.id;
    }
    box.put(model);
  }

  Future<void> delete(int id) async {
    box.remove(id);
  }

  Future<List<KPIModel>> getAll() async {
    return await box.getAllAsync();
  }
}

final kpiRepositoryProvider =
    AsyncNotifierProvider<KpiRepositoryNotifier, void>(
        KpiRepositoryNotifier.new);

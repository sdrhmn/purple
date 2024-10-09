import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/lifestyle/kpi/kpi_model.dart';
import 'package:timely/modules/tasks/ui/tabs/lifestyle_status_info_provider.dart';
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
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    // Find a matching model with the same date using a more efficient single lookup
    final previousId = box
        .query(KPIModel_.date.between(
            startOfDay.millisecondsSinceEpoch, now.millisecondsSinceEpoch))
        .build()
        .findFirst()
        ?.id;

    // If a previous model exists, use its ID to update the existing record
    if (previousId != null) {
      model.id = previousId;
    }

    // Put will insert or update the model based on the ID (existing or new)
    box.put(model);

    ref.invalidate(lifestyleStatusInfoProvider);
  }

  Future<void> delete(int id) async {
    box.remove(id);

    ref.invalidate(lifestyleStatusInfoProvider);
  }

  Future<List<KPIModel>> getAll() async {
    return await box.getAllAsync();
  }

  // Get Status Info for KPI
  Future<List<dynamic>> getStatusInfo() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final query = box
        .query(KPIModel_.date.between(
            startOfDay.millisecondsSinceEpoch, now.millisecondsSinceEpoch))
        .build();

    final entriesToday = await query.findAsync();
    final lastEntry = box
        .query()
        .order(KPIModel_.date, flags: Order.descending)
        .build()
        .findFirst();

    return [
      entriesToday.isNotEmpty, // Status: true if any entry today
      lastEntry?.date // Last entry's date
    ];
  }
}

final kpiRepositoryProvider =
    AsyncNotifierProvider<KpiRepositoryNotifier, void>(
        KpiRepositoryNotifier.new);

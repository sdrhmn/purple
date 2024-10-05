import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/lifestyle/controls/controls_model.dart';
import 'package:timely/objectbox.g.dart';
import 'package:timely/reusables.dart';

class ControlsRepositoryNotifier extends AsyncNotifier<void> {
  late final Store store;
  late final Box<ControlsModel> box;

  @override
  FutureOr<void> build() {
    store = ref.read(storeProvider).requireValue;
    box = store.box<ControlsModel>();
  }

  // Methods
  Future<void> write(ControlsModel model) async {
    final query = box.query(ControlsModel_.date.equalsDate(model.date)).build();
    ControlsModel? previous = (await query.findAsync()).firstOrNull;
    if (previous != null) {
      model.id = previous.id;
    }
    box.put(model);
  }

  Future<List<ControlsModel>> getAll() async {
    return await box.getAllAsync();
  }

  Future<void> delete(int id) async {
    await box.removeAsync(id);
  }

  // Get Status Info for Controls
  Future<List<dynamic>> getStatusInfo() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final query = box
        .query(ControlsModel_.date.between(
            startOfDay.millisecondsSinceEpoch, now.millisecondsSinceEpoch))
        .build();

    final entriesToday = await query.findAsync();
    final lastEntry = box
        .query()
        .order(ControlsModel_.date, flags: Order.descending)
        .build()
        .findFirst();

    return [
      entriesToday.isNotEmpty, // Status: true if any entry today
      lastEntry?.date // Last entry's date
    ];
  }
}

final controlsRepositoryProvider =
    AsyncNotifierProvider<ControlsRepositoryNotifier, void>(
        ControlsRepositoryNotifier.new);

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
}

final controlsRepositoryProvider =
    AsyncNotifierProvider<ControlsRepositoryNotifier, void>(
        ControlsRepositoryNotifier.new);

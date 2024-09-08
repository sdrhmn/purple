import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/lifestyle/controls/controls_model.dart';
import 'package:timely/modules/lifestyle/controls/data/controls_repository.dart';

final controlsModelsProvider =
    FutureProvider.autoDispose<List<ControlsModel>>((ref) async {
  return await ref.read(controlsRepositoryProvider.notifier).getAll();
});

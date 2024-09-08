import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/lifestyle/kpi/kpi_model.dart';
import 'package:timely/modules/lifestyle/kpi/data/kpi_repository.dart';

final kpiModelsProvider =
    FutureProvider.autoDispose<List<KPIModel>>((ref) async {
  return await ref.read(kpiRepositoryProvider.notifier).getAll();
});

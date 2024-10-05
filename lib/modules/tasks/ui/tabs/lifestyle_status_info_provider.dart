import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/lifestyle/controls/data/controls_repository.dart';
import 'package:timely/modules/lifestyle/diary/data/diary_repository.dart';
import 'package:timely/modules/lifestyle/health/data/health_repository.dart';
import 'package:timely/modules/lifestyle/kpi/data/kpi_repository.dart';

final lifestyleStatusInfoProvider =
    FutureProvider.autoDispose<List<List<dynamic>>>((ref) async {
  final kpiRepo = ref.read(kpiRepositoryProvider.notifier);
  final controlsRepo = ref.read(controlsRepositoryProvider.notifier);
  final healthRepo = ref.read(healthRepositoryProvider.notifier);
  final diaryRepo = ref.read(diaryRepositoryProvider.notifier);

  final statusInfo = await Future.wait([
    kpiRepo.getStatusInfo(),
    controlsRepo.getStatusInfo(),
    healthRepo.getStatusInfo(),
    diaryRepo.getStatusInfo(),
  ]);

  return statusInfo; // List of [status, lastEntryDate] for each component
});

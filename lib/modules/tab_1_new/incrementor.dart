import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_1_new/history_provider.dart';
import 'package:timely/modules/tab_1_new/model_provider.dart';
import 'package:timely/modules/tab_1_new/repository.dart';

final incrementorProvider = FutureProvider<void>((ref) async {
  bool incremented = await ref
      .read(progressRepositoryProvider.notifier)
      .incrementPointsByCheckingTime();
  if (incremented) {
    ref.invalidate(progressModelController);
  }

  Timer.periodic(const Duration(seconds: 10), (timer) async {
    bool incremented = await ref
        .read(progressRepositoryProvider.notifier)
        .incrementPointsByCheckingTime();
    if (incremented) {
      ref.invalidate(progressModelController);
      ref.invalidate(historyProvider);
    }
  });
});

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_1_new/model.dart';
import 'package:timely/modules/tab_1_new/repository.dart';

class ProgressModelNotifier extends AsyncNotifier<Progress> {
  @override
  FutureOr<Progress> build() async {
    return ref.read(progressRepositoryProvider.notifier).fetchTodaysProgress();
  }

  // Methods
  Future<void> pause(String letter, int? action) async {
    if (action != null) {
      if (action == 0) {
        Map<String, DateTime> paused = state.requireValue.paused;
        paused.addAll({letter: DateTime.now()});
        await ref.read(progressRepositoryProvider.notifier).updateProgress(
              state.requireValue.copyWith(paused: paused),
            );
      }
      // Action is "Stop"
      else {
        List<String> stopped = state.requireValue.stopped;
        stopped.add(letter);
        await ref.read(progressRepositoryProvider.notifier).updateProgress(
              state.requireValue.copyWith(stopped: stopped),
            );
      }
      ref.invalidateSelf();
    }
  }

  Future<void> setLevel(int level) async {
    await ref.read(progressRepositoryProvider.notifier).updateProgress(
          state.requireValue.copyWith(level: level),
        );
    ref.invalidateSelf();
  }
}

final progressModelController =
    AsyncNotifierProvider<ProgressModelNotifier, Progress>(
        ProgressModelNotifier.new);

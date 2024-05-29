import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/home/controllers/tasks_today_controller.dart';
import 'package:timely/modules/home/repositories/tasks_today_repo.dart';
import 'package:timely/modules/tab_3/controllers/output_controller.dart';
import 'package:timely/modules/tab_3/models/tab_3_model.dart';
import 'package:timely/modules/tab_3/repositories/tab_3_repo.dart';

class Tab3InputNotifier extends Notifier<Tab3Model> {
  @override
  Tab3Model build() {
    return Tab3Model(
      text_1: "",
      priority: 1,
      time: TimeOfDay.now(),
      date: DateTime.now(),
    );
  }

  setActivity(String activity) {
    state.text_1 = activity;
  }

  setDate(DateTime date) {
    state = state.copyWith(date: date);
  }

  setTime(TimeOfDay time) {
    state = state.copyWith(time: time);
  }

  void setPriority(int index) {
    state = state.copyWith(priority: index);
  }

  void removeDateAndTime() {
    state.date = null;
    state.time = null;
  }

  Future<void> syncToDB() async {
    state.uuid == null
        ? await (ref.read(tab3RepositoryProvider.notifier).writeModel(state))
        : await (ref.read(tab3RepositoryProvider.notifier).editModel(state));

    ref.invalidate(tab3OutputProvider);

    await ref.read(tasksTodayRepositoryProvider.notifier).generateTodaysTasks();
    ref.invalidate(tasksTodayOutputProvider);
  }

  void setModel(Tab3Model model) async {
    state = model;
  }
}

final tab3InputProvider =
    NotifierProvider<Tab3InputNotifier, Tab3Model>(Tab3InputNotifier.new);

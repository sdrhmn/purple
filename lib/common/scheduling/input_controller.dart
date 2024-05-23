import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/home/controllers/tasks_today_controller.dart';
import 'package:timely/modules/home/providers/todays_model_maps_provider.dart';
import 'package:timely/modules/home/repositories/tasks_today_repo.dart';
import 'package:timely/modules/tab_2/controllers/output_controller.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/common/scheduling/scheduling_repository.dart';
import 'package:timely/modules/tab_6/controllers/output_controller.dart';
import 'package:timely/modules/tab_7/controllers/output_controller.dart';
import 'package:timely/reusables.dart';

// This tab 2 input controller allows the user to create new tasks
// It stores the information the user selects and persists it to the database
// That is all it does
// For storing the information, it has setters such as setName, etc.

class SchedulingInputNotifier extends Notifier<SchedulingModel> {
  @override
  SchedulingModel build() {
    return SchedulingModel(
      basis: Basis.day,
      startDate: DateTime.now(),
      frequency: "Daily",
      name: "",
      startTime: TimeOfDay.now(),
      dur: const Duration(hours: 0, minutes: 0),
      repetitions: {
        "DoW": [0, 0]
      },
      every: 1,
    );
  }

  // Setters
  void setName(name) {
    state = state.copyWith(name: name);
  }

  void setStartDate(date) {
    state = state.copyWith(startDate: date);
  }

  void setStartTime(startTime) {
    state = state.copyWith(startTime: startTime);
  }

  void setDuration(Duration dur) {
    state = state.copyWith(dur: dur);
  }

  void setFrequency(frequency) {
    state = state.copyWith(frequency: frequency);

    // Set the default values based on selection
    switch (frequency) {
      case "Monthly":
        if (state.basis == null) {
          setBasis(Basis.day);
        }

        setRepetitions({
          "Dates": [],
          "DoW": [0, 0]
        });
        break;

      case "Yearly":
        if (state.basis == null) {
          setBasis(Basis.day);
        }

        setRepetitions({
          "Months": [],
          "DoW": [0, 0]
        });

      case "Weekly":
        resetBasis();
        setRepetitions({"Weekdays": []});

      case "Daily":
        if (state.basis == null) {
          setBasis(Basis.day);
        }

        setRepetitions({});
    }
  }

  void resetBasis() {
    state.basis = null;
  }

  void setBasis(basis) {
    state = state.copyWith(basis: basis);
    if (basis == Basis.day) {
      setRepetitions({
        ...state.repetitions,
        "DoW": [0, 0],
      });
    }
  }

  void setWeeklyRepetitions(List<int> weekdayIndices) {
    state = state.copyWith(repetitions: {"Weekdays": weekdayIndices});
  }

  void setMonthlyRepetitions(List<int> dates) {
    state = state.copyWith(
      repetitions: {
        ...state.repetitions,
        "Dates": dates,
      },
    );
  }

  void setYearlyRepetitions(List<int> monthIndices) {
    state = state.copyWith(
      repetitions: {
        ...state.repetitions,
        "Months": monthIndices,
      },
    );
  }

  void setOrdinalPosition(int pos) {
    state = state.copyWith(
      repetitions: {
        ...state.repetitions,
        "DoW": [
          pos,
          state.repetitions["DoW"][1],
        ],
      },
    );
  }

  void setWeekdayIndex(int index) {
    state = state.copyWith(
      repetitions: {
        ...state.repetitions,
        "DoW": [
          state.repetitions["DoW"][0],
          index,
        ],
      },
    );
  }

  void setRepetitions(Map repetitions) {
    state = state.copyWith(repetitions: repetitions);
  }

  void setEvery(int every) {
    state = state.copyWith(every: every);
  }

  void setEndDate(endDate) {
    state = state.copyWith(endDate: endDate);
  }

  void setModel(SchedulingModel model) {
    state = model;
  }

  // Methods
  Future<void> syncToDB(tabNumber) async {
    final file = (await ref.read(dbFilesProvider.future))[tabNumber]![0];
    await ref
        .read(schedulingRepositoryServiceProvider.notifier)
        .writeModel(state, file);

    for (final provider in [
      tab2OutputProvider,
      tab6OutputProvider,
      tab7OutputProvider,
    ]) {
      ref.invalidate(provider);
    }

    await ref.read(tasksTodayRepositoryProvider.notifier).generateTodaysTasks();
    ref.invalidate(tasksTodayOutputProvider);
  }

  Future<void> syncEditedModel(tabNumber) async {
    final file = (await ref.read(dbFilesProvider.future))[tabNumber]![0];
    await ref
        .read(schedulingRepositoryServiceProvider.notifier)
        .editModel(state, file);

    for (final provider in [
      tab2OutputProvider,
      tab6OutputProvider,
      tab7OutputProvider,
    ]) {
      ref.invalidate(provider);
    }

    ref.invalidate(todaysModelMapsProvider);
    ref.invalidate(tasksTodayOutputProvider);
  }
}

final tab2InputProvider =
    NotifierProvider<SchedulingInputNotifier, SchedulingModel>(
        SchedulingInputNotifier.new);

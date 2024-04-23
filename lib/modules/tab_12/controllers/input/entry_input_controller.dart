import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/modules/tab_12/controllers/output/output_controller.dart';
import 'package:timely/modules/tab_12/models/entry_model.dart';
import 'package:timely/modules/tab_12/models/sub_entry_model.dart';
import 'package:timely/modules/tab_12/repositories/tab_12_repo.dart';
import 'package:timely/reusables.dart';

class Tab12InputNotifier extends Notifier<Tab12EntryModel> {
  @override
  build() {
    return Tab12EntryModel(
      activity: "",
      objective: "",
      importance: 3,
      tab2Model: SchedulingModel(
        name: "",
        startTime: TimeOfDay.now(),
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        dur: Duration.zero,
        every: 1,
        frequency: Frequency.daily,
        basis: Basis.day,
        repetitions: {
          "DoW": [0, 0]
        },
      ),
    );
  }

  void setActivity(String activity) =>
      state = state.copyWith(activity: activity);
  void setObjective(String objective) =>
      state = state.copyWith(objective: objective);

  void setImportance(int importance) =>
      state = state.copyWith(importance: importance);

  void setStartDate(DateTime startDate) {
    SchedulingModel tab2Model = state.tab2Model.copyWith(startDate: startDate);
    state = state.copyWith(tab2Model: tab2Model);
  }

  void setEndDate(DateTime endDate) {
    SchedulingModel tab2Model = state.tab2Model.copyWith(endDate: endDate);
    state = state.copyWith(tab2Model: tab2Model);
  }

  void setStartTime(startTime) {
    state = state.copyWith(
      tab2Model: state.tab2Model.copyWith(startTime: startTime),
    );
  }

  void setEndTime(TimeOfDay endTime) {
    Duration dur = DateTime(0, 0, 0, endTime.hour, endTime.minute).difference(
      DateTime(0, 0, 0, state.tab2Model.startTime.hour,
          state.tab2Model.startTime.minute),
    );

    state = state.copyWith(
      tab2Model: state.tab2Model.copyWith(dur: dur),
    );
  }

  void resetBasis() {
    SchedulingModel tab2Model = state.tab2Model;
    tab2Model.basis = null;

    state = state.copyWith(tab2Model: tab2Model);
  }

  void setBasis(basis) {
    state = state.copyWith(
      tab2Model: state.tab2Model.copyWith(
        basis: basis,
      ),
    );

    if (basis == Basis.day) {
      setRepetitions(
        {
          ...state.tab2Model.repetitions,
          "DoW": [0, 0],
        },
      );
    }
  }

  void setRepetitions(Map repetitions) {
    state = state.copyWith(
      tab2Model: state.tab2Model.copyWith(repetitions: repetitions),
    );
  }

  void setEvery(int every) {
    state = state.copyWith(
      tab2Model: state.tab2Model.copyWith(every: every),
    );
  }

  void setFrequency(frequency) {
    state = state.copyWith(
      tab2Model: state.tab2Model.copyWith(
        frequency: frequency,
      ),
    );

    // Set the default values based on selection
    switch (frequency) {
      case "Monthly":
        if (state.tab2Model.basis == null) {
          setBasis(Basis.day);
        }

        setRepetitions({
          "Dates": [],
          "DoW": [0, 0]
        });
        break;

      case "Yearly":
        if (state.tab2Model.basis == null) {
          setBasis(Basis.day);
        }

        setRepetitions(
          {
            "Months": [],
            "DoW": [
              0,
              0,
            ],
          },
        );

      case "Weekly":
        resetBasis();
        setRepetitions(
          {
            "Weekdays": [],
          },
        );

      case "Daily":
        if (state.tab2Model.basis == null) {
          setBasis(Basis.day);
        }

        setRepetitions({});
    }
  }

  void setWeeklyRepetitions(List<int> weekdayIndices) {
    state = state.copyWith(
      tab2Model: state.tab2Model.copyWith(
        repetitions: {"Weekdays": weekdayIndices},
      ),
    );
  }

  void setMonthlyRepetitions(List<int> dates) {
    state = state.copyWith(
      tab2Model: state.tab2Model.copyWith(
        repetitions: {
          ...state.tab2Model.repetitions,
          "Dates": dates,
        },
      ),
    );
  }

  void setYearlyRepetitions(List<int> monthIndices) {
    state = state.copyWith(
      tab2Model: state.tab2Model.copyWith(
        repetitions: {
          ...state.tab2Model.repetitions,
          "Months": monthIndices,
        },
      ),
    );
  }

  void setOrdinalPosition(int pos) {
    state = state.copyWith(
      tab2Model: state.tab2Model.copyWith(
        repetitions: {
          ...state.tab2Model.repetitions,
          "DoW": [
            pos,
            state.tab2Model.repetitions["DoW"][1],
          ],
        },
      ),
    );
  }

  void setWeekdayIndex(int index) {
    state = state.copyWith(
      tab2Model: state.tab2Model.copyWith(
        repetitions: {
          ...state.tab2Model.repetitions,
          "DoW": [
            state.tab2Model.repetitions["DoW"][0],
            index,
          ],
        },
      ),
    );
  }

  setEntry(Tab12EntryModel model) => state = model;
  void setTab2Model(SchedulingModel tab2Model) {
    state = state.copyWith(tab2Model: tab2Model);
  }

  Future<void> syncToDB(Tab12SubEntryModel subEntry) async {
    final file = (await ref.read(dbFilesProvider.future))[12]![0];

    if (state.uuid != null) {
      await ref
          .read(tab12RepositoryProvider.notifier)
          .updateEntry(state, file, Tab12EntryModel.fromJson);
    } else {
      await ref
          .read(tab12RepositoryProvider.notifier)
          .writeEntry(state, file, [subEntry.toJson()]);
    }

    ref.invalidate(tab12OutputProvider);
  }
}

final tab12EntryInputProvider =
    NotifierProvider<Tab12InputNotifier, Tab12EntryModel>(() {
  return Tab12InputNotifier();
});

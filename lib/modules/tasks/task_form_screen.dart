import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/common/reminder_sliders.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/common/scheduling/duration_selection.dart';
import 'package:timely/common/scheduling/repeats_template.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/modules/tasks/task_model.dart';
import 'package:timely/modules/tasks/tasks_provider.dart';
import 'package:timely/reusables.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final Task? task;
  const TaskFormScreen({super.key, this.task});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<TaskFormScreen> {
  late Task task;
  final _formKey = GlobalKey<_TaskFormState>();

  @override
  void initState() {
    task = widget.task ?? Task.empty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          // Activity
          TextFormField(
            initialValue: task.activity,
            decoration: InputDecoration(
              hintText: "Activity",
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.purple[800],
            ),
            onChanged: (value) {
              task.activity = value;
            },
          ).padding(vertical: 10),

          // Date
          DateButtonAtom.large(
            currentDate: task.date,
            onDateChanged: (date) {
              task.date = date;

              setState(() {});
            },
          ).padding(vertical: 10),

          // Time
          TimeButtonAtom.large(
              initialTime: task.time,
              onTimeChanged: (time) {
                task.time = time;

                setState(() {});
              }).padding(vertical: 10),

          // Type
          [
            const Text("Type"),
            DropdownMenu(
                onSelected: (value) => task.type = value!,
                width: 150,
                dropdownMenuEntries: const [
                  DropdownMenuEntry(
                      label: "Exercise",
                      value: "exercise",
                      leadingIcon: Icon(Icons.sports_gymnastics)),
                ]),
          ]
              .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
              .padding(vertical: 10),

          // Difficulty
          [
            const Text("Difficulty"),
            DropdownMenu(
                onSelected: (value) => task.difficulty = value!,
                width: 150,
                dropdownMenuEntries: [
                  for (String difficulty in 'Easy,Hard'.split(","))
                    DropdownMenuEntry(
                      label: difficulty,
                      value: difficulty.toLowerCase(),
                    )
                ]),
          ]
              .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
              .padding(vertical: 10),

          // Duration
          <Widget>[
            const Text("Duration"),
            Switch(
              onChanged: (value) {
                value
                    ? task.duration = const Duration(hours: 0, minutes: 0)
                    : task = task.nullify(duration: true);

                setState(() {});
              },
              value: task.duration != null,
            ),
          ]
              .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
              .padding(vertical: 10),
          task.duration != null
              ? DurationSelectionMolecule(
                      onHoursChanged: (hours) => task.duration = Duration(
                          hours: hours, minutes: task.duration!.inMinutes % 60),
                      onMinutesChanged: (minutes) => task.duration = Duration(
                          hours: task.duration!.inHours, minutes: minutes),
                      initalHourIndex: task.duration!.inHours,
                      initalMinuteIndex: task.duration!.inMinutes % 60)
                  .expanded()
              : Container(),

          // Repeat Rule
          <Widget>[
            const Text("Repeats"),
            Switch(
              onChanged: (value) {
                value
                    ? task.repeatRule = SchedulingModel(
                        name: '',
                        startTime: TimeOfDay.now(),
                        dur: Duration.zero,
                        basis: Basis.day,
                        frequency: "Daily",
                        every: 2,
                        repetitions: {})
                    : task = task.nullify(repeatRule: true);

                setState(() {});
              },
              value: task.repeatRule != null,
            ),
          ]
              .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
              .padding(vertical: 10),
          task.repeatRule != null
              ? RepeatsTemplate(
                  onFrequencyChanged: (frequency) => task.repeatRule =
                      task.repeatRule!.copyWith(frequency: frequency),
                  onEveryChanged: (every) =>
                      task.repeatRule = task.repeatRule!.copyWith(every: every),
                  onEndDateChanged: (endDate) => task.repeatRule =
                      task.repeatRule!.copyWith(endDate: endDate),
                  onWeekdaySelectionsChanged: (weekdayIndices) =>
                      task.repeatRule = task.repeatRule!
                          .copyWith(repetitions: {"Weekdays": weekdayIndices}),
                  onMonthlySelectionsChanged: (dates) =>
                      task.repeatRule = task.repeatRule!.copyWith(
                    repetitions: {
                      ...task.repeatRule!.repetitions,
                      "Dates": dates,
                    },
                  ),
                  onBasisChanged: (basis) =>
                      task.repeatRule = task.repeatRule!.copyWith(basis: basis),
                  onOrdinalPositionChanged: (ordinalPosition) =>
                      task.repeatRule = task.repeatRule!.copyWith(
                    repetitions: {
                      ...task.repeatRule!.repetitions,
                      "DoW": [
                        ordinalPosition,
                        task.repeatRule!.repetitions["DoW"][1],
                      ],
                    },
                  ),
                  onWeekdayIndexChanged: (weekdayIndex) =>
                      task.repeatRule = task.repeatRule!.copyWith(
                    repetitions: {
                      ...task.repeatRule!.repetitions,
                      "DoW": [
                        task.repeatRule!.repetitions["DoW"][0],
                        weekdayIndex,
                      ],
                    },
                  ),
                  onYearlySelectionsChanged: (monthIndices) =>
                      task.repeatRule = task.repeatRule!.copyWith(
                    repetitions: {
                      ...task.repeatRule!.repetitions,
                      "Months": monthIndices,
                    },
                  ),
                  model: task.repeatRule!,
                ).expanded()
              : Container(),

          // Reminders
          ReminderSliders(
            model: task,
            onAddReminder: (something) {},
            onSliderChanged: (something) {},
            onDeleteReminder: (something) {},
          ).padding(vertical: 10),

          CancelSubmitRowMolecule(
                  onSubmitPressed: () {
                    // Access the store and box
                    final store = ref.read(storeProvider).requireValue;
                    final box = store.box<DataTask>();

                    if (widget.task == null) {
                      box.put(
                        DataTask(
                          data: jsonEncode(
                            task.toJson(),
                          ),
                        ),
                      );
                    } else {
                      box.put(
                        DataTask(
                          id: task.id,
                          data: jsonEncode(
                            task.toJson(),
                          ),
                        ),
                      );
                    }

                    ref.invalidate(tasksProvider);

                    Navigator.of(context).pop();
                  },
                  onCancelPressed: () {})
              .padding(vertical: 10),
        ],
      ),
    ).padding(all: 10);
  }
}

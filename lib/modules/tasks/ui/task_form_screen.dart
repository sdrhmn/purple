import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/common/reminder_sliders.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/common/scheduling/duration_selection.dart';
import 'package:timely/common/scheduling/repeats_template.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/modules/notifs/notif_service.dart';
import 'package:timely/modules/tasks/data/upcoming_tasks_provider.dart';
import 'package:timely/modules/tasks/task_model.dart';
import 'package:timely/modules/tasks/data/task_repository.dart';
import 'package:timely/modules/tasks/data/todays_tasks_provider.dart';
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

          // Date and Time
          [
            // Date
            DateButtonAtom.large(
              currentDate: task.date,
              onDateChanged: (date) {
                task.date = date;

                setState(() {});
              },
            ).padding(vertical: 10).expanded(),

            const SizedBox(width: 10),

            // Time
            TimeButtonAtom.large(
                initialTime: task.time,
                onTimeChanged: (time) {
                  task.time = time;

                  setState(() {});
                }).padding(vertical: 10).expanded(),
          ].toRow(),

          // Type
          [
            const Text("Type"),
            DropdownMenu(
                initialSelection: task.type,
                onSelected: (value) => task.type = value!,
                width: 150,
                dropdownMenuEntries: const [
                  DropdownMenuEntry(
                      label: "Exercise",
                      value: "exercise",
                      leadingIcon: Icon(Icons.sports_gymnastics)),
                  DropdownMenuEntry(
                    label: "Ad-hoc",
                    value: "ad-hoc",
                  ),
                  DropdownMenuEntry(
                    label: "Routine",
                    value: "routine",
                  ),
                ]),
          ]
              .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
              .padding(vertical: 10),

          // Difficulty
          [
            const Text("Priority"),
            DropdownMenu(
                initialSelection: task.priority,
                onSelected: (value) => task.priority = value!,
                width: 150,
                dropdownMenuEntries: [
                  for (String difficulty in 'Low,Medium,High'.split(","))
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
                  onMinutesChanged: (minutes) => task.duration =
                      Duration(hours: task.duration!.inHours, minutes: minutes),
                  initalHourIndex: task.duration!.inHours,
                  initalMinuteIndex: task.duration!.inMinutes % 60)
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
                        every: 1,
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
                  onFrequencyChanged: (frequency) {
                    task.repeatRule =
                        task.repeatRule!.copyWith(frequency: frequency);

                    // Set the default values based on selection
                    switch (task.repeatRule!.frequency) {
                      case "Monthly":
                        if (task.repeatRule!.basis == null) {
                          task.repeatRule =
                              task.repeatRule!.copyWith(basis: Basis.day);
                        }

                        task.repeatRule = task.repeatRule!.copyWith(
                          repetitions: {
                            "Dates": [],
                            "DoW": [0, 0]
                          },
                        );
                        break;

                      case "Yearly":
                        if (task.repeatRule!.basis == null) {
                          task.repeatRule =
                              task.repeatRule!.copyWith(basis: Basis.day);
                        }

                        task.repeatRule = task.repeatRule!.copyWith(
                          repetitions: {
                            "Months": [],
                            "DoW": [0, 0]
                          },
                        );

                      case "Weekly":
                        task.repeatRule!.basis = null;

                        task.repeatRule = task.repeatRule!.copyWith(
                          repetitions: {"Weekdays": []},
                        );

                      case "Daily":
                        if (task.repeatRule!.basis == null) {
                          task.repeatRule =
                              task.repeatRule!.copyWith(basis: Basis.day);
                        }

                        task.repeatRule = task.repeatRule!.copyWith(
                          repetitions: {},
                        );
                    }

                    setState(() {});
                  },
                  onEveryChanged: (every) =>
                      task.repeatRule = task.repeatRule!.copyWith(every: every),
                  onEndDateChanged: (endDate) {
                    task.repeatRule =
                        task.repeatRule!.copyWith(endDate: endDate);
                    setState(() {});
                  },
                  onWeekdaySelectionsChanged: (weekdayIndices) {
                    task.repeatRule = task.repeatRule!
                        .copyWith(repetitions: {"Weekdays": weekdayIndices});
                    setState(() {});
                  },
                  onMonthlySelectionsChanged: (dates) {
                    task.repeatRule = task.repeatRule!.copyWith(
                      repetitions: {
                        ...task.repeatRule!.repetitions,
                        "Dates": dates,
                      },
                    );
                    setState(() {});
                  },
                  onBasisChanged: (basis) {
                    task.repeatRule = task.repeatRule!.copyWith(basis: basis);
                    setState(() {});
                  },
                  onOrdinalPositionChanged: (ordinalPosition) {
                    task.repeatRule = task.repeatRule!.copyWith(
                      repetitions: {
                        ...task.repeatRule!.repetitions,
                        "DoW": [
                          ordinalPosition,
                          task.repeatRule!.repetitions["DoW"][1],
                        ],
                      },
                    );

                    setState(() {});
                  },
                  onWeekdayIndexChanged: (weekdayIndex) {
                    task.repeatRule = task.repeatRule!.copyWith(
                      repetitions: {
                        ...task.repeatRule!.repetitions,
                        "DoW": [
                          task.repeatRule!.repetitions["DoW"][0],
                          weekdayIndex,
                        ],
                      },
                    );
                    setState(() {});
                  },
                  onYearlySelectionsChanged: (monthIndices) {
                    task.repeatRule = task.repeatRule!.copyWith(
                      repetitions: {
                        ...task.repeatRule!.repetitions,
                        "Months": monthIndices,
                      },
                    );
                    setState(() {});
                  },
                  model: task.repeatRule!,
                )
              : Container(),

          // Reminders
          task.time == null
              ? Container()
              : ReminderSliders(
                  model: task,
                  onAddReminder: (tsk) {
                    task = tsk;
                    setState(() {});
                  },
                  onSliderChanged: (tsk) {
                    task = tsk;
                    setState(() {});
                  },
                  onDeleteReminder: (tsk) {
                    task = tsk;
                    setState(() {});
                  },
                ).padding(vertical: 10),

          CancelSubmitRowMolecule(
                  onSubmitPressed: () {
                    if (task.type == "ad-hoc") {
                      // NotifService().scheduleAdHocTaskNotifs(task);
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      //   content: Text(
                      //       "Scheduled${task.reminders.isNotEmpty ? ' reminders and' : ''} a notification for ${task.activity} at ${task.time.format(context)} on ${DateFormat(DateFormat.ABBR_MONTH_DAY).format(task.date)}"),
                      // ));
                    } else if (task.repeatRule != null) {
                      NotifService().scheduleRepeatTaskNotifs(task.repeatRule!);
                    }

                    if (widget.task == null) {
                      ref.read(taskRepositoryProvider.notifier).writeTask(task);
                    } else {
                      ref
                          .read(taskRepositoryProvider.notifier)
                          .updateTask(task);
                    }

                    ref.invalidate(todaysTasksProvider);
                    ref.invalidate(upcomingTasksProvider);

                    Navigator.of(context).pop();
                  },
                  onCancelPressed: () {})
              .padding(vertical: 10),
        ],
      ),
    ).padding(all: 10);
  }
}

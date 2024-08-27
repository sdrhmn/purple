import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/common/buttons.dart';
import 'package:timely/common/reminder_sliders.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/common/scheduling/duration_selection.dart';
import 'package:timely/common/scheduling/repeats_template.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/modules/notifs/notif_service.dart';
import 'package:timely/modules/tasks/data/task_providers/upcoming_tasks_provider.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/modules/tasks/data/task_repository.dart';
import 'package:timely/modules/tasks/data/task_providers/todays_tasks_provider.dart';
import 'package:timely/modules/tasks/data/task_providers/completed_tasks_provider.dart';
import 'package:timely/reusables.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final Task? task;
  const TaskFormScreen({super.key, this.task});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<TaskFormScreen> {
  late Task task;
  SchedulingModel? repeatRule;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    task = widget.task ?? Task.empty();
    repeatRule = task.repeatRule;
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
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              onTapOutside: (PointerDownEvent event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              initialValue: task.name,
              decoration: InputDecoration(
                hintText: "Name",
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.purple[800],
              ),
              onChanged: (value) {
                task.name = value;
              },
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Please do not leave the activity field blank.';
                }
                return null;
              }).padding(vertical: 10),

          TextFormField(
            onTapOutside: (PointerDownEvent event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            maxLines: 5,
            initialValue: task.description,
            decoration: InputDecoration(
              hintText: "Description",
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.purple[900],
            ),
            onChanged: (value) {
              task.description = value;
            },
          ).padding(vertical: 10),

          // Subtasks
          TextButtonAtom(
                  onPressed: () {
                    setState(() {
                      task.subtasks = [...task.subtasks, Subtask(name: "")];
                    });
                  },
                  text: "Add Subtask")
              .padding(vertical: 5),

          ...List.generate(task.subtasks.length, (index) {
            print(task.subtasks[index].name);
            return Row(
              children: [
                index == task.subtasks.length - 1
                    ? IconButton(
                        onPressed: () {
                          task.subtasks.removeLast();
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.remove_circle,
                        ),
                      )
                    : Container(),
                const SizedBox(
                  width: 10,
                ),
                TextFormField(
                  maxLines: 1,
                  textCapitalization: TextCapitalization.sentences,
                  onTapOutside: (PointerDownEvent event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  initialValue: task.subtasks[index].name,
                  decoration: InputDecoration(
                    hintText: "Name",
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.purple[800],
                  ),
                  onChanged: (value) {
                    task.subtasks[index].name = value;
                  },
                ).padding(vertical: 10).expanded(),
              ],
            );
          }),

          // Date and Time
          [
            // Date
            DateButtonAtom.large(
              currentDate: task.date,
              onDateChanged: (date) {
                task.date = DateTime(date.year, date.month, date.day);

                setState(() {});
              },
            ).padding(vertical: 10).expanded(),

            const SizedBox(width: 10),

            // Time
            TextButtonAtom.large(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            DateTime selectedDateTime = DateTime.now().copyWith(
                                hour: task.time?.hour,
                                minute: task.time?.minute);

                            return Column(
                              children: [
                                CupertinoDatePicker(
                                  initialDateTime: DateTime.now().copyWith(
                                      hour: task.time?.hour,
                                      minute: task.time?.minute),
                                  onDateTimeChanged: (DateTime dateTime) {
                                    selectedDateTime = dateTime;
                                  },
                                  mode: CupertinoDatePickerMode.time,
                                ).expanded(),
                                [
                                  IconButton.outlined(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      icon: const Icon(Icons.cancel,
                                          color: Colors.red)),
                                  IconButton.outlined(
                                      onPressed: () {
                                        task.time = TimeOfDay.fromDateTime(
                                            selectedDateTime);
                                        Navigator.pop(context);
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.done,
                                          color: Colors.blue)),
                                ]
                                    .toRow(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround)
                                    .padding(bottom: 20),
                              ],
                            );
                          });
                    },
                    text: task.time == null
                        ? "Select Time"
                        : task.time!.format(context))
                .padding(vertical: 10)
                .expanded(),
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
                      leadingIcon: Icon(Icons.line_style)),
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
                    ? repeatRule = SchedulingModel(
                        name: '',
                        startTime: TimeOfDay.now(),
                        dur: Duration.zero,
                        basis: Basis.day,
                        frequency: "Daily",
                        every: 1,
                        repetitions: {},
                      )
                    : repeatRule = null;

                setState(() {});
              },
              value: repeatRule != null,
            ),
          ]
              .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
              .padding(vertical: 10),
          repeatRule != null
              ? RepeatsTemplate(
                  onFrequencyChanged: (frequency) {
                    repeatRule = repeatRule!.copyWith(frequency: frequency);

                    // Set the default values based on selection
                    switch (repeatRule!.frequency) {
                      case "Monthly":
                        if (repeatRule!.basis == null) {
                          repeatRule = repeatRule!.copyWith(basis: Basis.day);
                        }

                        repeatRule = repeatRule!.copyWith(
                          repetitions: {
                            "Dates": [],
                            "DoW": [0, 0]
                          },
                        );
                        break;

                      case "Yearly":
                        if (repeatRule!.basis == null) {
                          repeatRule = repeatRule!.copyWith(basis: Basis.day);
                        }

                        repeatRule = repeatRule!.copyWith(
                          repetitions: {
                            "Months": [],
                            "DoW": [0, 0]
                          },
                        );

                      case "Weekly":
                        repeatRule!.basis = null;

                        repeatRule = repeatRule!.copyWith(
                          repetitions: {"Weekdays": []},
                        );

                      case "Daily":
                        if (repeatRule!.basis == null) {
                          repeatRule = repeatRule!.copyWith(basis: Basis.day);
                        }

                        repeatRule = repeatRule!.copyWith(
                          repetitions: {},
                        );
                    }

                    setState(() {});
                  },
                  onEveryChanged: (every) =>
                      repeatRule = repeatRule!.copyWith(every: every),
                  onEndDateChanged: (endDate) {
                    repeatRule = repeatRule!.copyWith(endDate: endDate);
                    setState(() {});
                  },
                  onWeekdaySelectionsChanged: (weekdayIndices) {
                    repeatRule = repeatRule!
                        .copyWith(repetitions: {"Weekdays": weekdayIndices});
                    setState(() {});
                  },
                  onMonthlySelectionsChanged: (dates) {
                    repeatRule = repeatRule!.copyWith(
                      repetitions: {
                        ...repeatRule!.repetitions,
                        "Dates": dates,
                      },
                    );
                    setState(() {});
                  },
                  onBasisChanged: (basis) {
                    repeatRule = repeatRule!.copyWith(basis: basis);
                    setState(() {});
                  },
                  onOrdinalPositionChanged: (ordinalPosition) {
                    repeatRule = repeatRule!.copyWith(
                      repetitions: {
                        ...repeatRule!.repetitions,
                        "DoW": [
                          ordinalPosition,
                          repeatRule!.repetitions["DoW"][1],
                        ],
                      },
                    );

                    setState(() {});
                  },
                  onWeekdayIndexChanged: (weekdayIndex) {
                    repeatRule = repeatRule!.copyWith(
                      repetitions: {
                        ...repeatRule!.repetitions,
                        "DoW": [
                          repeatRule!.repetitions["DoW"][0],
                          weekdayIndex,
                        ],
                      },
                    );
                    setState(() {});
                  },
                  onYearlySelectionsChanged: (monthIndices) {
                    repeatRule = repeatRule!.copyWith(
                      repetitions: {
                        ...repeatRule!.repetitions,
                        "Months": monthIndices,
                      },
                    );
                    setState(() {});
                  },
                  model: repeatRule!,
                )
              : Container(),

          // Reminders
          task.time == null
              ? Container()
              : ReminderSliders(
                  model: task.copyWith(repeatRule: repeatRule),
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
              if (_formKey.currentState!.validate()) {
                task.repeatRule = repeatRule?.copyWith(
                    startDate: task.date, startTime: task.time);

                if (task.time != null && task.date != null) {
                  if (task.date!
                      .copyWith(
                          hour: task.time!.hour, minute: task.time!.minute)
                      .isAfter(DateTime.now())) {
                    if (repeatRule != null) {
                      NotifService().scheduleRepeatTaskNotifs(task
                        ..repeatRule = task.repeatRule!.copyWith(
                            startDate: task.date!, startTime: task.time!));
                    } else {
                      NotifService().scheduleAdHocTaskNotifs(task);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Scheduled${task.reminders.isNotEmpty ? ' reminders and' : ''} a notification for ${task.name} at ${task.time!.format(context)} on ${DateFormat(DateFormat.ABBR_MONTH_DAY).format(task.date!)}"),
                    ));
                  }
                }

                if (widget.task == null) {
                  ref.read(taskRepositoryProvider.notifier).writeTask(task);
                } else {
                  ref.read(taskRepositoryProvider.notifier).updateTask(task);
                }

                ref.invalidate(todaysTasksProvider);
                ref.invalidate(upcomingTasksProvider);
                ref.invalidate(completetdTasksProvider);

                Navigator.of(context).pop();
              } else
              // If the form is NOT valid
              {
                // ignore: prefer_const_constructors
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text("Please fix the errors first."),
                ));
              }
            },
            onCancelPressed: () => Navigator.of(context).pop(),
          ).padding(vertical: 10),
        ],
      ),
    ).padding(all: 10);
  }
}

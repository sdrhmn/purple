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
import 'package:timely/modules/lifestyle/goals/data/goals_provider.dart';
import 'package:timely/modules/notifs/notif_service.dart';
import 'package:timely/modules/tasks/data/task_providers/upcoming_tasks_provider.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/modules/tasks/data/task_repository.dart';
import 'package:timely/modules/tasks/data/task_providers/todays_tasks_provider.dart';
import 'package:timely/modules/tasks/data/task_providers/completed_tasks_provider.dart';
import 'package:timely/modules/tasks/tokens.dart';
import 'package:timely/reusables.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final Task? task;
  final bool allowProjectType;
  const TaskFormScreen({
    super.key,
    this.task,
    this.allowProjectType = false,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<TaskFormScreen> {
  late Task task;
  SchedulingModel? repeatRule;
  final _formKey = GlobalKey<FormState>();

  List<Widget> icons = [
    Image.asset("assets/type_icons/sleep.jpeg"),
    Image.asset("assets/type_icons/event.jpeg"),
    Image.asset("assets/type_icons/shopping.jpeg"),
    Image.asset("assets/type_icons/money.jpeg"),
    Image.asset("assets/type_icons/recurring.jpeg"),
    Image.asset("assets/type_icons/other.jpeg"),
    Container(),
  ];

  @override
  void initState() {
    task = widget.task ?? Task.empty();
    repeatRule = task.repeatRule;

    if (widget.allowProjectType) {
      task.type = "project";
    }
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
              onTapOutside: (e) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
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
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Please do not leave the activity field blank.';
                }
                return null;
              }).padding(vertical: 10),

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
                                      iconSize: 30,
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      icon: const Icon(Icons.cancel,
                                          color: Colors.yellow)),
                                  IconButton.outlined(
                                      iconSize: 30,
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
          task.type == "project"
              ? Container()
              : [
                  const Text("Type"),
                  DropdownMenu(
                      initialSelection: task.type,
                      onSelected: (value) {
                        if ((value == "project") ||
                            (task.type == "project" && value != "project")) {
                          setState(() {});
                        }
                        task.type = value!;
                      },
                      width: 190,
                      dropdownMenuEntries: [
                        for (int i in Iterable.generate(
                            widget.allowProjectType ? 1 : types.length - 1))
                          DropdownMenuEntry(
                            value: types.keys.toList()[
                                widget.allowProjectType ? types.length - 1 : i],
                            label: types.values.toList()[
                                widget.allowProjectType ? types.length - 1 : i],
                            leadingIcon: icons[i]
                                .constrained(width: 30)
                                .clipRRect(all: 999),
                          )
                      ]),
                ]
                  .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  .padding(vertical: 10),

          // NextActivity
          task.type == "project"
              ? TextFormField(
                  onTapOutside: (e) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  maxLines: 2,
                  textCapitalization: TextCapitalization.sentences,
                  initialValue: task.nextActivity,
                  decoration: InputDecoration(
                    hintText: "Next Activity",
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.purple[700],
                  ),
                  onChanged: (value) {
                    task.nextActivity = value;
                  },
                ).padding(vertical: 10)
              : Container(),

          // Difficulty
          [
            const Text("Priority"),
            DropdownMenu(
                initialSelection: task.priority,
                onSelected: (value) => task.priority = value!,
                width: 190,
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
          task.type == "project"
              ? Container()
              : <Widget>[
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
          task.time == null || task.type == "project"
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
                          "Scheduled${task.reminders.isNotEmpty ? ' reminders and' : ''} a notification for ${task.activity} at ${task.time!.format(context)} on ${DateFormat(DateFormat.ABBR_MONTH_DAY).format(task.date!)}"),
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
                ref.invalidate(completedTasksProvider);
                ref.invalidate(goalsProvider);

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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/common/buttons.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/common/scheduling/duration_selection.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
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
          // Type
          task.type == "project"
              ? Container()
              : [
                  const Text("Type"),
                  DropdownMenu(
                      initialSelection: task.type,
                      onSelected: (value) {
                        setState(() {});
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
                                .constrained(width: 40)
                                .clipRRect(all: 999),
                          )
                      ]),
                ]
                  .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
                  .padding(vertical: 10),

          // Priority
          [
            const Text("Priority"),
            DropdownMenu(
              initialSelection: task.priority,
              onSelected: (value) => task.priority = value!,
              width: 190,
              dropdownMenuEntries: [
                for (String difficulty
                    in 'Critical,High,Medium,Low,Lowest'.split(","))
                  DropdownMenuEntry(
                    label: difficulty,
                    value: difficulty.toLowerCase(),
                  )
              ],
            ),
          ]
              .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
              .padding(vertical: 10),

          // Activity
          TextFormField(
            enabled: task.type != "sleep",
            onTapOutside: (e) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            initialValue: task.activity,
            decoration: InputDecoration(
              hintText: "Activity",
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor:
                  task.type == "sleep" ? Colors.grey[400] : Colors.purple[800],
            ),
            onChanged: (value) {
              task.activity = value;
            },
            validator: (value) {
              if (value != null && value.isEmpty) {
                return 'Please do not leave the activity field blank.';
              }
              return null;
            },
          ).padding(vertical: 10),

          // Date and Time
          [
            DateButtonAtom.large(
              currentDate: task.date,
              onDateChanged: (date) {
                task.date = DateTime(date.year, date.month, date.day);
                setState(() {});
              },
              icon: const Icon(
                Icons.calendar_month,
                color: Colors.grey,
              ),
              defaultText: task.date == null
                  ? 'Date'
                  : DateFormat.yMMMd().format(task.date!),
            ).padding(vertical: 10).expanded(),
            const SizedBox(width: 10),
            TextButtonAtom.large(
              icon: const Icon(
                Icons.timer_rounded,
                color: Colors.grey,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    DateTime selectedDateTime = DateTime.now().copyWith(
                        hour: task.time?.hour, minute: task.time?.minute);
                    return Column(
                      children: [
                        CupertinoDatePicker(
                          initialDateTime: DateTime.now().copyWith(
                              hour: task.time?.hour, minute: task.time?.minute),
                          onDateTimeChanged: (DateTime dateTime) {
                            selectedDateTime = dateTime;
                          },
                          mode: CupertinoDatePickerMode.time,
                        ).expanded(),
                        [
                          IconButton.outlined(
                            iconSize: 30,
                            onPressed: () => Navigator.of(context).pop(),
                            icon:
                                const Icon(Icons.cancel, color: Colors.yellow),
                          ),
                          IconButton.outlined(
                            iconSize: 30,
                            onPressed: () {
                              task.time =
                                  TimeOfDay.fromDateTime(selectedDateTime);
                              Navigator.pop(context);
                              setState(() {});
                            },
                            icon: const Icon(Icons.done, color: Colors.blue),
                          ),
                        ]
                            .toRow(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround)
                            .padding(bottom: 20),
                      ],
                    );
                  },
                );
              },
              text: task.time == null ? 'Time' : task.time!.format(context),
            ).padding(vertical: 10).expanded(),
          ].toRow(),

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
                  initalMinuteIndex: task.duration!.inMinutes % 60,
                )
              : Container(),

          // Repeats
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

          // Cancel and Submit buttons
          CancelSubmitRowMolecule(
            onSubmitPressed: () {
              if (_formKey.currentState!.validate()) {
                task.repeatRule = repeatRule?.copyWith(
                    startDate: task.date, startTime: task.time);
                // Save task logic here
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please fix the errors first.")),
                );
              }
            },
            onCancelPressed: () => Navigator.of(context).pop(),
          ).padding(vertical: 10),
        ],
      ),
    ).padding(all: 10);
  }
}

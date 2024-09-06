import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/notifs/notif_service.dart';
import 'package:timely/modules/tasks/data/task_providers/upcoming_tasks_provider.dart';
import 'package:timely/modules/tasks/tokens.dart';
import 'package:timely/modules/tasks/ui/task_form_screen.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/modules/tasks/data/task_repository.dart';
import '../../components/task_tile.dart';

class UpcomingTaskScreen extends ConsumerStatefulWidget {
  const UpcomingTaskScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<UpcomingTaskScreen> {
  String filter = "all";

  @override
  Widget build(BuildContext context) {
    final providerOfTasks = ref.watch(upcomingTasksProvider);

    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text("Type"),
            Container(
              color: Colors.grey.withAlpha(40),
              child: DropdownButton(
                  borderRadius: BorderRadius.circular(5),
                  underline: Container(),
                  value: filter,
                  items: [
                    for (String filter in filters)
                      DropdownMenuItem(
                          value: filter,
                          child: Text(
                                  filter[0].toUpperCase() + filter.substring(1))
                              .padding(all: 10))
                  ],
                  onChanged: (flt) {
                    setState(() {
                      filter = flt!;
                    });
                  }),
            ).clipRRect(all: 5)
          ],
        ).height(60),
        const SizedBox(
          height: 7,
        ),
        Expanded(
          child: Scaffold(
            body: providerOfTasks.when(
              data: (Map<DateTime, List<Task>> tasks) {
                return RefreshIndicator(
                    onRefresh: () {
                      return Future.delayed(Duration.zero, () {
                        ref.invalidate(upcomingTasksProvider);
                      });
                    },
                    child: ListView(
                      children: [
                        for (DateTime date in tasks.keys) ...{
                          ...tasks[date]!
                                  .where((task) => filter != "all"
                                      ? task.type == filter
                                      : true)
                                  .isNotEmpty
                              ? [
                                  Text(DateFormat(
                                              DateFormat.ABBR_MONTH_WEEKDAY_DAY)
                                          .format(date))
                                      .padding(all: 10)
                                      .card()
                                      .center(),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ]
                              : [],
                          ...() {
                            List<Task> filteredTasks = tasks[date]!
                                .where((task) => filter != "all"
                                    ? task.type == filter
                                    : true)
                                .toList();
                            return List.generate(filteredTasks.length, (index) {
                              Task task = filteredTasks[index];
                              return TaskTile(
                                task: task,
                                onTaskCheckboxChanged: (bool? value) async {
                                  // Select the DateTime at which the task was completed
                                  if (value!)
                                  // If the task is marked complete
                                  {
                                    await showModalBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          DateTime selectedDateTime =
                                              DateTime.now();
                                          return Column(
                                            children: [
                                              CupertinoDatePicker(
                                                      onDateTimeChanged:
                                                          (DateTime dateTime) {
                                                        selectedDateTime =
                                                            dateTime;
                                                      },
                                                      mode:
                                                          CupertinoDatePickerMode
                                                              .dateAndTime)
                                                  .expanded(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  IconButton.outlined(
                                                      onPressed: () {
                                                        filteredTasks[index]
                                                            .completedAt = null;
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      icon: const Icon(
                                                          Icons.cancel,
                                                          color: Colors.red)),
                                                  IconButton.outlined(
                                                      onPressed: () {
                                                        filteredTasks[index]
                                                                .completedAt =
                                                            selectedDateTime;
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      icon: const Icon(
                                                          Icons.done,
                                                          color: Colors.blue))
                                                ],
                                              ).padding(bottom: 20),
                                            ],
                                          );
                                        });
                                  }

                                  if ((value == true &&
                                          filteredTasks[index].completedAt !=
                                              null) ||
                                      (value == false)) {
                                    setState(() {
                                      filteredTasks[index].isComplete = value;

                                      if (value == false) {
                                        task.completedAt = null;
                                      }

                                      if (value) {
                                        if (task.repeatRule == null) {
                                          NotifService().cancelNotif(task.id);
                                          NotifService()
                                              .cancelReminders(task.reminders);
                                        } else {
                                          NotifService()
                                              .cancelRepeatTaskNotifs(task);
                                        }
                                      }

                                      ref
                                          .read(taskRepositoryProvider.notifier)
                                          .completeTask(task);
                                    });
                                  }
                                },
                                onSubtaskCheckboxChanged:
                                    (bool? value, int subtaskIndex) {
                                  ref
                                      .read(taskRepositoryProvider.notifier)
                                      .updateTask(filteredTasks[index]);
                                  filteredTasks[index]
                                      .subtasks[subtaskIndex]
                                      .isComplete = value!;
                                  setState(() {});
                                },
                                onDelete: () {
                                  setState(() {
                                    ref
                                        .read(taskRepositoryProvider.notifier)
                                        .deleteTask(task);
                                    tasks[date]!.remove(task);
                                    if (task.repeatRule == null) {
                                      NotifService().cancelNotif(task.id);
                                      NotifService()
                                          .cancelReminders(task.reminders);
                                    } else {
                                      NotifService()
                                          .cancelRepeatTaskNotifs(task);
                                    }

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Notifications and reminders cancelled for ${filteredTasks[index].name}")));
                                  });
                                },
                              ).padding(bottom: 10);
                            });
                          }()
                        },
                        const SizedBox(height: 70),
                      ],
                    )).padding(all: 10);
              },
              error: (_, __) {
                return const Text("Error");
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.white24),
              ),
              backgroundColor: Colors.purple.withAlpha(50),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: const Text("Create Task"),
                    ),
                    body: const TaskFormScreen(),
                  ),
                ),
              ),
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

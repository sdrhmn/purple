import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/notifs/notif_service.dart';
import 'package:timely/modules/tasks/data/task_providers/completed_tasks_provider.dart';
import 'package:timely/modules/tasks/ui/task_form_screen.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/modules/tasks/data/task_repository.dart';
import '../../components/task_tile.dart';

class CompletedTaskScreen extends ConsumerStatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<CompletedTaskScreen> {
  String filter = "all";

  @override
  Widget build(BuildContext context) {
    List<String> filters = ['all', 'ad-hoc', 'exercise'];
    final providerOfTasks = ref.watch(completetdTasksProvider);

    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text("Filter"),
            DropdownButton(
                borderRadius: BorderRadius.circular(5),
                underline: Container(),
                value: filter,
                items: [
                  for (String filter in filters)
                    DropdownMenuItem(
                        value: filter,
                        child: Text(filter.toUpperCase()).padding(all: 5))
                ],
                onChanged: (flt) {
                  setState(() {
                    filter = flt!;
                  });
                })
          ],
        ).height(60).card(),
        const SizedBox(
          height: 7,
        ),
        Expanded(
          child: Scaffold(
            body: providerOfTasks.when(
              data: (Map<DateTime?, List<Task>> tasks) {
                return RefreshIndicator(
                    onRefresh: () {
                      return Future.delayed(Duration.zero, () {
                        ref.invalidate(completetdTasksProvider);
                      });
                    },
                    child: ListView(
                      children: [
                        for (DateTime? date in tasks.keys) ...{
                          Text(date != null
                                  ? DateFormat(DateFormat.ABBR_MONTH_DAY)
                                      .format(date)
                                  : "")
                              .padding(all: 10)
                              .card()
                              .center(),
                          const SizedBox(
                            height: 10,
                          ),
                          ...() {
                            List<Task> filteredTasks = tasks[date]!
                                .where((task) => filter != "all"
                                    ? task.type == filter
                                    : true)
                                .toList()
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
                                  filteredTasks[index]
                                      .subtasks[subtaskIndex]
                                      .isComplete = value!;
                                  ref
                                      .read(taskRepositoryProvider.notifier)
                                      .updateTask(filteredTasks[index]);
                                  setState(() {});
                                },
                                onDelete: () {
                                  setState(
                                    () {
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
                                    },
                                  );
                                },
                              ).padding(bottom: 10, horizontal: 10);
                            });
                          }()
                        },
                        const SizedBox(height: 70),
                      ],
                    ));
              },
              error: (_, __) {
                return Text("Error $_ , $__");
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.white,
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
              child: Icon(Icons.add, color: Colors.purple[700]),
            ),
          ),
        ),
      ],
    );
  }
}

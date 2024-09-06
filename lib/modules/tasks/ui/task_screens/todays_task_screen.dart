import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/notifs/notif_service.dart';
import 'package:timely/modules/tasks/tokens.dart';
import 'package:timely/modules/tasks/ui/task_form_screen.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/modules/tasks/data/task_repository.dart';
import 'package:timely/modules/tasks/data/task_providers/todays_tasks_provider.dart';

import '../../components/task_tile.dart';

class TodaysTaskScreen extends ConsumerStatefulWidget {
  const TodaysTaskScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TodaysTaskScreen> {
  String filter = "all";

  @override
  Widget build(BuildContext context) {
    final providerOfTasks = ref.watch(todaysTasksProvider);

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
              data: (List<Task> tasks) {
                return RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(Duration.zero, () {
                      ref.invalidate(todaysTasksProvider);
                    });
                  },
                  child: ReorderableListView(
                    buildDefaultDragHandles: false,
                    footer: const SizedBox(height: 80),
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final Task task =
                            tasks.removeAt(tasks.indexOf(tasks[oldIndex]));
                        tasks.insert(newIndex, task);

                        ref
                            .read(taskRepositoryProvider.notifier)
                            .updateTask(task..position = newIndex);
                      });
                    },
                    children: List.generate(tasks.length, (index) {
                      if (filter != "all"
                          ? tasks[index].type == filter
                          : true) {
                        return ReorderableDragStartListener(
                          key: ValueKey(index),
                          index: index,
                          child: TaskTile(
                            task: tasks[index],
                            onTaskCheckboxChanged: (bool? value) =>
                                _onCheckboxChanged(value, tasks, index),
                            onSubtaskCheckboxChanged:
                                (bool? value, int subtaskIndex) {
                              tasks[index].subtasks[subtaskIndex].isComplete =
                                  value!;

                              ref
                                  .read(taskRepositoryProvider.notifier)
                                  .updateTask(tasks[index]);
                              setState(() {});
                            },
                            onDelete: () {
                              Task task = tasks[index];
                              setState(
                                () {
                                  ref
                                      .read(taskRepositoryProvider.notifier)
                                      .deleteTask(task);
                                  if (task.repeatRule == null) {
                                    NotifService().cancelNotif(task.id);
                                    NotifService()
                                        .cancelReminders(task.reminders);
                                  } else {
                                    NotifService().cancelRepeatTaskNotifs(task);
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Notifications and reminders cancelled for ${tasks[index].name}",
                                      ),
                                    ),
                                  );

                                  tasks.removeAt(index);
                                },
                              );
                            },
                          ).padding(
                            bottom: 10,
                            key: ValueKey(index),
                          ),
                        );
                      }
                    }).whereType<Widget>().toList(),
                  ).decorated().padding(all: 10),
                );
              },
              error: (_, __) {
                return Text("Error $_, $__");
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
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  _onCheckboxChanged(bool? value, List<Task> tasks, int index) async {
    // Select the DateTime at which the task was completed
    if (value!)
    // If the task is marked complete
    {
      await showModalBottomSheet(
          context: context,
          builder: (context) {
            Task task = tasks[index];

            DateTime? taskTimePlusDuration = task.date
                ?.copyWith(
                  hour: task.time?.hour,
                  minute: task.time?.minute,
                )
                .add(task.duration ?? Duration.zero);

            DateTime selectedDateTime = DateTime.now().copyWith(
                hour: task.time != null ? taskTimePlusDuration?.hour : null,
                minute:
                    task.time != null ? taskTimePlusDuration?.minute : null);

            return Column(
              children: [
                CupertinoDatePicker(
                        initialDateTime: selectedDateTime,
                        onDateTimeChanged: (DateTime dateTime) {
                          selectedDateTime = dateTime;
                        },
                        mode: CupertinoDatePickerMode.dateAndTime)
                    .expanded(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton.outlined(
                        onPressed: () {
                          tasks[index].completedAt = null;
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.cancel, color: Colors.red)),
                    IconButton.outlined(
                        onPressed: () {
                          tasks[index].completedAt = selectedDateTime;
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.done, color: Colors.blue))
                  ],
                ).padding(bottom: 20),
              ],
            );
          });
    }

    // If a DateTime is selected OR the
    // task is being marked incomplete
    if ((value == true && tasks[index].completedAt != null) ||
        (value == false)) {
      setState(() {
        tasks[index].isComplete = value;

        if (value == false) {
          tasks[index].completedAt = null;
        }

        if (value) {
          if (tasks[index].repeatRule == null) {
            NotifService().cancelNotif(tasks[index].id);
            NotifService().cancelReminders(tasks[index].reminders);
          } else {
            NotifService().cancelRepeatTaskNotifs(tasks[index]);
          }
        }

        ref.read(taskRepositoryProvider.notifier).completeTask(tasks[index]);
      });
    }
  }
}

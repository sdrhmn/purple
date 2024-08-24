import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/notifs/notif_service.dart';
import 'package:timely/modules/tasks/components/task_tile.dart';
import 'package:timely/modules/tasks/data/task_providers/overdue_tasks_provider.dart';
import 'package:timely/modules/tasks/data/task_repository.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/modules/tasks/ui/task_form_screen.dart';

class OverdueTaskScreen extends ConsumerStatefulWidget {
  const OverdueTaskScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OverdueTaskScreenState();
}

class _OverdueTaskScreenState extends ConsumerState<OverdueTaskScreen> {
  String filter = "all";
  late PageController _pageViewController;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> filters = ['all', 'ad-hoc', 'exercise'];
    final providerOfTasks = ref.watch(overdueTasksProvider);

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
              data: (List<Task> tasks) {
                List<Task> filteredTasks = tasks
                    .where(
                        (task) => filter != "all" ? task.type == filter : true)
                    .toList();
                return RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(Duration.zero, () {
                      ref.invalidate(overdueTasksProvider);
                    });
                  },
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (index + 1 == filteredTasks.length + 1) {
                        return const SizedBox(height: 70);
                      } else {
                        return TaskTile(
                          task: filteredTasks[index],
                          onCheckboxChanged: (bool? value) =>
                              _onCheckboxChanged(value, filteredTasks, index),
                          onDelete: () {
                            Task task = filteredTasks[index];

                            setState(
                              () {
                                ref
                                    .read(taskRepositoryProvider.notifier)
                                    .deleteTask(task);
                                tasks.remove(task);
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
                                      "Notifications and reminders cancelled for ${filteredTasks[index].activity}",
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ).padding(horizontal: 10);
                      }
                    },
                    itemCount: filteredTasks.length + 1,
                  ),
                );
              },
              error: (_, __) {
                return const Text("Error");
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
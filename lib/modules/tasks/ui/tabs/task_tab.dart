import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/notifs/notif_service.dart';
import 'package:timely/modules/tasks/ui/task_form_screen.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/modules/tasks/data/task_repository.dart';
import 'package:timely/modules/tasks/data/task_providers/todays_tasks_provider.dart';

import '../../components/task_tile.dart';

class TaskTab extends ConsumerStatefulWidget {
  const TaskTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskTabState();
}

class _TaskTabState extends ConsumerState<TaskTab> {
  String filter = "all";
  @override
  Widget build(BuildContext context) {
    final providerOfTasks = ref.watch(todaysTasksProvider);

    return Scaffold(
      body: providerOfTasks.when(
        data: (List<Task> tasks) {
          List<Task> filteredTasks = tasks
              .where((task) => filter != "all" ? task.type == filter : true)
              .toList();
          return RefreshIndicator(
            onRefresh: () {
              return Future.delayed(Duration.zero, () {
                ref.invalidate(todaysTasksProvider);
              });
            },
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (index + 1 == filteredTasks.length + 1) {
                  return const SizedBox(height: 70);
                } else {
                  return TaskTile(
                    task: filteredTasks[index],
                    onDismissed:
                        (DismissDirection direction, Task dismissedTask) {
                      Task task = filteredTasks[index];
                      tasks.remove(task);

                      setState(
                        () {
                          if (direction == DismissDirection.startToEnd) {
                            ref
                                .read(taskRepositoryProvider.notifier)
                                .deleteTask(task);
                            if (task.repeatRule == null) {
                              NotifService().cancelNotif(task.id);
                              NotifService().cancelReminders(task.reminders);
                            } else {
                              NotifService().cancelRepeatTaskNotifs(task);
                            }

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Notifications and reminders cancelled for ${filteredTasks[index].activity}")));
                          } else {
                            filteredTasks[index].isComplete =
                                !filteredTasks[index].isComplete;
                            filteredTasks[index].completedAt =
                                filteredTasks[index].isComplete
                                    ? DateTime.now()
                                    : null;

                            if (filteredTasks[index].isComplete) {
                              if (filteredTasks[index].repeatRule == null) {
                                NotifService()
                                    .cancelNotif(filteredTasks[index].id);
                                NotifService().cancelReminders(
                                    filteredTasks[index].reminders);
                              } else {
                                NotifService().cancelRepeatTaskNotifs(
                                    filteredTasks[index]);
                              }
                            }

                            ref
                                .read(taskRepositoryProvider.notifier)
                                .completeTask(filteredTasks[index]);

                            if (dismissedTask.nextActivity != null) {
                              ref
                                  .read(taskRepositoryProvider.notifier)
                                  .writeTask(dismissedTask
                                    ..id = null
                                    ..isComplete = false
                                    ..date = dismissedTask.repeatRule != null
                                        ? dismissedTask.repeatRule!
                                            .getNextOccurrenceDateTime(
                                            st: DateTime.now(),
                                          )
                                        : dismissedTask.date);
                            }
                          }
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
    );
  }
}

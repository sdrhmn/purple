import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/lifestyle/goals/data/goals_provider.dart';
import 'package:timely/modules/notifs/notif_service.dart';
import 'package:timely/modules/tasks/components/task_tile.dart';
import 'package:timely/modules/tasks/data/task_repository.dart';
import 'package:timely/modules/tasks/models/task_model.dart';
import 'package:timely/modules/tasks/ui/task_form_screen.dart';

class GoalsPage extends ConsumerStatefulWidget {
  const GoalsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoalsPageState();
}

class _GoalsPageState extends ConsumerState<GoalsPage> {
  @override
  Widget build(BuildContext context) {
    final providerOfTasks = ref.watch(goalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Goals")),
      body: providerOfTasks.when(
        data: (List<Task> tasks) {
          return RefreshIndicator(
            onRefresh: () {
              return Future.delayed(Duration.zero, () {
                ref.invalidate(goalsProvider);
              });
            },
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return TaskTile(
                  isProjectType: true,
                  task: tasks[index],
                  onDismissed:
                      (DismissDirection direction, Task dismissedTask) {
                    Task task = tasks[index];

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
                                  "Notifications and reminders cancelled for ${tasks[index].activity}")));
                        } else {
                          tasks[index].isComplete = !tasks[index].isComplete;
                          tasks[index].completedAt =
                              tasks[index].isComplete ? DateTime.now() : null;

                          if (tasks[index].isComplete) {
                            if (tasks[index].repeatRule == null) {
                              NotifService().cancelNotif(tasks[index].id);
                              NotifService()
                                  .cancelReminders(tasks[index].reminders);
                            } else {
                              NotifService()
                                  .cancelRepeatTaskNotifs(tasks[index]);
                            }
                          }

                          ref
                              .read(taskRepositoryProvider.notifier)
                              .completeTask(tasks[index]);

                          if (dismissedTask.nextActivity != null) {
                            ref.read(taskRepositoryProvider.notifier).writeTask(
                                dismissedTask
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
                    tasks.remove(task);
                  },
                ).padding(horizontal: 10);
              },
              itemCount: tasks.length,
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
                title: const Text("Create Goal"),
              ),
              body: const TaskFormScreen(
                allowProjectType: true,
              ),
            ),
          ),
        ),
        child: Icon(Icons.add, color: Colors.purple[700]),
      ),
    );
  }
}

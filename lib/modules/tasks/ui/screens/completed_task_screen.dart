import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/notifs/notif_service.dart';
import 'package:timely/modules/tasks/data/task_providers/completed_tasks_provider.dart';
import 'package:timely/modules/tasks/tokens.dart';
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
    final providerOfTasks = ref.watch(completedTasksProvider);

    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Readiness"),
            DropdownButton(
                borderRadius: BorderRadius.circular(5),
                underline: Container(),
                value: filter,
                items: [
                  for (int i in Iterable.generate(filters.length))
                    DropdownMenuItem(
                        value: filters.keys.toList()[i],
                        child: Text(
                          filters.values.toList()[i],
                        ).padding(all: 5))
                ],
                onChanged: (flt) {
                  setState(() {
                    filter = flt!;
                  });
                })
          ],
        ).padding(horizontal: 20).height(60).card(),
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
                        ref.invalidate(completedTasksProvider);
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
                                onDismissed: (DismissDirection direction,
                                    Task dismissedTask) {
                                  tasks[date]!.remove(task);
                                  setState(() {
                                    if (direction ==
                                        DismissDirection.startToEnd) {
                                      ref
                                          .read(taskRepositoryProvider.notifier)
                                          .deleteTask(task);

                                      if (task.repeatRule == null) {
                                        NotifService().cancelNotif(task.id);
                                        NotifService()
                                            .cancelReminders(task.reminders);
                                      } else {
                                        NotifService()
                                            .cancelRepeatTaskNotifs(task);
                                      }
                                    } else {
                                      filteredTasks[index].isComplete =
                                          !filteredTasks[index].isComplete;
                                      filteredTasks[index].completedAt =
                                          filteredTasks[index].isComplete
                                              ? DateTime.now()
                                              : null;

                                      if (filteredTasks[index].isComplete) {
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

                                      if (dismissedTask.nextActivity != null) {
                                        ref
                                            .read(
                                                taskRepositoryProvider.notifier)
                                            .writeTask(dismissedTask
                                              ..id = null
                                              ..isComplete = false
                                              ..date = task.repeatRule != null
                                                  ? task.repeatRule!
                                                      .getNextOccurrenceDateTime(
                                                      st: DateTime.now(),
                                                    )
                                                  : dismissedTask.date);
                                      }
                                    }
                                  });
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
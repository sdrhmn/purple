import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/notifs/notif_service.dart';
import 'package:timely/modules/tasks/data/task_providers/upcoming_tasks_provider.dart';
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
    final providerOfTasks = ref.watch(upcomingTasksProvider);

    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Filter"),
            DropdownButton(
                borderRadius: BorderRadius.circular(5),
                underline: Container(),
                value: filter,
                items: [
                  for (int i in Iterable.generate(filters.length))
                    DropdownMenuItem(
                        value: filters[i],
                        child: Text('All Tasks.Ad-hoc Tasks.Exercises'
                                .split(".")[i])
                            .padding(all: 5))
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
                          Text(DateFormat(DateFormat.ABBR_MONTH_DAY)
                                  .format(date))
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
                                onDismissed: (DismissDirection direction) {
                                  setState(() {
                                    if (direction ==
                                        DismissDirection.startToEnd) {
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

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
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
                                    }
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

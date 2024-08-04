import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/tasks/data/task_providers/completed_tasks_provider.dart';
import 'package:timely/modules/tasks/ui/task_form_screen.dart';
import 'package:timely/modules/tasks/task_model.dart';
import 'package:timely/modules/tasks/data/task_repository.dart';
import '../../components/task_tile.dart';

class CompletedTaskScreen extends ConsumerStatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<CompletedTaskScreen> {
  int pageIndex = 0;
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
    List<String> filters = ['all', 'routine', 'ad-hoc', 'exercise'];
    final providerOfTasks = ref.watch(completetdTasksProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(100, 100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text("Filter"),
            DropdownButton(
                borderRadius: BorderRadius.circular(5),
                underline: Container(),
                value: filters[pageIndex],
                items: [
                  for (String filter in filters)
                    DropdownMenuItem(
                        value: filter,
                        child: Text(filter.toUpperCase()).padding(all: 5))
                ],
                onChanged: (filter) {
                  setState(() {
                    pageIndex = filters.indexOf(filter!);
                    _pageViewController.animateToPage(pageIndex,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  });
                }).decorated().padding(all: 5)
          ],
        ).card().padding(all: 10),
      ),
      body: providerOfTasks.when(
        data: (Map<DateTime, List<Task>> tasks) {
          return PageView(
            controller: _pageViewController,
            onPageChanged: (value) {
              setState(() {
                pageIndex = value;
              });
            },
            children: List.generate(4, (i) {
              return RefreshIndicator(
                  onRefresh: () {
                    return Future.delayed(Duration.zero, () {
                      ref.invalidate(completetdTasksProvider);
                    });
                  },
                  child: ListView(
                    children: [
                      for (DateTime date in tasks.keys) ...{
                        Text(DateFormat(DateFormat.ABBR_MONTH_DAY).format(date))
                            .padding(all: 10)
                            .card()
                            .center(),
                        const SizedBox(
                          height: 10,
                        ),
                        ...() {
                          List<Task> filteredTasks = tasks[date]!
                              .where(
                                (task) => filters[i] != 'all'
                                    ? task.type == filters[i]
                                    : true,
                              )
                              .toList();
                          return List.generate(filteredTasks.length, (index) {
                            Task task = filteredTasks[index];
                            return TaskTile(
                              task: task,
                              onCheckboxChanged: (bool? value) {
                                setState(() {
                                  tasks[date]![index].isComplete = value!;
                                  ref
                                      .read(taskRepositoryProvider.notifier)
                                      .completeTask(task);
                                });
                              },
                              onLongPressed: () {
                                setState(() {
                                  ref
                                      .read(taskRepositoryProvider.notifier)
                                      .deleteTask(task);
                                  tasks[date]!.removeAt(index);
                                });
                              },
                            ).padding(bottom: 10);
                          });
                        }()
                      },
                      const SizedBox(height: 70),
                    ],
                  )).padding(all: 10);
            }),
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

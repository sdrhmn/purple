import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
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
    final providerOfTasks = ref.watch(todaysTasksProvider);

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
                      ref.invalidate(todaysTasksProvider);
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
                          onCheckboxChanged: (bool? value) {
                            setState(() {
                              filteredTasks[index].isComplete = value!;
                              ref
                                  .read(taskRepositoryProvider.notifier)
                                  .completeTask(filteredTasks[index]);
                            });
                          },
                          onLongPressed: () {
                            setState(() {
                              ref
                                  .read(taskRepositoryProvider.notifier)
                                  .deleteTask(filteredTasks[index]);
                              tasks.removeAt(index);
                            });
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
}

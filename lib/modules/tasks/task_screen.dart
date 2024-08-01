import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tasks/components/filter_bar.dart';
import 'package:timely/modules/tasks/task_form_screen.dart';
import 'package:timely/modules/tasks/task_model.dart';
import 'package:timely/modules/tasks/task_repository.dart';
import 'package:timely/modules/tasks/tasks_provider.dart';

import 'components/task_tile.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  String selection = "all";

  @override
  Widget build(BuildContext context) {
    final providerOfTasks = ref.watch(tasksProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(100, 100),
        child: Container(
          color: Colors.black45,
          child: FilterBar(
              selection: selection,
              onSelectionChanged: (sel) {
                selection = sel.first.toString();
                setState(() {});
              }),
        ),
      ),
      body: providerOfTasks.when(
        data: (List<Task> tasks) {
          tasks = selection == "all"
              ? tasks
              : tasks.where((task) => task.type == selection).toList();

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: RefreshIndicator(
              onRefresh: () {
                return Future.delayed(Duration.zero, () {
                  ref.invalidate(tasksProvider);
                });
              },
              child: ListView.separated(
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return TaskTile(
                    task: tasks[index],
                    onCheckboxChanged: (bool? value) {
                      setState(() {
                        tasks[index].isComplete = value!;
                        ref
                            .read(taskRepositoryProvider.notifier)
                            .updateTask(tasks[index]);
                      });
                    },
                    onLongPressed: () {
                      setState(() {
                        ref
                            .read(taskRepositoryProvider.notifier)
                            .deleteTask(tasks[index]);
                        tasks.removeAt(index);
                      });
                    },
                  );
                },
                itemCount: tasks.length,
              ),
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
      floatingActionButton: FloatingActionButton.large(
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
        child: const Icon(Icons.add),
      ),
    );
  }
}

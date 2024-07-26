import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/tasks/task_form_screen.dart';
import 'package:timely/modules/tasks/task_model.dart';
import 'package:timely/modules/tasks/tasks_provider.dart';
import 'package:timely/reusables.dart';

class TaskScreen extends ConsumerWidget {
  const TaskScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerOfTasks = ref.watch(tasksProvider);

    return Scaffold(
      body: providerOfTasks.when(
        data: (List<Task> tasks) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                return TaskTile(task: tasks[index]);
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

class TaskTile extends ConsumerWidget {
  final Task task;
  const TaskTile({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context, ref) {
    return ListTile(
      onLongPress: () {
        // Delete task
        final store = ref.read(storeProvider).requireValue;
        final box = store.box<DataTask>();

        box.remove(task.id);
        ref.invalidate(tasksProvider);
      },
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: const Text("Edit Task"),
              ),
              body: TaskFormScreen(
                task: task,
              ),
            ),
          ),
        );
      },
      title: Text(task.activity),
      trailing: Text(task.time.format(context)).textStyle(
        const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w300,
        ),
      ),
    ).decorated(
      color: Colors.purple[700],
      borderRadius: BorderRadius.circular(7),
    );
  }
}

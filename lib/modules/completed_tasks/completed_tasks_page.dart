import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/completed_tasks/completed_tasks_provider.dart';
import 'package:timely/modules/completed_tasks/task_model.dart';
import 'package:timely/reusables.dart';

class CompletedTasksPage extends ConsumerWidget {
  const CompletedTasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerOfCompletedTasks = ref.watch(completedTasksProvider);

    return providerOfCompletedTasks.when(
      data: (Map<String, List<Task>> tasks) {
        return Stack(
          children: [
            ListView(
              children: [
                for (String date in tasks.keys) ...[
                  ListTile(
                    title: Text(
                      date,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  for (Task task in tasks[date]!) ...[
                    TaskTile(
                      task: task,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ]
                ]
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: Container(),
                ),
                NavigationRowMolecule(
                  onPressedHome: () =>
                      ref.read(tabIndexProvider.notifier).setIndex(12),
                  hideAddButton: true,
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            )
          ],
        );
      },
      error: (_, __) => const Text("ERROR"),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.green,
      textColor: Colors.white,
      iconColor: Colors.white,
      subtitleTextStyle:
          const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
      title: Text(task.name),
      leading: CircleAvatar(
        backgroundColor: Colors.green[600],
        radius: 16,
        child: const Icon(Icons.done),
      ),
      trailing: Icon(task.tabNumber != 3 ? Icons.repeat : null),
      subtitle: Text(
          "Completed at ${TimeOfDay.fromDateTime(task.timestamp!).format(context)}"),
    );
  }
}

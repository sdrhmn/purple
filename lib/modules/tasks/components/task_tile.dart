import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/tasks/task_form_screen.dart';
import 'package:timely/modules/tasks/task_model.dart';
import 'package:timely/modules/tasks/task_repository.dart';
import 'package:timely/modules/tasks/tasks_provider.dart';

class TaskTile extends ConsumerWidget {
  final Task task;
  const TaskTile({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context, ref) {
    return ListTile(
      title: Text(task.activity).padding(all: 10),
      subtitle: task.repeatRule != null
          ? Text(
              task.repeatRule!.getRepetitionSummary(),
              style: const TextStyle(
                fontStyle: FontStyle.italic,
              ),
            )
          : null,
      trailing: task.time == null
          ? const Text("")
          : Text(task.time!.format(context)).textStyle(
              const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
      tileColor: Colors.purple[800],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7),
      ),
      onLongPress: () {
        ref.read(taskRepositoryProvider.notifier).deleteTask(task);
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/tasks/ui/task_form_screen.dart';
import 'package:timely/modules/tasks/task_model.dart';

class TaskTile extends ConsumerWidget {
  final Task task;
  final Function(bool? value) onCheckboxChanged;
  final Function() onLongPressed;
  const TaskTile({
    super.key,
    required this.task,
    required this.onCheckboxChanged,
    required this.onLongPressed,
  });

  @override
  Widget build(BuildContext context, ref) {
    DateTime now = DateTime.now();

    return [
      Checkbox(
          activeColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          value: task.isComplete,
          onChanged: (value) => onCheckboxChanged(value)).scale(all: 1.2),
      const SizedBox(width: 10),
      ListTile(
        title: Text(
          task.activity,
          style: TextStyle(
            decoration: task.isComplete ? TextDecoration.lineThrough : null,
          ),
        ).padding(all: 10),
        subtitle: (task.date?.copyWith(
                        hour: task.time?.hour, minute: task.time?.minute) ??
                    now)
                .isBefore(now)
            ? Text(
                "Overdue since ${DateFormat(DateFormat.ABBR_MONTH_DAY).format(task.date!)}, ${task.time!.format(context)}")
            : task.repeatRule != null
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
                TextStyle(
                  fontSize: 18,
                  decoration:
                      task.isComplete ? TextDecoration.lineThrough : null,
                  fontWeight: FontWeight.w300,
                ),
              ),
        tileColor: (task.date?.copyWith(
                        hour: task.time?.hour, minute: task.time?.minute) ??
                    now)
                .isBefore(now)
            ? Colors.orange[900]
            : task.isComplete
                ? Colors.green[800]
                : Colors.purple[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        onLongPress: () => onLongPressed(),
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
      ).expanded(),
    ].toRow();
  }
}

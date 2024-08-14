import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/tasks/ui/task_form_screen.dart';
import 'package:timely/modules/tasks/models/task_model.dart';

class TaskTile extends ConsumerWidget {
  final Task task;
  final Function(DismissDirection direction) onDismissed;
  const TaskTile({
    super.key,
    required this.task,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context, ref) {
    DateTime now = DateTime.now();
    String durationText = task.duration != null
        ? "Duration: ${task.duration!.inHours} hours${task.duration!.inMinutes % 60 != 0 ? ' and ${task.duration!.inMinutes % 60} minutes' : ''}${task.time != null ? '\nUp till ${DateFormat('MMM dd, H:mm').format((task.date ?? DateTime.now()).copyWith(hour: task.time!.hour, minute: task.time!.minute).add(task.duration!))}' : ''}"
        : "";

    return Dismissible(
      key: Key(task.id.toString()),
      confirmDismiss: (direction) async {
        bool dismiss = false;
        if (direction == DismissDirection.startToEnd) {
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title:
                      const Text("Are you sure you want to delete this task?"),
                  actions: [
                    IconButton.filled(
                      onPressed: () {
                        dismiss = true;
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.done),
                      color: Colors.red,
                    ),
                    IconButton.filled(
                      onPressed: () {
                        dismiss = false;
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.cancel),
                    ),
                  ],
                );
              });
        } else {
          // Direction is opposite, action == "COMPLETE"
          dismiss = true;
        }
        return dismiss;
      },
      onDismissed: (DismissDirection direction) => onDismissed(direction),
      child: ListTile(
        title: Text(
          task.activity,
          style: TextStyle(
            decoration: task.isComplete ? TextDecoration.lineThrough : null,
          ),
        ).padding(all: 10),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            task.description.isNotEmpty ? Text(task.description) : Container(),
            const SizedBox(height: 20),
            task.isComplete
                ? Row(
                    children: [
                      const Icon(Icons.done).padding(right: 5),
                      Flexible(
                        child: Text(
                                "Completed on ${DateFormat("MMM dd 'at' H:m").format(task.completedAt!)}")
                            .fontSize(14),
                      ),
                    ],
                  )
                : Container(),
            (task.date?.copyWith(hour: 23, minute: 59) ?? now).isBefore(now) &&
                    !task.isComplete
                ? Text(
                    "Overdue since ${DateFormat(DateFormat.ABBR_MONTH_DAY).format(task.date!)}${task.time != null ? ', ${task.time!.format(context)}' : ''}")
                : task.repeatRule != null
                    ? Row(
                        children: [
                          const Icon(Icons.repeat).padding(right: 5),
                          Flexible(
                            child: Text(
                              task.repeatRule!.getRepetitionSummary(),
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
            const SizedBox(height: 10),
            task.duration != null
                ? Row(
                    children: [
                      const Icon(Icons.alarm).padding(right: 5),
                      Flexible(
                        child: Text(
                          durationText,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
        trailing: task.time == null
            ? const Text("")
            : Text(task.time!.format(context)).textStyle(
                TextStyle(
                  fontSize: 18,
                  decoration:
                      task.isComplete ? TextDecoration.lineThrough : null,
                  fontWeight: FontWeight.w500,
                ),
              ),
        tileColor:
            (task.date?.copyWith(hour: 23, minute: 59) ?? now).isBefore(now) &&
                    !task.isComplete
                ? Colors.orange[900]
                : task.isComplete
                    ? Colors.green[800]
                    : Colors.purple[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
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
      ),
    );
  }
}

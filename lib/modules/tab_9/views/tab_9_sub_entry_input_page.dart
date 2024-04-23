import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_9/views/tab_9_sub_entry_input_template.dart';
import 'package:timely/modules/tab_9/controllers/input/sub_entry_input_controller.dart';
import 'package:timely/modules/tab_9/controllers/output/output_controller.dart';

class Tab9SubEntryInputPage extends ConsumerWidget {
  final String entryID;
  const Tab9SubEntryInputPage({
    super.key,
    required this.entryID,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subEntry = ref.watch(tab9SubEntryInputProvider);
    final controller = ref.read(tab9SubEntryInputProvider.notifier);

    return Tab9SubEntryInputTemplate(
      subEntry: subEntry,
      onDateChanged: (date) => controller.setDate(date),
      onTimeChanged: (time) => controller.setTime(
        [time.hour, time.minute].join(":"),
      ),
      onTaskChanged: (task) => controller.setTask(task),
      onDescriptionChanged: (description) =>
          controller.setDescription(description),
      onSubmitPressed: () {
        ref.read(tab9SubEntryInputProvider.notifier).syncToDB(entryID);
        ref.invalidate(tab9OutputProvider);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Submitted successfully..."),
            duration: Duration(seconds: 1),
          ),
        );
      },
      onCancelPressed: () => Navigator.pop(context),
    );
  }
}

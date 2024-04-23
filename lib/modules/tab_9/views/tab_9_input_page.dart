import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_9/views/tab_9_input_template.dart';
import 'package:timely/modules/tab_9/controllers/input/entry_input_controller.dart';
import 'package:timely/modules/tab_9/controllers/input/sub_entry_input_controller.dart';
import 'package:timely/modules/tab_9/controllers/output/output_controller.dart';

class Tab9InputPage extends ConsumerWidget {
  final bool? showSubEntryMolecule;

  const Tab9InputPage({
    super.key,
    this.showSubEntryMolecule,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(tab9EntryInputProvider);
    final subEntry = ref.watch(tab9SubEntryInputProvider);

    final entryController = ref.read(tab9EntryInputProvider.notifier);
    final subEntryController = ref.read(tab9SubEntryInputProvider.notifier);

    return Tab9InputTemplate(
      entry: entry,
      subEntry: subEntry,
      showSubEntryMolecule: showSubEntryMolecule,
      onConditionChanged: (condition) =>
          entryController.setCondition(condition),
      onCriticalityChanged: (index) => entryController.setCriticality(index),
      onDateChanged: (date) => subEntryController.setDate(date),
      onTimeChanged: (time) =>
          subEntryController.setTime([time.hour, time.minute].join(":")),
      onTaskChanged: (task) => subEntryController.setTask(task),
      onDescriptionChanged: (description) =>
          subEntryController.setDescription(description),
      onCareChanged: (care) => entryController.setCare(care),
      onLessonLearntChanged: (lessonLearnt) =>
          entryController.setLessonLearnt(lessonLearnt),
      onSubmitPressed: () {
        entryController.syncToDB(subEntry);

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

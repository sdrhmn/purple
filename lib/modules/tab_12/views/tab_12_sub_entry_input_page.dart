import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_12/views/tab_12_sub_entry_input_template.dart';
import 'package:timely/modules/tab_12/controllers/input/sub_entry_input_controller.dart';
import 'package:timely/modules/tab_12/controllers/output/output_controller.dart';

class Tab12SubEntryInputPage extends ConsumerWidget {
  final String entryID;
  const Tab12SubEntryInputPage({
    super.key,
    required this.entryID,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subEntry = ref.watch(tab12SubEntryInputProvider);
    final controller = ref.read(tab12SubEntryInputProvider.notifier);

    return Tab12SubEntryInputTemplate(
      subEntry: subEntry,
      onNextTaskChanged: (nextTask) => controller.setNextTask(nextTask),
      onSubmitPressed: () {
        ref.read(tab12SubEntryInputProvider.notifier).syncToDB(entryID);
        ref.invalidate(tab12OutputProvider);
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_8/views/tab_8_input_template.dart';
import 'package:timely/modules/tab_8/controllers/input_controller.dart';
import 'package:timely/modules/tab_8/controllers/output_controller.dart';

class Tab8InputPage extends ConsumerWidget {
  const Tab8InputPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(tab8InputProvider);
    final controller = ref.read(tab8InputProvider.notifier);

    return Tab8InputTemplate(
      model: model,
      onDateChanged: (date) => controller.setDate(date),
      onLSJChanged: (index) => controller.setLSJ(index),
      onPriorityChanged: (index) => controller.setHML(index),
      onTitleChanged: (title) => controller.setTitle(title),
      onDescriptionChanged: (description) =>
          controller.setDescription(description),
      onSubmitPressed: () {
        controller.syncToDB();
        ref.invalidate(tab8OutputProvider);
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

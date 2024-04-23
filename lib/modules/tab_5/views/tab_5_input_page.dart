import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_5/views/tab_5_input_template.dart';
import 'package:timely/modules/tab_5/controllers/input_controller.dart';
import 'package:timely/modules/tab_5/controllers/output_controller.dart';

class Tab5InputPage extends ConsumerWidget {
  const Tab5InputPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(tab5InputProvider);
    final controller = ref.read(tab5InputProvider.notifier);

    return Tab5InputTemplate(
      model: model,
      onDateChanged: (date) => controller.setDate(date),
      onSelectedItemsChangedList:
          [controller.setSScore, controller.setPScore, controller.setWScore]
              .map(
                (setter) => (index) => setter(index),
              )
              .toList(),
      onWeightChanged: (weight) => controller.setWeight(weight),
      onSubmitPressed: () {
        ref.read(tab5InputProvider.notifier).syncToDB();
        ref.invalidate(tab5OutputProvider);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Successfully Submitted!",
            ),
            duration: Duration(seconds: 1),
          ),
        );
      },
      onCancelPressed: () => Navigator.pop(context),
    );
  }
}

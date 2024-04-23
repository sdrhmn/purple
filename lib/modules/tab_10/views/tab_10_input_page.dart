import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_10/views/tab_10_input_template.dart';
import 'package:timely/modules/tab_10/controllers/input_controller.dart';
import 'package:timely/modules/tab_10/controllers/output_controller.dart';

class Tab10InputPage extends ConsumerWidget {
  const Tab10InputPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(tab10InputProvider);
    final controller = ref.read(tab10InputProvider.notifier);

    return Tab10InputTemplate(
      model: model,
      onDateChanged: (date) => controller.setDate(date),
      onAmountChanged: (amount) => controller.setAmount(amount),
      onTitleChanged: (title) => controller.setText_1(title),
      selectedOption: model.option,
      onOptionSelected: (option) => controller.setOption(option),
      onSubmitPressed: () {
        controller.syncToDB();
        ref.invalidate(tab10OutputProvider);
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

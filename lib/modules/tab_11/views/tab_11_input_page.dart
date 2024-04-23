import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_11/views/tab_11_input_template.dart';
import 'package:timely/modules/tab_11/controllers/input_controller.dart';

class Tab11InputPage extends ConsumerWidget {
  const Tab11InputPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(tab11InputProvider);
    final controller = ref.read(tab11InputProvider.notifier);

    return Tab11InputTemplate(
      model: model,
      onItemChanged: (item) => controller.setItem(item),
      onQuantityChanged: (qty) => controller.setQuantity(qty),
      onUrgencyChanged: (isUrgent) => controller.setUrgency(isUrgent),
      onSubmitPressed: () {
        controller.syncToDB();
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

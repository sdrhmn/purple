import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_3/views/tab_3_input_template.dart';
import 'package:timely/modules/tab_3/controllers/input_controller.dart';
import 'package:timely/modules/tab_3/tokens/tab_3_constants.dart';

class Tab3InputPage extends ConsumerStatefulWidget {
  const Tab3InputPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _Tab3InputPageState();
}

class _Tab3InputPageState extends ConsumerState<Tab3InputPage> {
  @override
  Widget build(BuildContext context) {
    final model = ref.watch(tab3InputProvider);
    final controller = ref.watch(tab3InputProvider.notifier);

    return Tab3InputTemplate(
      model: model,
      onActivityChanged: (activity) => controller.setActivity(activity),
      onScheduleChanged: (isScheduled) {
        if (!isScheduled) {
          controller.removeDateAndTime();
        } else {
          controller.setDate(DateTime.now());
          controller.setTime(TimeOfDay.now());
        }

        setState(() {});
      },
      onDateChanged: (date) => controller.setDate(date),
      onTimeChanged: (time) => controller.setTime(time),
      onPriorityChanged: (index) => controller.setPriority(index),
      onCancelPressed: () => Navigator.pop(context),
      onSubmitPressed: () {
        if (model.text_1.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "You cannot leave the activity field blank!",
              ),
              duration: Duration(seconds: 1),
            ),
          );
        } else {
          controller.syncToDB();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                Tab3Constants.submissionStatusMessage,
              ),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
    );
  }
}

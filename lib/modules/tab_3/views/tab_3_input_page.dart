import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timely/modules/notifs/notif_service.dart';
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
      onCancelPressed: () {
        Navigator.pop(context);
        ref.invalidate(tab3InputProvider);
      },
      onSubmitPressed: (model) {
        if (model.name.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "You cannot leave the activity field blank!",
              ),
              duration: Duration(seconds: 1),
            ),
          );
          ref.invalidate(tab3InputProvider);
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
        //----- Schedule Notification --------
        if (model.startTime != null && model.date != null) {
          // NotifService().scheduleAdHocTaskNotifs(model);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Scheduled${model.reminders.isNotEmpty ? ' reminders and' : ''} a notification for ${model.name} at ${model.startTime!.format(context)} on ${DateFormat(DateFormat.ABBR_MONTH_DAY).format(model.date!)}"),
          ));
        } else if (model.date != null && model.startTime == null) {
          NotifService()
              .scheduleNotif(model, model.date!.copyWith(hour: 6, minute: 0));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Scheduled a notification for ${model.name} at 6 AM in the morning on ${DateFormat(DateFormat.ABBR_MONTH_DAY).format(model.date!)}"),
          ));
        }
      },
      onAddReminder: (model) {
        controller.setModel(model);
      },
      onSliderChanged: (model) {
        controller.setModel(model);
      },
      onDeleteReminder: (model) {
        controller.setModel(model);
      },
      onTimeSwitchPressed: (bool value) {
        controller.setModel(value == true
            ? model.copyWith(time: TimeOfDay.now())
            : model.nullify(time: true));
      },
    );
  }
}

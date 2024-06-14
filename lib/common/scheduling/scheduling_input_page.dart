import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/scheduling/repeats_template.dart';
import 'package:timely/common/scheduling/scheduling_input_template.dart';
import 'package:timely/common/scheduling/input_controller.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/modules/notifs/notif_service.dart';

class SchedulingInputPage extends ConsumerStatefulWidget {
  final bool? showDurationSelector;
  final int tabNumber;
  const SchedulingInputPage({
    super.key,
    this.showDurationSelector,
    required this.tabNumber,
  });

  @override
  ConsumerState<SchedulingInputPage> createState() =>
      _SchedulingInputPageState();
}

class _SchedulingInputPageState extends ConsumerState<SchedulingInputPage> {
  @override
  Widget build(BuildContext context) {
    final providerOfSchedulingModel = ref.watch(schedulingInputProvider);
    final controller = ref.read(schedulingInputProvider.notifier);

    return SchedulingInputTemplate(
      showDurationSelector: widget.showDurationSelector,
      onActivityChanged: (activity) => controller.setName(activity),
      onStartTimeChanged: (time) => controller.setStartTime(time),
      onHoursChanged: (hours) => controller.setDuration(
        Duration(
            hours: hours,
            minutes: providerOfSchedulingModel.dur.inMinutes % 60),
      ),
      onMinutesChanged: (minutes) => controller.setDuration(
        Duration(
            hours: providerOfSchedulingModel.dur.inHours, minutes: minutes),
      ),
      onRepeatsButtonPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Consumer(
              builder: (context, ref, child) {
                final localProv = ref.watch(schedulingInputProvider);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.p_24),
                  child: RepeatsTemplate(
                    model: localProv,
                    onBasisChanged: (basis) => controller.setBasis(basis),
                    onFrequencyChanged: (frequency) =>
                        controller.setFrequency(frequency),
                    onEveryChanged: (every) => controller.setEvery(every),
                    onEndDateChanged: (endDate) =>
                        controller.setEndDate(endDate),
                    onWeekdaySelectionsChanged: (selections) =>
                        controller.setWeeklyRepetitions(selections),
                    onMonthlySelectionsChanged: (selections) =>
                        controller.setMonthlyRepetitions(selections),
                    onOrdinalPositionChanged: (ordinalPosition) {
                      controller.setOrdinalPosition(ordinalPosition);
                    },
                    onWeekdayIndexChanged: (weekdayIndex) {
                      controller.setWeekdayIndex(weekdayIndex);
                    },
                    onYearlySelectionsChanged: (selections) {
                      controller.setYearlyRepetitions(selections);
                    },
                    onPressedCancel: () async {
                      Navigator.pop(context);
                      await Future.delayed(const Duration(milliseconds: 200));
                      controller.setBasis(Basis.day);
                      controller.setFrequency("Daily");
                    },
                    onPressedDone: () {
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            );
          },
        );
      },
      model: providerOfSchedulingModel,
      onAddReminder: (SchedulingModel model) {
        controller.setModel(model);
      },
      onSliderChanged: (model) {
        controller.setModel(model);
      },
      onDeleteReminder: (SchedulingModel model) {
        controller.setModel(model);
      },
      onSubmitButtonPressed: (model) {
        if (providerOfSchedulingModel.name!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Do not leave activity text blank!")));
        } else {
          if (providerOfSchedulingModel.uuid == null) {
            controller.syncToDB(widget.tabNumber);
          } else {
            controller.syncEditedModel(widget.tabNumber);
          }
          Navigator.pop(context);
        }

        // ------ Schedule Notifs for today? and tomorrow? -------
        NotifService().scheduleRepeatTaskNotifs(model);
      },
    );
  }
}

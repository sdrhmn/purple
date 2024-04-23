import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/common/scheduling/repeats_template.dart';
import 'package:timely/common/scheduling/scheduling_input_template.dart';
import 'package:timely/common/scheduling/input_controller.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/app_theme.dart';

class SchedulingInputPage extends ConsumerWidget {
  final bool? showDurationSelector;
  final int tabNumber;
  const SchedulingInputPage({
    super.key,
    this.showDurationSelector,
    required this.tabNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final providerOfTab2Model = ref.watch(tab2InputProvider);
    final controller = ref.read(tab2InputProvider.notifier);

    return SchedulingInputTemplate(
      showDurationSelector: showDurationSelector,
      onActivityChanged: (activity) => controller.setName(activity),
      onStartTimeChanged: (time) => controller.setStartTime(time),
      onHoursChanged: (hours) => controller.setDuration(
        Duration(hours: hours, minutes: providerOfTab2Model.dur.inMinutes % 60),
      ),
      onMinutesChanged: (minutes) => controller.setDuration(
        Duration(hours: providerOfTab2Model.dur.inHours, minutes: minutes),
      ),
      onRepeatsButtonPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Consumer(
              builder: (context, ref, child) {
                final localProv = ref.watch(tab2InputProvider);

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
      model: providerOfTab2Model,
      onSubmitButtonPressed: () {
        if (providerOfTab2Model.name!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Do not leave activity text blank!")));
        } else {
          if (providerOfTab2Model.uuid == null) {
            controller.syncToDB(tabNumber);
          } else {
            controller.syncEditedModel(tabNumber);
          }
          Navigator.pop(context);
        }
      },
    );
  }
}

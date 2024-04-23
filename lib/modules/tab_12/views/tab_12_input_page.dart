import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/common/scheduling/repeats_template.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/modules/tab_12/views/tab_12_input_template.dart';
import 'package:timely/modules/tab_12/controllers/input/entry_input_controller.dart';
import 'package:timely/modules/tab_12/controllers/input/sub_entry_input_controller.dart';
import 'package:timely/modules/tab_12/controllers/output/output_controller.dart';

class Tab12InputPage extends ConsumerWidget {
  final bool? showSubEntryMolecule;

  const Tab12InputPage({
    super.key,
    this.showSubEntryMolecule,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = ref.watch(tab12EntryInputProvider);
    final subEntry = ref.watch(tab12SubEntryInputProvider);

    final entryController = ref.read(tab12EntryInputProvider.notifier);
    final subEntryController = ref.read(tab12SubEntryInputProvider.notifier);

    return Tab12InputTemplate(
      showSubEntryMolecule: showSubEntryMolecule,
      entry: entry,
      subEntry: subEntry,
      onActivityChanged: (activity) => entryController.setActivity(activity),
      onObjectiveChanged: (objective) =>
          entryController.setObjective(objective),
      onImportanceChanged: (index) => entryController.setImportance(index),
      onStartDateChanged: (startDate) =>
          entryController.setStartDate(startDate),
      onEndDateChanged: (endDate) => entryController.setEndDate(endDate),
      onStartTimeChanged: (startTime) =>
          entryController.setStartTime(startTime),
      onEndTimeChanged: (endTime) => entryController.setEndTime(endTime),
      onNextTaskChanged: (nextTask) => subEntryController.setNextTask(nextTask),
      onSubmitPressed: () {
        entryController.syncToDB(subEntry);
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
      onPressedRepeatsButton: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Consumer(
              builder: (context, ref, child) {
                final localProv = ref.watch(tab12EntryInputProvider);
                final localCont = ref.read(tab12EntryInputProvider.notifier);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSizes.p_16),
                  child: RepeatsTemplate(
                    model: localProv.tab2Model,
                    onFrequencyChanged: (frequency) =>
                        localCont.setFrequency(frequency),
                    onEveryChanged: (every) => localCont.setEvery(every),
                    onEndDateChanged: (endDate) =>
                        localCont.setEndDate(endDate),
                    onWeekdayIndexChanged: (index) =>
                        localCont.setWeekdayIndex(index),
                    onOrdinalPositionChanged: (pos) =>
                        localCont.setOrdinalPosition(pos),
                    onWeekdaySelectionsChanged: (selections) =>
                        localCont.setWeeklyRepetitions(selections),
                    onMonthlySelectionsChanged: (selections) =>
                        localCont.setMonthlyRepetitions(selections),
                    onYearlySelectionsChanged: (selections) =>
                        localCont.setYearlyRepetitions(selections),
                    onBasisChanged: (basis) => localCont.setBasis(basis),
                    onPressedCancel: () async {
                      Navigator.pop(context);
                      await Future.delayed(const Duration(milliseconds: 200));
                      localCont.setBasis(Basis.day);
                      localCont.setFrequency("Daily");
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/values.dart';

import 'package:timely/reusables.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'duration_selection.dart';

class SchedulingInputTemplate extends StatelessWidget {
  final bool? showDurationSelector;

  final SchedulingModel model;
  final Function(String activity) onActivityChanged;
  final Function(TimeOfDay time) onStartTimeChanged;
  final Function(int hours) onHoursChanged;
  final Function(int minutes) onMinutesChanged;
  final VoidCallback onRepeatsButtonPressed;
  final VoidCallback onSubmitButtonPressed;

  const SchedulingInputTemplate({
    super.key,
    this.showDurationSelector,
    required this.onActivityChanged,
    required this.onStartTimeChanged,
    required this.onHoursChanged,
    required this.onMinutesChanged,
    required this.onRepeatsButtonPressed,
    required this.model,
    required this.onSubmitButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          height: 40,
        ), // Some empty space at the top below the appbar.
        SizedBox(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
            child: TextFormFieldAtom(
              initialValue: model.name,
              onChanged: (activity) => onActivityChanged(activity),
              hintText: Tab2Headings.activity,
            ),
          ),
        ),
        const Divider(height: 30),
        Column(
          children: [
            // Repeat button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_24),
              child: TitleWidgetRowMolecule(
                title: Tab2Headings.time,
                widget: TimeButtonAtom(
                    initialTime: model.startTime,
                    onTimeChanged: (time) => onStartTimeChanged(time)),
              ),
            ),
            const Divider(height: 30),
            // End repeat
            const SizedBox(
              height: 10,
            ),
            showDurationSelector == false
                ? Container()
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.p_24),
                        child: TitleWidgetRowMolecule(
                          title: Tab2Headings.duration,
                          widget: Expanded(
                            child: DurationSelectionMolecule(
                              onHoursChanged: (int hours) =>
                                  onHoursChanged(hours),
                              onMinutesChanged: (int minutes) =>
                                  onMinutesChanged(minutes),
                              initalHourIndex: model.dur.inHours,
                              initalMinuteIndex: model.dur.inMinutes % 60,
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 40,
                      ),
                    ],
                  ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_24),
              child: TitleWidgetRowMolecule(
                title: Tab2Headings.repeats,
                widget: TextButtonAtom(
                  text: model.frequency.toString(),
                  onPressed: () => onRepeatsButtonPressed(),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.p_8),
                child: Text(
                  model.getRepetitionSummary(),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
            const Divider(
              height: 30,
            ),

            CancelSubmitRowMolecule(
              onCancelPressed: () => Navigator.pop(context),
              onSubmitPressed: () => onSubmitButtonPressed(),
            ),

            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ],
    );
  }
}

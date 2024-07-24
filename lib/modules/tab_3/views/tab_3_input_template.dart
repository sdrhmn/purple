import 'package:flutter/material.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/common/reminder_sliders.dart';
import 'package:timely/reusables.dart';

import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/tab_3/models/ad_hoc_model.dart';
import 'package:timely/values.dart';

class Tab3InputTemplate extends StatelessWidget {
  final AdHocModel model;
  final Function(String activity) onActivityChanged;
  final Function(DateTime date) onDateChanged;
  final Function(TimeOfDay time) onTimeChanged;
  final Function(int index) onPriorityChanged;
  final Function(AdHocModel model) onSubmitPressed;
  final VoidCallback onCancelPressed;
  final Function(bool value) onScheduleChanged;
  final Function(dynamic model) onAddReminder;
  final Function(dynamic model) onDeleteReminder;
  final Function(dynamic model) onSliderChanged;
  final Function(bool value) onTimeSwitchPressed;

  const Tab3InputTemplate({
    super.key,
    required this.model,
    required this.onActivityChanged,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.onPriorityChanged,
    required this.onSubmitPressed,
    required this.onCancelPressed,
    required this.onScheduleChanged,
    required this.onAddReminder,
    required this.onSliderChanged,
    required this.onDeleteReminder,
    required this.onTimeSwitchPressed,
  });

  @override
  Widget build(BuildContext context) {
    bool scheduled =
        (model.date == null && model.startTime == null) ? false : true;

    List<Widget> children = [
      const SizedBox(
        height: 40,
      ),

      // Activity Text Field
      TextFormFieldAtom(
        initialValue: model.name,
        onChanged: onActivityChanged,
        hintText: Tab3Headings.activity,
      ),

      // "Scheduled" Switch
      Column(
        children: [
          TitleWidgetRowMolecule(
            title: Tab3Headings.scheduled,
            widget: Switch(
              value: scheduled,
              onChanged: (value) {
                onScheduleChanged(value);
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),

      // Date Button
      scheduled != false
          ? Column(
              children: [
                // Date Button
                TitleWidgetRowMolecule(
                  title: Tab3Headings.date,
                  widget: DateButtonAtom.large(
                    currentDate: model.date ?? DateTime.now(),
                    onDateChanged: onDateChanged,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                // Time Button
                TitleWidgetRowMolecule(
                  title: Tab3Headings.time,
                  widget: TimeButtonAtom.large(
                    initialTime: model.startTime,
                    onTimeChanged: onTimeChanged,
                  ),
                ),
              ],
            )
          : Container(),

      // Priority Picker
      TitleWidgetRowMolecule(
        title: Tab3Headings.priority,
        widget: CupertinoPickerAtom(
          itemExtent: 60,
          onSelectedItemChanged: onPriorityChanged,
          elements: "High,Medium,Low".split(","),
          initialItemIndex: model.priority,
          size: const Size(150, 120),
        ),
      ),

      // ------ Reminders ------
      model.date != null && model.startTime != null
          ? ReminderSliders(
              model: model,
              onAddReminder: (model) => onAddReminder(model),
              onSliderChanged: (model) => onSliderChanged(model),
              onDeleteReminder: (model) => onDeleteReminder(model))
          : Container(),

      // Cancel & Submit Row
      CancelSubmitRowMolecule(
        onSubmitPressed: () => onSubmitPressed(model),
        onCancelPressed: onCancelPressed,
      ),

      const SizedBox(
        height: 40,
      ),
    ];
    return ListView.separated(
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: index != children.length - 2 ? AppSizes.p_16 : 0,
        ),
        child: children[index],
      ),
      separatorBuilder: (context, index) => [
        0,
        2,
        children.length - 2,
        model.date == null || model.startTime == null
            ? children.length - 3
            : null
      ].contains(index)
          ? Container()
          : const Divider(height: 40),
      itemCount: children.length,
    );
  }
}

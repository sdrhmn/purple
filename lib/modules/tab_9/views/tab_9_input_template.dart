import 'package:flutter/material.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/reusables.dart';

import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/tab_9/views/tab_9_sub_entry_input_molecule.dart';
import 'package:timely/modules/tab_9/models/entry_model.dart';
import 'package:timely/modules/tab_9/models/sub_entry_model.dart';

class Tab9InputTemplate extends StatelessWidget {
  final Tab9EntryModel entry;
  final Tab9SubEntryModel subEntry;
  final void Function(String condition) onConditionChanged;
  final void Function(int index) onCriticalityChanged;
  final void Function(DateTime date) onDateChanged;
  final void Function(TimeOfDay time) onTimeChanged;
  final void Function(String task) onTaskChanged;
  final void Function(String description) onDescriptionChanged;
  final void Function(String care) onCareChanged;
  final void Function(String lessonLearnt) onLessonLearntChanged;
  final VoidCallback onSubmitPressed;
  final VoidCallback onCancelPressed;
  final bool? showSubEntryMolecule;

  const Tab9InputTemplate({
    super.key,
    required this.entry,
    required this.subEntry,
    required this.onConditionChanged,
    required this.onCriticalityChanged,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.onTaskChanged,
    required this.onDescriptionChanged,
    required this.onCareChanged,
    required this.onLessonLearntChanged,
    required this.onSubmitPressed,
    required this.onCancelPressed,
    this.showSubEntryMolecule,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          height: 20,
        ),

        // |--| Condition Text Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
          child: TextFormFieldAtom(
            initialValue: entry.condition,
            onChanged: onConditionChanged,
            hintText: "Condition",
          ),
        ),

        const Divider(
          height: 40,
        ),

        // |--| Criticality Picker
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
          child: TitleWidgetRowMolecule(
            title: "Criticality",
            widget: CupertinoPickerAtom(
              itemExtent: 60,
              onSelectedItemChanged: onCriticalityChanged,
              elements: "Insignificant,Low,Medium,High,Critical".split(","),
              initialItemIndex: entry.criticality,
              size: const Size(170, 200),
            ),
          ),
        ),

        const Divider(
          height: 40,
        ),

        showSubEntryMolecule == false
            ? Container()
            : Column(
                children: [
                  Tab9SubEntryInputMolecule(
                    subEntry: subEntry,
                    onDateChanged: onDateChanged,
                    onTimeChanged: onTimeChanged,
                    onTaskChanged: onTaskChanged,
                    onDescriptionChanged: onDescriptionChanged,
                  ),
                  const Divider(
                    height: 40,
                  ),
                ],
              ),

        // |--| Care Text Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
          child: TextFormFieldAtom(
            initialValue: entry.care,
            onChanged: onCareChanged,
            hintText: "Care",
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        // |--| [Lesson Learnt] Text Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
          child: TextFormFieldAtom(
            initialValue: entry.lessonLearnt,
            onChanged: onLessonLearntChanged,
            hintText: "Lesson Learnt",
          ),
        ),

        const Divider(
          height: 40,
        ),

        // |--| Cancel Submit Buttons
        CancelSubmitRowMolecule(
          onSubmitPressed: onSubmitPressed,
          onCancelPressed: onCancelPressed,
        ),

        const SizedBox(
          height: 40,
        ),
      ],
    );
  }
}

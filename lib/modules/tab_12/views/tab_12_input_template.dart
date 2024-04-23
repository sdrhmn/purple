import 'package:flutter/material.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/reusables.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/tab_12/views/connected_widgets_row_molecule.dart';
import 'package:timely/modules/tab_12/views/tab_12_sub_entry_input_molecule.dart';
import 'package:timely/modules/tab_12/models/entry_model.dart';
import 'package:timely/modules/tab_12/models/sub_entry_model.dart';

class Tab12InputTemplate extends StatelessWidget {
  final Tab12EntryModel entry;
  final Tab12SubEntryModel subEntry;
  final void Function(String activity) onActivityChanged;
  final void Function(String objective) onObjectiveChanged;
  final void Function(int index) onImportanceChanged;
  final void Function(DateTime startDate) onStartDateChanged;
  final void Function(DateTime endDate) onEndDateChanged;
  final void Function(TimeOfDay startTime) onStartTimeChanged;
  final void Function(TimeOfDay endTime) onEndTimeChanged;
  final ValueChanged<String> onNextTaskChanged;
  final VoidCallback onPressedRepeatsButton;
  final VoidCallback onSubmitPressed;
  final VoidCallback onCancelPressed;
  final bool? showSubEntryMolecule;

  const Tab12InputTemplate({
    super.key,
    required this.entry,
    required this.subEntry,
    required this.onSubmitPressed,
    required this.onCancelPressed,
    this.showSubEntryMolecule,
    required this.onActivityChanged,
    required this.onObjectiveChanged,
    required this.onImportanceChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onStartTimeChanged,
    required this.onEndTimeChanged,
    required this.onNextTaskChanged,
    required this.onPressedRepeatsButton,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          height: 20,
        ),

        // |--| [Assignment Name] Text Field
        Padding(
          padding: const EdgeInsets.all(AppSizes.p_16),
          child: TextFormFieldAtom(
            initialValue: entry.activity,
            onChanged: onActivityChanged,
            hintText: "Assignment Name",
          ),
        ),

        const Divider(
          height: 40,
        ),

        // |--| Objective Text Field
        Padding(
          padding: const EdgeInsets.all(AppSizes.p_16),
          child: TextFormFieldAtom(
            initialValue: entry.objective,
            onChanged: onObjectiveChanged,
            hintText: "Objective",
            isTextArea: true,
          ),
        ),

        const Divider(
          height: 40,
        ),

        // |--| Importance Picker
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
          child: TitleWidgetRowMolecule(
            title: "Importance",
            widget: CupertinoPickerAtom(
              itemExtent: 60,
              onSelectedItemChanged: onImportanceChanged,
              elements:
                  "Not at all Imp,Slightly Imp,Important,Fairly Imp,Very Imp"
                      .split(","),
              initialItemIndex: entry.importance,
              size: const Size(200, 200),
            ),
          ),
        ),

        const Divider(
          height: 40,
        ),

        // |--| Assignment Period
        TitleWidgetColumnMolecule(
          title: "Assignment Period",
          widget: SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
              child: ConnectedWidgetsRowMolecule(
                widgets: [
                  DateButtonAtom(
                    buttonSize: const Size(160, 60),
                    initialDate: entry.tab2Model.startDate!,
                    onDateChanged: onStartDateChanged,
                  ),
                  DateButtonAtom(
                    buttonSize: const Size(160, 60),
                    initialDate: entry.tab2Model.endDate!,
                    onDateChanged: onEndDateChanged,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(
          height: 40,
        ),

        // Time Allocation
        TitleWidgetColumnMolecule(
          title: "Time Allocation",
          widget: SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
              child: ConnectedWidgetsRowMolecule(
                widgets: [
                  TimeButtonAtom(
                    buttonSize: const Size(160, 60),
                    initialTime: entry.tab2Model.startTime,
                    onTimeChanged: onStartTimeChanged,
                  ),
                  TimeButtonAtom(
                    buttonSize: const Size(160, 60),
                    initialTime: entry.tab2Model.getEndTime(),
                    onTimeChanged: onEndTimeChanged,
                  ),
                ],
              ),
            ),
          ),
        ),

        const Divider(
          height: 40,
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
          child: TitleWidgetRowMolecule(
            title: "Repeats",
            widget: TextButtonAtom(
              onPressed: onPressedRepeatsButton,
              text: entry.tab2Model.frequency.toString(),
            ),
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        // |--| Repetition Summary
        Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.p_8),
            child: Text(
              entry.tab2Model.getRepetitionSummary(),
              style: AppTypography.italicStyle,
            ),
          ),
        ),

        const Divider(
          height: 40,
        ),

        showSubEntryMolecule == false
            ? Container()
            : Tab12SubEntryInputMolecule(
                subEntry: subEntry,
                onNextTaskChanged: onNextTaskChanged,
                showNextOccuringDate: false,
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

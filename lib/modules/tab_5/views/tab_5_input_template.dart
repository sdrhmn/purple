import 'package:flutter/material.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/common/cupertino_picker_widget.dart';
import 'package:timely/reusables.dart';
import 'package:timely/common/row_column_widgets.dart';

import 'package:timely/modules/tab_5/models/spw.dart';
import 'package:timely/values.dart';

class Tab5InputTemplate extends StatelessWidget {
  final SPWModel model;
  final void Function(DateTime date) onDateChanged;
  final List<Function(int index)> onSelectedItemsChangedList;
  final void Function(String weight) onWeightChanged;
  final VoidCallback onSubmitPressed;
  final VoidCallback onCancelPressed;

  const Tab5InputTemplate({
    super.key,
    required this.model,
    required this.onDateChanged,
    required this.onSelectedItemsChangedList,
    required this.onWeightChanged,
    required this.onSubmitPressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          height: 20,
        ),

        // Date Button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DateButtonAtom.large(
              initialDate: model.date,
              onDateChanged: onDateChanged,
            ),
          ],
        ),

        const Divider(
          height: 40,
        ),

        // Row of Cupertino Pickers
        CupertinoPickerRowOrganism(
          headers: [
            Tab4Headings.sScore,
            Tab4Headings.pScore,
            Tab4Headings.wScore,
          ],
          labels: [
            Tab4Headings.sliderHeadings,
            Tab4Headings.sliderHeadings,
            Tab4Headings.sliderHeadings,
          ],
          onSelectedItemsChangedList: onSelectedItemsChangedList,
          pickerContainerColors: [
            SPWPageColors.pickerColumnColors[0],
            SPWPageColors.pickerColumnColors[1],
            SPWPageColors.pickerColumnColors[2]
          ],
          pickerHeight: 120,
          initialItemIndices: [model.sScore, model.pScore, model.wScore],
        ),

        const Divider(
          height: 40,
        ),

        // Weight Text Field
        Column(
          children: [
            const Row(
              children: [
                SizedBox(
                  width: 20,
                ),
                Text("Weight in kg/lbs"),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
              child: TextFormFieldAtom(
                initialValue:
                    model.weight != null ? model.weight.toString() : "",
                onChanged: onWeightChanged,
                hintText: Tab4Headings.weightTextHint,
              ),
            ),
          ],
        ),

        const Divider(
          height: 40,
        ),

        // Cancel Submit Row
        CancelSubmitRowMolecule(
          onSubmitPressed: onSubmitPressed,
          onCancelPressed: onCancelPressed,
        ),

        const SizedBox(
          height: 40,
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/reusables.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/tab_10/models/tab_10_model.dart';

class Tab10InputTemplate extends StatelessWidget {
  final Tab10Model model;
  final int selectedOption;
  final void Function(DateTime date) onDateChanged;
  final void Function(String amount) onAmountChanged;
  final void Function(String title) onTitleChanged;
  final void Function(int option) onOptionSelected;
  final VoidCallback onSubmitPressed;
  final VoidCallback onCancelPressed;

  const Tab10InputTemplate({
    super.key,
    required this.model,
    required this.onDateChanged,
    required this.onAmountChanged,
    required this.selectedOption,
    required this.onOptionSelected,
    required this.onSubmitPressed,
    required this.onCancelPressed,
    required this.onTitleChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          height: 20,
        ),
        // |--| Date Button
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

        // |--| Amount Text Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
          child: TextFormFieldAtom(
            initialValue: model.amount != null ? model.amount.toString() : "",
            onChanged: onAmountChanged,
            hintText: "Amount",
          ),
        ),

        const Divider(
          height: 40,
        ),

        // |--| Title Text Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
          child: TextFormFieldAtom(
            initialValue: model.text_1,
            onChanged: onTitleChanged,
            hintText: "Title",
          ),
        ),

        const Divider(
          height: 40,
        ),

        // |--| Option Selector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
          child: TitleWidgetRowMolecule(
            title: "Option",
            widget: ToggleButtons(
              isSelected: List.generate(
                2,
                (index) => selectedOption == index + 1,
              ),
              onPressed: (index) => onOptionSelected(index + 1),
              children: "Op 1,Op 2".split(",").map((e) => Text(e)).toList(),
            ),
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
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/reusables.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/tab_11/models/tab_11_model.dart';

class Tab11InputTemplate extends StatelessWidget {
  final Tab11Model model;
  final void Function(String item) onItemChanged;
  final void Function(String qty) onQuantityChanged;
  final void Function(bool isUrgent) onUrgencyChanged;
  final VoidCallback onSubmitPressed;
  final VoidCallback onCancelPressed;

  const Tab11InputTemplate({
    super.key,
    required this.model,
    required this.onItemChanged,
    required this.onQuantityChanged,
    required this.onUrgencyChanged,
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

        // |--| Item Text Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
          child: TextFormFieldAtom(
            initialValue: model.item,
            onChanged: onItemChanged,
            hintText: "Item",
          ),
        ),

        const Divider(
          height: 60,
        ),

        // |--| Quantity Text Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
          child: TextFormFieldAtom(
            initialValue: model.qty == 0 ? "" : model.qty.toString(),
            onChanged: onQuantityChanged,
            hintText: "Quantity",
          ),
        ),

        const Divider(
          height: 60,
        ),

        // |--| Urgency Switch
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_24),
          child: TitleWidgetRowMolecule(
            title: "Urgent",
            widget: Switch(value: model.urgent, onChanged: onUrgencyChanged),
          ),
        ),

        const Divider(
          height: 60,
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

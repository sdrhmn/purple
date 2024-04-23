import 'package:flutter/material.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/tab_9/views/tab_9_sub_entry_input_molecule.dart';
import 'package:timely/modules/tab_9/models/sub_entry_model.dart';

class Tab9SubEntryInputTemplate extends StatelessWidget {
  final Tab9SubEntryModel subEntry;
  final void Function(DateTime date) onDateChanged;
  final void Function(TimeOfDay time) onTimeChanged;
  final void Function(String task) onTaskChanged;
  final void Function(String description) onDescriptionChanged;
  final VoidCallback onSubmitPressed;
  final VoidCallback onCancelPressed;

  const Tab9SubEntryInputTemplate({
    super.key,
    required this.subEntry,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.onTaskChanged,
    required this.onDescriptionChanged,
    required this.onSubmitPressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
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

        // Cancel Submit Row
        CancelSubmitRowMolecule(
          onSubmitPressed: onSubmitPressed,
          onCancelPressed: onCancelPressed,
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/tab_12/views/tab_12_sub_entry_input_molecule.dart';
import 'package:timely/modules/tab_12/models/sub_entry_model.dart';

class Tab12SubEntryInputTemplate extends StatelessWidget {
  final Tab12SubEntryModel subEntry;
  final void Function(String nextTask) onNextTaskChanged;
  final VoidCallback onSubmitPressed;
  final VoidCallback onCancelPressed;

  const Tab12SubEntryInputTemplate({
    super.key,
    required this.subEntry,
    required this.onNextTaskChanged,
    required this.onSubmitPressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Tab12SubEntryInputMolecule(
          subEntry: subEntry,
          onNextTaskChanged: onNextTaskChanged,
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

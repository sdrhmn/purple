import 'package:flutter/material.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/reusables.dart';
import 'package:timely/modules/tab_9/views/date_time_row_molecule.dart';
import 'package:timely/modules/tab_9/models/sub_entry_model.dart';

class Tab9SubEntryInputMolecule extends StatelessWidget {
  final Tab9SubEntryModel subEntry;
  final void Function(DateTime date) onDateChanged;
  final void Function(TimeOfDay time) onTimeChanged;
  final void Function(String task) onTaskChanged;
  final void Function(String description) onDescriptionChanged;

  const Tab9SubEntryInputMolecule({
    super.key,
    required this.subEntry,
    required this.onDateChanged,
    required this.onTimeChanged,
    required this.onTaskChanged,
    required this.onDescriptionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // |--| Date and Time Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
          child: DateTimeRowMolecule(
            initialDate: subEntry.date,
            onDateChanged: onDateChanged,
            initialTime: TimeOfDay.fromDateTime(
              DateTime(
                0,
                0,
                0,
                int.parse(subEntry.time.split(":")[0]),
                int.parse(subEntry.time.split(":")[1]),
              ),
            ),
            onTimeChanged: onTimeChanged,
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        // |--| Task Text Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
          child: TextFormFieldAtom(
            initialValue: subEntry.task,
            onChanged: onTaskChanged,
            hintText: "Task",
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        // |--| [Description and Update] Text Field
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
          child: TextFormFieldAtom(
            initialValue: subEntry.description,
            onChanged: onDescriptionChanged,
            hintText: "Description & Update",
          ),
        ),
      ],
    );
  }
}

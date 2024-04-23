import 'package:flutter/material.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/tab_9/views/tab_9_summary_molecule.dart';
import 'package:timely/modules/tab_9/models/entry_model.dart';
import 'package:timely/modules/tab_9/models/sub_entry_model.dart';

class Tab9SummaryTemplate extends StatelessWidget {
  final Map<Tab9EntryModel, List<Tab9SubEntryModel>> models;
  final void Function(
    DismissDirection direction,
    Tab9EntryModel entry,
    List<Tab9SubEntryModel> subEntries,
  ) onDismissed;
  final void Function(Tab9EntryModel entry) onTapEntry;
  final void Function(Tab9EntryModel entry, List<Tab9SubEntryModel> subEntries)
      onTapSubEntry;

  final VoidCallback onPressedHome;
  final VoidCallback onPressedAdd;

  const Tab9SummaryTemplate({
    super.key,
    required this.models,
    required this.onTapEntry,
    required this.onPressedHome,
    required this.onPressedAdd,
    required this.onDismissed,
    required this.onTapSubEntry,
  });

  @override
  Widget build(BuildContext context) {
    List<Tab9EntryModel> entries = models.keys.toList();

    return Stack(
      children: [
        ListView.separated(
          itemBuilder: (context, entryIndex) {
            Tab9EntryModel entry = entries[entryIndex];
            List<Tab9SubEntryModel> subEntries =
                models.values.toList()[entryIndex];

            Tab9SubEntryModel lastSubEntry = subEntries.last;

            return DismissibleEntryRowMolecule(
              onDismissed: (direction) =>
                  onDismissed(direction, entry, subEntries),
              child: Ink(
                color: entryIndex % 2 == 0
                    ? Colors.indigo[400]
                    : Colors.indigo[800],
                child: Tab9SummaryMolecule(
                  entry: entry,
                  subEntry: lastSubEntry,
                  onTapEntry: (entry) => onTapEntry(entry),
                  onTapSubEntry: (Tab9SubEntryModel subEntry) =>
                      onTapSubEntry(entry, subEntries),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(
            height: 0,
            thickness: 2,
            color: Colors.black,
          ),
          itemCount: entries.length,
        ),

        // Navigation Row
        Column(
          children: [
            const Spacer(),
            NavigationRowMolecule(
              onPressedHome: onPressedHome,
              onPressedAdd: onPressedAdd,
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        )
      ],
    );
  }
}

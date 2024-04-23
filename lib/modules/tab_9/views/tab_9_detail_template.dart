import 'package:flutter/material.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/tab_9/views/tab_9_entry_card_molecule.dart';
import 'package:timely/modules/tab_9/views/tab_9_sub_entry_card_molecule.dart';
import 'package:timely/modules/tab_9/models/entry_model.dart';
import 'package:timely/modules/tab_9/models/sub_entry_model.dart';

class Tab9DetailTemplate extends StatelessWidget {
  final Tab9EntryModel entry;
  final List<Tab9SubEntryModel> subEntries;
  final void Function(DismissDirection direction, Tab9EntryModel entry,
      Tab9SubEntryModel subEntry) onSubEntryDismissed;
  final void Function(Tab9EntryModel entry, Tab9SubEntryModel subEntry)
      onSubEntryTapped;
  final void Function(Tab9EntryModel entry) onPressedAdd;

  const Tab9DetailTemplate({
    super.key,
    required this.entry,
    required this.subEntries,
    required this.onSubEntryDismissed,
    required this.onPressedAdd,
    required this.onSubEntryTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            Container(
              color: Colors.indigo[900],
              child: Tab9EntryCardMolecule(
                entry: entry,
              ),
            ),
            const Divider(
              height: 20,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => onSubEntryTapped(entry, subEntries[index]),
                  child: DismissibleEntryRowMolecule(
                    onDismissed: (direction) => onSubEntryDismissed(
                      direction,
                      entry,
                      subEntries[index],
                    ),
                    child: Container(
                      color: Colors.indigoAccent,
                      child: Tab9SubEntryCardMolecule(
                        subEntry: subEntries[index],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                height: 0,
                thickness: 2,
                color: Colors.black,
              ),
              itemCount: subEntries.length,
            ),
          ],
        ),

        // |--| Add Button
        Column(
          children: [
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () => onPressedAdd(entry),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        )
      ],
    );
  }
}

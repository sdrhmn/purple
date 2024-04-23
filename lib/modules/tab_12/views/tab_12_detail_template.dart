import 'package:flutter/material.dart';
import 'package:timely/reusables.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/tab_12/views/tab_12_entry_card_molecule.dart';
import 'package:timely/modules/tab_12/models/entry_model.dart';
import 'package:timely/modules/tab_12/models/sub_entry_model.dart';

class Tab12DetailTemplate extends StatelessWidget {
  final Tab12EntryModel entry;
  final List<Tab12SubEntryModel> subEntries;
  final void Function(DismissDirection direction, Tab12EntryModel entry,
      Tab12SubEntryModel subEntry) onSubEntryDismissed;
  final void Function(Tab12EntryModel entry, Tab12SubEntryModel subEntry)
      onTapSubEntry;
  final void Function(Tab12EntryModel entry) onPressedAdd;

  const Tab12DetailTemplate({
    super.key,
    required this.entry,
    required this.subEntries,
    required this.onSubEntryDismissed,
    required this.onPressedAdd,
    required this.onTapSubEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            Container(
              color: Colors.indigo[900],
              child: Tab12EntryCardMolecule(
                entry: entry,
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return DismissibleEntryRowMolecule(
                  onDismissed: (direction) => onSubEntryDismissed(
                    direction,
                    entry,
                    subEntries[index],
                  ),
                  child: Ink(
                    color: index == 0 ? Colors.orange : Colors.indigo,
                    child: InkWell(
                      onTap: () => onTapSubEntry(entry, subEntries[index]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                subEntries[index].nextTask,
                              ),
                            ),
                          ),
                        ],
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
                TextButtonAtom(
                    onPressed: () => onPressedAdd(entry), text: "Next Task"),
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timely/modules/tab_9/models/entry_model.dart';
import 'package:timely/modules/tab_9/models/sub_entry_model.dart';

class Tab9SummaryMolecule extends StatelessWidget {
  final Tab9EntryModel entry;
  final Tab9SubEntryModel subEntry;
  final void Function(Tab9EntryModel entry) onTapEntry;
  final void Function(Tab9SubEntryModel subEntry) onTapSubEntry;

  const Tab9SummaryMolecule({
    super.key,
    required this.entry,
    required this.subEntry,
    required this.onTapEntry,
    required this.onTapSubEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => onTapEntry(entry), // |==|
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      entry.condition,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                  child: Text(
                    entry.criticality.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        InkWell(
            onTap: () => onTapSubEntry(subEntry),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          subEntry.task,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            DateFormat(DateFormat.ABBR_MONTH_DAY)
                                .format(subEntry.date),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            subEntry.time,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(subEntry.description),
                      ),
                    ],
                  ),
                ),
              ],
            ))
      ],
    );
  }
}

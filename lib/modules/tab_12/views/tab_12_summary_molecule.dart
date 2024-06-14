import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timely/modules/tab_12/models/entry_model.dart';
import 'package:timely/modules/tab_12/models/sub_entry_model.dart';

class Tab12SummaryMolecule extends StatelessWidget {
  final Tab12EntryModel entry;
  final Tab12SubEntryModel subEntry;
  final void Function(Tab12EntryModel entry) onTapEntry;
  final void Function(Tab12SubEntryModel subEntry) onTapSubEntry;

  const Tab12SummaryMolecule({
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
                      entry.activity,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                  child: Text(
                    entry.importance.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(
                  entry.tab2Model.getNextOccurrenceDateTime(),
                ),
              ),
            )
          ],
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
                        subEntry.nextTask,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

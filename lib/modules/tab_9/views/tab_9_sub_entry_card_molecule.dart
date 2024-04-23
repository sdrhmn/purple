import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timely/modules/tab_9/models/sub_entry_model.dart';

class Tab9SubEntryCardMolecule extends StatelessWidget {
  final Tab9SubEntryModel subEntry;
  const Tab9SubEntryCardMolecule({
    super.key,
    required this.subEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    DateFormat(DateFormat.ABBR_MONTH_DAY).format(subEntry.date),
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
    );
  }
}

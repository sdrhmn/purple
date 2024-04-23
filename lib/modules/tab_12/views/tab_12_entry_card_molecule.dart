import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timely/modules/tab_12/models/entry_model.dart';

class Tab12EntryCardMolecule extends StatelessWidget {
  final Tab12EntryModel entry;

  const Tab12EntryCardMolecule({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo[900],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(entry.activity)),
                Text(entry.importance.toString()),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                  child: Text(entry.objective),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(child: Text("Assignment Period")),
                Flexible(
                  child: Text(
                    "${DateFormat(DateFormat.ABBR_MONTH_DAY).format(entry.tab2Model.startDate!)} - ${DateFormat(DateFormat.ABBR_MONTH_DAY).format(entry.tab2Model.endDate!)}",
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(child: Text("Time Allocation")),
                Flexible(
                  child: Text(
                    "${entry.tab2Model.startTime.format(context)} - ${entry.tab2Model.getEndTime().format(context)} ",
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(child: Text("Frequency")),
                Flexible(
                  child: Text(
                    entry.tab2Model.frequency!,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

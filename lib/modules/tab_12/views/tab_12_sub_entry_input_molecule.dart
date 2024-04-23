import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/reusables.dart';
import 'package:timely/modules/tab_12/models/sub_entry_model.dart';

class Tab12SubEntryInputMolecule extends StatelessWidget {
  final Tab12SubEntryModel subEntry;
  final void Function(String nextTask) onNextTaskChanged;
  final bool? showNextOccuringDate;

  const Tab12SubEntryInputMolecule({
    super.key,
    required this.subEntry,
    required this.onNextTaskChanged,
    this.showNextOccuringDate,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        // Next Task TextField
        Padding(
          padding: const EdgeInsets.all(AppSizes.p_16),
          child: TextFormFieldAtom(
            initialValue: subEntry.nextTask,
            onChanged: onNextTaskChanged,
            hintText: "Next Task",
            isTextArea: true,
          ),
        ),
        const Divider(
          height: 40,
        ),
        showNextOccuringDate == false
            ? Container()
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Date"),
                        Text(
                          DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY)
                              .format(subEntry.date),
                        )
                      ],
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}

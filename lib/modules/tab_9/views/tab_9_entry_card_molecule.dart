import 'package:flutter/material.dart';
import 'package:timely/modules/tab_9/models/entry_model.dart';

class Tab9EntryCardMolecule extends StatelessWidget {
  final Tab9EntryModel entry;

  const Tab9EntryCardMolecule({
    super.key,
    required this.entry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(entry.condition),
              Text(
                entry.criticality.toString(),
              ),
            ],
          ),
        ),
        ...[entry.care, entry.lessonLearnt]
            .map((e) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Flexible(child: Text(e)),
                    ],
                  ),
                ))
            .toList()
      ],
    );
  }
}

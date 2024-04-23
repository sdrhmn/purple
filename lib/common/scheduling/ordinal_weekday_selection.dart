import 'package:flutter/material.dart';
import 'package:timely/reusables.dart';

class OrdinalWeekdaySelectionMolecule extends StatelessWidget {
  final Function(int index) onOrdinalPositionChanged;
  final Function(int index) onWeekdayIndexChanged;
  final int initialOrdinalPosition;
  final int initialWeekdayIndex;

  const OrdinalWeekdaySelectionMolecule({
    super.key,
    required this.onOrdinalPositionChanged,
    required this.onWeekdayIndexChanged,
    required this.initialOrdinalPosition,
    required this.initialWeekdayIndex,
  });

  @override
  Widget build(BuildContext context) {
    final List sliderNames = [
      ["First", "Second", "Third", "Fourth", "Fifth", "Last"],
      [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday",
      ]
    ];

    return Row(
      children: [
        Expanded(
          child: CupertinoPickerAtom(
            itemExtent: 70,
            onSelectedItemChanged: (index) => onOrdinalPositionChanged(index),
            elements: sliderNames[0],
            initialItemIndex: initialOrdinalPosition,
            size: const Size(0, 200),
          ),
        ),

        // --------- --------- --------- --------- ---------

        Expanded(
          child: CupertinoPickerAtom(
            itemExtent: 70,
            onSelectedItemChanged: (index) => onWeekdayIndexChanged(index),
            elements: sliderNames[1],
            initialItemIndex: initialWeekdayIndex,
            size: const Size(0, 200),
          ),
        )
      ],
    );
  }
}

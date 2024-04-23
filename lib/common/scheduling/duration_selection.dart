import 'package:flutter/material.dart';
import 'package:timely/reusables.dart';

class DurationSelectionMolecule extends StatelessWidget {
  final int initalHourIndex;
  final int initalMinuteIndex;
  final ValueChanged<int> onHoursChanged;
  final ValueChanged<int> onMinutesChanged;

  const DurationSelectionMolecule({
    Key? key,
    required this.onHoursChanged,
    required this.onMinutesChanged,
    required this.initalHourIndex,
    required this.initalMinuteIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CupertinoPickerAtom(
            itemExtent: 50,
            onSelectedItemChanged: onHoursChanged,
            elements: List.generate(24, (index) => index.toString()),
            size: const Size(0, 100),
            initialItemIndex: initalHourIndex,
          ),
        ),
        Expanded(
          child: CupertinoPickerAtom(
            itemExtent: 50,
            onSelectedItemChanged: onMinutesChanged,
            elements: List.generate(
              60,
              (index) => index.toString(),
            ),
            size: const Size(0, 100),
            initialItemIndex: initalMinuteIndex,
          ),
        ),
      ],
    );
  }
}

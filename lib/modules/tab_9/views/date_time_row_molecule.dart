import 'package:flutter/material.dart';
import 'package:timely/reusables.dart';

class DateTimeRowMolecule extends StatelessWidget {
  final DateTime initialDate;
  final void Function(DateTime date) onDateChanged;
  final TimeOfDay initialTime;
  final void Function(TimeOfDay time) onTimeChanged;

  const DateTimeRowMolecule({
    super.key,
    required this.initialDate,
    required this.onDateChanged,
    required this.initialTime,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DateButtonAtom.large(
            currentDate: initialDate,
            onDateChanged: onDateChanged,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TimeButtonAtom.large(
            initialTime: initialTime,
            onTimeChanged: onTimeChanged,
          ),
        )
      ],
    );
  }
}

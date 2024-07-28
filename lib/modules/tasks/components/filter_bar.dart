import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class FilterBar extends StatelessWidget {
  final String selection;
  final Function(Set<Object> selections) onSelectionChanged;
  const FilterBar({
    super.key,
    required this.selection,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
        onSelectionChanged: (selections) => onSelectionChanged(selections),
        segments: const [
          ButtonSegment(value: "all", label: Text("All")),
          ButtonSegment(value: "routine", label: Text("Routine")),
          ButtonSegment(value: "ad-hoc", label: Text("Ad-hoc")),
          ButtonSegment(value: "exercise", label: Text("Exercise")),
        ],
        selected: {
          selection,
        }).padding(all: 10);
  }
}

import 'package:flutter/material.dart';

class FilterButtonsMolecule extends StatefulWidget {
  final Set<int> lsjSelections;
  final Set<int> hmlSelections;
  final void Function(Set<int> selections) onLSJSelectionsChanged;
  final void Function(Set<int> selections) onHMLSelectionsChanged;

  const FilterButtonsMolecule({
    super.key,
    required this.lsjSelections,
    required this.hmlSelections,
    required this.onLSJSelectionsChanged,
    required this.onHMLSelectionsChanged,
  });

  @override
  State<FilterButtonsMolecule> createState() => _FilterButtonsMoleculeState();
}

class _FilterButtonsMoleculeState extends State<FilterButtonsMolecule> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Row(
            children: [
              Flexible(
                child: SegmentedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide.none,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  segments: const [
                    ButtonSegment(
                      value: 0,
                      label: Text("L"),
                    ),
                    ButtonSegment(
                      value: 1,
                      label: Text("S"),
                    ),
                    ButtonSegment(
                      value: 2,
                      label: Text("J"),
                    ),
                  ],
                  selected: widget.lsjSelections,
                  onSelectionChanged: widget.onLSJSelectionsChanged,
                  multiSelectionEnabled: true,
                  emptySelectionAllowed: true,
                  showSelectedIcon: false,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Flexible(
          child: Row(
            children: [
              Flexible(
                child: SegmentedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide.none,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  segments: const [
                    ButtonSegment(
                      value: 0,
                      label: Text("H"),
                    ),
                    ButtonSegment(
                      value: 1,
                      label: Text("M"),
                    ),
                    ButtonSegment(
                      value: 2,
                      label: Text("L"),
                    ),
                  ],
                  selected: widget.hmlSelections,
                  onSelectionChanged: widget.onHMLSelectionsChanged,
                  multiSelectionEnabled: true,
                  emptySelectionAllowed: true,
                  showSelectedIcon: false,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

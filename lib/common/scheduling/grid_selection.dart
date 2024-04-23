import 'package:flutter/material.dart';
import 'package:timely/common/scheduling/scheduling_colors.dart';

class GridSelectionMolecule extends StatefulWidget {
  final List<String> texts;
  final Function(int index) onTapTile;
  final List<int> selections;
  const GridSelectionMolecule({
    super.key,
    required this.texts,
    required this.onTapTile,
    required this.selections,
  });

  @override
  State<GridSelectionMolecule> createState() => _GridSelectionMoleculeState();
}

// Will return a function "onTap(List indices)"
// InshaaAllah

class _GridSelectionMoleculeState extends State<GridSelectionMolecule> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 50),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => widget.onTapTile(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: widget.selections.contains(index)
                  ? SchedulingColors.bgSelected
                  : SchedulingColors.bgDeselected,
            ),
            alignment: Alignment.center,
            child: Text(
              widget.texts[index].toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        );
      },
      itemCount: widget.texts.length,
    );
  }
}

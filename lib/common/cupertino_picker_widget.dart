import 'package:flutter/material.dart';
import 'package:timely/common/row_column_widgets.dart';

import 'package:timely/reusables.dart';

class CupertinoPickerRowOrganism extends StatelessWidget {
  final List<String> headers;
  final List<List<String>> labels;
  final List<ValueChanged<int>> onSelectedItemsChangedList;
  final List<Color?> pickerContainerColors;
  final double pickerHeight;
  final List<int> initialItemIndices;

  const CupertinoPickerRowOrganism({
    super.key,
    required this.headers,
    required this.labels,
    required this.onSelectedItemsChangedList,
    required this.pickerContainerColors,
    required this.pickerHeight,
    required this.initialItemIndices,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TextRowMolecule(texts: headers),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: List.generate(headers.length, (index) {
          return Expanded(
            child: CupertinoPickerAtom(
              itemExtent: 50,
              onSelectedItemChanged: onSelectedItemsChangedList[index],
              elements: labels[index],
              initialItemIndex: initialItemIndices[index],
              size: Size(0, pickerHeight),
              containerColor: pickerContainerColors[index],
              selectionOverlayColor: const Color.fromARGB(129, 33, 149, 243),
            ),
          );
        }),
      ),
    ]);
  }
}

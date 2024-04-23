import 'package:flutter/material.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/common/scheduling/grid_selection.dart';
import 'package:timely/common/scheduling/ordinal_weekday_selection.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';

class YearlySelectionOrganism extends StatelessWidget {
  final SchedulingModel model;
  final Function(List<int> selections) onSelectionsChanged;
  final Function(Basis basis) onBasisChanged;
  final Function(int index) onOrdinalPositionChanged;
  final Function(int index) onWeekdayIndexChanged;

  YearlySelectionOrganism({
    super.key,
    required this.onSelectionsChanged,
    required this.onBasisChanged,
    required this.onOrdinalPositionChanged,
    required this.onWeekdayIndexChanged,
    required this.model,
  });

  final List<String> months =
      "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec".split(",");

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Grid of Months in Tiles
        GridSelectionMolecule(
          selections: model.repetitions["Months"]
              .map((val) => val - 1)
              .toList()
              .cast<int>(),
          texts: months,
          onTapTile: (index) {
            model.repetitions["Months"].contains(index + 1)
                ? model.repetitions["Months"].remove(index + 1)
                : model.repetitions["Months"].add(index + 1);

            onSelectionsChanged(model.repetitions["Months"].cast<int>());
          },
        ),

        const SizedBox(
          height: 20,
        ),

        // The Switch to switch basis
        TitleWidgetRowMolecule(
          title: "Day of Week",
          widget: Switch(
            value: model.basis == Basis.day ? true : false,
            onChanged: (val) {
              onBasisChanged(val == true ? Basis.day : Basis.date);
            },
          ),
        ),

        // Ordinal weekday selection
        model.basis == Basis.day
            ? OrdinalWeekdaySelectionMolecule(
                onOrdinalPositionChanged: onOrdinalPositionChanged,
                onWeekdayIndexChanged: onWeekdayIndexChanged,
                initialOrdinalPosition: model.repetitions["DoW"][0],
                initialWeekdayIndex: model.repetitions["DoW"][1],
              )
            : Container(),
      ],
    );
  }
}

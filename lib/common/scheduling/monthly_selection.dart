import 'package:flutter/material.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/common/scheduling/grid_selection.dart';
import 'package:timely/common/scheduling/ordinal_weekday_selection.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/app_theme.dart';

class MonthlySelectionOrganism extends StatelessWidget {
  final SchedulingModel model;

  final Function(List<int> selections) onSelectionsChanged;
  final Function(Basis basis) onBasisChanged;
  final Function(int index) onOrdinalPositionChanged;
  final Function(int index) onWeekdayIndexChanged;

  const MonthlySelectionOrganism({
    super.key,
    required this.onSelectionsChanged,
    required this.onBasisChanged,
    required this.onOrdinalPositionChanged,
    required this.onWeekdayIndexChanged,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Each
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_12),
          child: TitleWidgetRowMolecule(
            title: "Each",
            widget: Checkbox(
                value: model.basis == Basis.date ? true : false,
                onChanged: (val) =>
                    onBasisChanged(val == true ? Basis.date : Basis.day)),
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        // On the...
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_12),
          child: TitleWidgetRowMolecule(
            title: "On the...",
            widget: Checkbox(
              value: model.basis == Basis.day ? true : false,
              onChanged: (val) =>
                  onBasisChanged(val == true ? Basis.day : Basis.date),
            ),
          ),
        ),

        const SizedBox(
          height: 20,
        ),

        model.basis == Basis.day
            ? OrdinalWeekdaySelectionMolecule(
                onOrdinalPositionChanged: onOrdinalPositionChanged,
                onWeekdayIndexChanged: onWeekdayIndexChanged,
                initialOrdinalPosition: model.repetitions["DoW"][0],
                initialWeekdayIndex: model.repetitions["DoW"][1],
              )
            : GridSelectionMolecule(
                selections: model.repetitions["Dates"].cast<int>(),
                texts: List.generate(
                  31,
                  (index) => (++index).toString(),
                ),
                onTapTile: (index) {
                  model.repetitions["Dates"].contains(index)
                      ? model.repetitions["Dates"].remove(index)
                      : model.repetitions["Dates"].add(index);

                  onSelectionsChanged(model.repetitions["Dates"].cast<int>());
                },
              ),
      ],
    );
  }
}

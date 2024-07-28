import 'package:flutter/material.dart';
import 'package:timely/reusables.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/common/scheduling/grid_selection.dart';
import 'package:timely/common/scheduling/monthly_selection.dart';
import 'package:timely/common/scheduling/yearly_selection.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/common/scheduling/scheduling_constants.dart';
import 'package:timely/app_theme.dart';

class RepeatsTemplate extends StatelessWidget {
  final SchedulingModel model;
  final ValueChanged<Basis> onBasisChanged;
  final ValueChanged<String> onFrequencyChanged;
  final ValueChanged<int> onEveryChanged;
  final ValueChanged<DateTime> onEndDateChanged;
  final ValueChanged<int> onWeekdayIndexChanged;
  final ValueChanged<int> onOrdinalPositionChanged;
  final ValueChanged<List<int>> onWeekdaySelectionsChanged;
  final ValueChanged<List<int>> onMonthlySelectionsChanged;
  final ValueChanged<List<int>> onYearlySelectionsChanged;

  const RepeatsTemplate({
    super.key,
    required this.onFrequencyChanged, //
    required this.onEveryChanged, //
    required this.onEndDateChanged, //
    required this.onWeekdaySelectionsChanged,
    required this.onMonthlySelectionsChanged,
    required this.onBasisChanged,
    required this.onOrdinalPositionChanged,
    required this.onWeekdayIndexChanged,
    required this.onYearlySelectionsChanged,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      // Repeat
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
        child: TitleWidgetRowMolecule(
          title: "Repeat",
          widget: DropdownButton(
            value: model.frequency,
            items: SchedulingConstants.repeatDropdownButtonItems,
            onChanged: (value) {
              onFrequencyChanged(value);
            },
          ),
          inverted: true,
        ),
      ),

      // Every
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
        child: TitleWidgetRowMolecule(
          title: "Every",
          widget: CupertinoPickerAtom(
            itemExtent: 40,
            onSelectedItemChanged: (index) => onEveryChanged(index + 1),
            elements: List.generate(100, (index) => (index + 1).toString()),
            initialItemIndex: model.every - 1,
            size: const Size(100, 80),
          ),
          inverted: true,
        ),
      ),

      // End Date
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.p_16),
        child: TitleWidgetRowMolecule(
          title: "End Repeat",
          widget: DateButtonAtom(
            defaultText: "Never",
            buttonSize: const Size(160, 50),
            currentDate: model.endDate,
            onDateChanged: (date) => onEndDateChanged(date),
          ),
          inverted: true,
        ),
      ),

      // Scheduling Organism
      model.frequency == "Daily"
          ? Container()
          : model.frequency == "Weekly"
              ? Padding(
                  padding: const EdgeInsets.all(AppSizes.p_12),
                  child: GridSelectionMolecule(
                    selections: model.repetitions["Weekdays"].cast<int>(),
                    texts: "Mon,Tue,Wed,Thu,Fri,Sat,Sun".split(","),
                    onTapTile: (index) {
                      model.repetitions["Weekdays"].contains(index)
                          ? model.repetitions["Weekdays"].remove(index)
                          : model.repetitions["Weekdays"].add(index);

                      onWeekdaySelectionsChanged(
                          model.repetitions["Weekdays"].cast<int>());
                    },
                  ),
                )
              : model.frequency == "Monthly"
                  ? Padding(
                      padding: const EdgeInsets.all(AppSizes.p_12),
                      child: MonthlySelectionOrganism(
                        model: model,
                        onSelectionsChanged: (selections) =>
                            onMonthlySelectionsChanged(selections),
                        onBasisChanged: (Basis basis) => onBasisChanged(basis),
                        onOrdinalPositionChanged: (int index) =>
                            onOrdinalPositionChanged(index),
                        onWeekdayIndexChanged: onWeekdayIndexChanged,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(AppSizes.p_12),
                      child: YearlySelectionOrganism(
                        onSelectionsChanged: onYearlySelectionsChanged,
                        onBasisChanged: onBasisChanged,
                        onOrdinalPositionChanged: onOrdinalPositionChanged,
                        onWeekdayIndexChanged: onWeekdayIndexChanged,
                        model: model,
                      ),
                    ),
    ];

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return children[index];
      },
      itemCount: children.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 20,
        );
      },
    );
  }
}

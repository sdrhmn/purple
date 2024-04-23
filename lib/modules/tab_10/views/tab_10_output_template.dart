import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/tab_10/models/tab_10_model.dart';
import 'package:timely/modules/tab_10/tokens/tab_10_colors.dart';

class Tab10OutputTemplate extends StatelessWidget {
  final List<Tab10Model> models;
  final void Function(DismissDirection direction, int index) onDismissed;
  final void Function(int index) onTap;
  final VoidCallback onPressedHome;
  final VoidCallback onPressedAdd;

  const Tab10OutputTemplate({
    super.key,
    required this.models,
    required this.onDismissed,
    required this.onTap,
    required this.onPressedHome,
    required this.onPressedAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemBuilder: (context, index) {
            Tab10Model model = models[index];

            return InkWell(
              onTap: () => onTap(index),
              child: DismissibleEntryRowMolecule(
                onDismissed: (direction) => onDismissed(direction, index),
                child: TextRowMolecule(
                  minHeight: 60,
                  texts: [
                    model.amount.toString(),
                    model.text_1,
                    DateFormat(DateFormat.ABBR_MONTH_DAY).format(model.date),
                  ],
                  customWidths: const {0: 100, 2: 100},
                  rowColor: Tab10Colors.optionColors[model.option - 1],
                ),
              ),
            );
          },
          itemCount: models.length,
        ),

        // Navigation Row
        Column(
          children: [
            const Spacer(),
            NavigationRowMolecule(
              onPressedHome: onPressedHome,
              onPressedAdd: onPressedAdd,
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        )
      ],
    );
  }
}

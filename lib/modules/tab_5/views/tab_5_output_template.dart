import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/tab_5/views/spw_text_row_molecule.dart';
import 'package:timely/modules/tab_5/models/spw.dart';
import 'package:timely/modules/tab_5/tokens/tab_5_colors.dart';
import 'package:timely/values.dart';

class Tab5OutputTemplate extends StatelessWidget {
  final List<SPWModel> models;
  final void Function(DismissDirection direction, int index) onDismissed;
  final void Function(int index) onTap;
  final void Function() onPressedHome;
  final void Function() onPressedAdd;

  const Tab5OutputTemplate({
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
        Column(
          children: [
            TextRowMolecule(
              height: 40,
              bolded: true,
              rowColor: SPWPageColors.bgSPWHeaderRow,
              texts: [
                Tab4Headings.date,
                Tab4Headings.s,
                Tab4Headings.p,
                Tab4Headings.w,
                Tab4Headings.weight
              ],
              customWidths: const {0: 120, 4: 100},
            ),
            ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                SPWModel model = models[index];
                return InkWell(
                  onTap: () => onTap(index),
                  child: DismissibleEntryRowMolecule(
                    onDismissed: (direction) => onDismissed(direction, index),
                    child: SPWTextRowMolecule(
                      height: 50,
                      texts: [
                        DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY)
                            .format(model.date),
                        model.sScore.toString(),
                        model.pScore.toString(),
                        model.wScore.toString(),
                        model.weight.toString(),
                      ],
                      customWidths: const {0: 120, 4: 100},
                      colors: {
                        0: SPWPageColors.bgDateCell,
                        1: Tab5Colors.spwColors[model.sScore],
                        2: Tab5Colors.spwColors[model.pScore],
                        3: Tab5Colors.spwColors[model.wScore],
                        4: SPWPageColors.bgWeightCell
                      },
                    ),
                  ),
                );
              },
              itemCount: models.length,
            ),
          ],
        ),
        Column(
          children: [
            const Spacer(),
            NavigationRowMolecule(
              onPressedHome: onPressedHome,
              onPressedAdd: onPressedAdd,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        )
      ],
    );
  }
}

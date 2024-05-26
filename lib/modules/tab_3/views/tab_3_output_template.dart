import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/tab_3/models/tab_3_model.dart';
import 'package:timely/modules/tab_3/tokens/tab_3_colors.dart';

class Tab3OutputTemplate extends StatelessWidget {
  final Map<String, dynamic> models;
  final Function(DismissDirection direction, Tab3Model model) onDismissed;
  final Function(Tab3Model model) onTap;
  final VoidCallback onPressedHome;
  final VoidCallback onPressedAdd;
  final Widget checkbox;

  const Tab3OutputTemplate({
    super.key,
    required this.models,
    required this.onDismissed,
    required this.onTap,
    required this.onPressedHome,
    required this.onPressedAdd,
    required this.checkbox,
  });

  @override
  Widget build(BuildContext context) {
    List<String> dates = models["scheduled"]!.keys.toList().cast<String>();
    print(models);
    return Stack(
      children: [
        ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Container(),
                ),
                checkbox,
              ],
            ),
            (models["scheduled"].keys.isEmpty && models["nonScheduled"].isEmpty)
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                        "No tasks here. Start creating using the + buttton."),
                  )
                : Container(
                    color: Tab3Colors.bgScheduledHeader,
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Scheduled",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                DateTime date = DateTime.parse(dates[index]);
                List<Tab3Model> tab3Models =
                    models["scheduled"]![dates[index]]!.cast<Tab3Model>();

                return Column(
                  children: [
                    TextRowMolecule(
                      height: 30,
                      rowColor: Tab3Colors.bgDateHeader,
                      texts: [
                        DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY).format(date)
                      ],
                    ),
                    ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                        height: 0.3,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        DateTime dateToday = DateTime.now();
                        return InkWell(
                          onTap: () => onTap(tab3Models[index]),
                          child: DismissibleEntryRowMolecule(
                            onDismissed: (direction) =>
                                onDismissed(direction, tab3Models[index]),
                            child: TextRowMolecule(
                              minHeight: 60,
                              rowColor: date.isBefore(
                                DateTime(dateToday.year, dateToday.month,
                                    dateToday.day),
                              )
                                  ? Tab3Colors.bgDatePassed
                                  : Tab3OutputColors.priorityColors[
                                      tab3Models[index].priority],
                              customWidths: const {1: 70},
                              texts: [
                                tab3Models[index].text_1,
                                tab3Models[index].time != null
                                    ? tab3Models[index].time!.format(context)
                                    : "",
                              ],
                              defaultAligned: const [0],
                            ),
                          ),
                        );
                      },
                      itemCount: tab3Models.length,
                    )
                  ],
                );
              },
              itemCount: dates.length,
            ),
            (models["scheduled"].keys.isEmpty && models["nonScheduled"].isEmpty)
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(),
                  )
                : Container(
                    height: 40,
                    color: Tab3Colors.bgNonScheduledHeader,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Non-Scheduled",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
            ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                height: 0.3,
              ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                List<Tab3Model> tab3Models =
                    models["nonScheduled"].cast<Tab3Model>();

                return InkWell(
                  onTap: () => onTap(tab3Models[index]),
                  child: DismissibleEntryRowMolecule(
                    onDismissed: (direction) =>
                        onDismissed(direction, tab3Models[index]),
                    child: TextRowMolecule(
                      minHeight: 60,
                      rowColor: Tab3OutputColors
                          .priorityColors[tab3Models[index].priority],
                      customWidths: const {1: 70},
                      texts: [
                        tab3Models[index].text_1,
                      ],
                      defaultAligned: const [0],
                    ),
                  ),
                );
              },
              itemCount: models["nonScheduled"].length,
            )
          ],
        ),
        Column(
          children: [
            Expanded(
              child: Container(),
            ),
            NavigationRowMolecule(
              onPressedHome: onPressedHome,
              onPressedAdd: onPressedAdd,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ],
    );
  }
}

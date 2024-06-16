import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/tab_3/models/ad_hoc_model.dart';
import 'package:timely/modules/tab_3/tokens/tab_3_colors.dart';

class Tab3OutputTemplate extends StatelessWidget {
  final Map<String, dynamic> models;
  final Function(DismissDirection direction, AdHocModel model) onDismissed;
  final Function(AdHocModel model) onTap;
  final Function(bool value, AdHocModel model, String date, int index)
      onNotifIconPressed;
  final VoidCallback onPressedHome;
  final VoidCallback onPressedAdd;
  final Widget checkbox;
  final bool? cannotBeMarkedComplete;

  const Tab3OutputTemplate({
    super.key,
    required this.models,
    required this.onDismissed,
    required this.onTap,
    required this.onNotifIconPressed,
    required this.onPressedHome,
    required this.onPressedAdd,
    required this.checkbox,
    this.cannotBeMarkedComplete,
  });

  @override
  Widget build(BuildContext context) {
    List<String> dates = models["scheduled"]!.keys.toList().cast<String>();
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
                ? const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        "No tasks here. Start creating using the + button."),
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
                List<AdHocModel> tab3Models =
                    models["scheduled"]![dates[index]]!.cast<AdHocModel>();

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
                            cannotBeMarkedComplete: cannotBeMarkedComplete,
                            child: Container(
                              color: date.isBefore(
                                DateTime(dateToday.year, dateToday.month,
                                    dateToday.day),
                              )
                                  ? Tab3Colors.bgDatePassed
                                  : Tab3OutputColors.priorityColors[
                                      tab3Models[index].priority],
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextRowMolecule(
                                      minHeight: 60,
                                      customWidths: const {1: 70},
                                      texts: [
                                        tab3Models[index].name,
                                        tab3Models[index].startTime != null
                                            ? tab3Models[index]
                                                .startTime!
                                                .format(context)
                                            : "",
                                      ],
                                      defaultAligned: const [0],
                                    ),
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      icon: Icon(tab3Models[index].notifOn
                                          ? Icons.notifications_active
                                          : Icons.notifications_off),
                                      onPressed: () {
                                        onNotifIconPressed(
                                          !(tab3Models[index].notifOn),
                                          tab3Models[index],
                                          date.toString(),
                                          index,
                                        );
                                      },
                                      color: tab3Models[index].notifOn
                                          ? Colors.blue
                                          : Colors.red,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  )
                                ],
                              ),
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
                List<AdHocModel> tab3Models =
                    models["nonScheduled"].cast<AdHocModel>();

                return InkWell(
                  onTap: () => onTap(tab3Models[index]),
                  child: DismissibleEntryRowMolecule(
                    onDismissed: (direction) =>
                        onDismissed(direction, tab3Models[index]),
                    cannotBeMarkedComplete: cannotBeMarkedComplete,
                    child: TextRowMolecule(
                      minHeight: 60,
                      rowColor: Tab3OutputColors
                          .priorityColors[tab3Models[index].priority],
                      customWidths: const {1: 70},
                      texts: [
                        tab3Models[index].name,
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

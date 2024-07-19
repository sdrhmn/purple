import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/common/scheduling/scheduling_model.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/values.dart';

class SchedulingOutputTemplate extends StatelessWidget {
  final Map<String, List<SchedulingModel>> models;
  final Function(DismissDirection direction, SchedulingModel model, String type)
      onDismissed;
  final Function(SchedulingModel model) onTap;
  final VoidCallback onPressedHome;
  final VoidCallback onPressedAdd;
  final Function(SchedulingModel model, String type, int index)
      onNotifIconPressed;

  final bool? showEndTime;

  const SchedulingOutputTemplate({
    super.key,
    required this.models,
    required this.onDismissed,
    required this.onTap,
    required this.onPressedHome,
    required this.onPressedAdd,
    required this.showEndTime,
    required this.onNotifIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StatefulBuilder(
          builder: ((context, setState) {
            return ListView(
              shrinkWrap: true,
              children: [
                Container(
                  color: SchedulingColors.bgTodaysTasksHeader,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Tab2Headings.todaysTasks,
                        style: Theme.of(context).textTheme.titleMedium,
                      )
                    ],
                  ),
                ),
                ...List.generate(
                  models["today"]!.length,
                  (index) {
                    SchedulingModel model = models["today"]![index];
                    return GestureDetector(
                      onTap: () => onTap(model),
                      child: Container(
                        child: Column(
                          children: [
                            DismissibleEntryRowMolecule(
                              child: TextRowMolecule(
                                customWidths: {
                                  1: 50,
                                  2: showEndTime == true ? 50 : 10
                                },
                                minHeight: 60,
                                rowColor: SchedulingColors.bgTodaysTaskTile,
                                defaultAligned: const [0],
                                texts: [
                                  model.name!,
                                  model.startTime.format(context),
                                  showEndTime == true
                                      ? model.getEndTime().format(context)
                                      : "",
                                ],
                                textStyle:
                                    Theme.of(context).textTheme.titleMedium,
                              ),
                              onDismissed: (direction) =>
                                  onDismissed(direction, model, "today"),
                            ),
                            Container(
                              constraints: const BoxConstraints(
                                minHeight: 40,
                              ),
                              color: SchedulingColors.bgTodaysTaskTile,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(AppSizes.p_8),
                                      child: Text(
                                        model.getRepetitionSummary(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(3.0),
                                  //   child: CircleAvatar(
                                  //     backgroundColor: Colors.white,
                                  //     child: IconButton(
                                  //       onPressed: () => onNotifIconPressed(
                                  //           model, "today", index),
                                  //       icon: Icon(
                                  //         model.notifOn == true
                                  //             ? Icons
                                  //                 .notifications_active_rounded
                                  //             : Icons.notifications_off_rounded,
                                  //         color: model.notifOn == true
                                  //             ? Colors.green
                                  //             : Colors.red,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ).clipRRect(all: 10).padding(vertical: 5),
                      ),
                    ).padding(horizontal: 7);
                  },
                ),
                Container(
                  color: SchedulingColors.bgUpcomingTasksHeader,
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Tab2Headings.upcomingTasks,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                ...List.generate(
                  models["upcoming"]!.length,
                  (index) {
                    SchedulingModel model = models["upcoming"]![index];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () => onTap(model),
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border.symmetric(
                                horizontal: BorderSide(width: 1),
                              ),
                            ),
                            child: Column(
                              children: [
                                DismissibleEntryRowMolecule(
                                  child: TextRowMolecule(
                                    customWidths: {
                                      1: 50,
                                      2: showEndTime == true ? 50 : 10
                                    },
                                    minHeight: 60,
                                    rowColor:
                                        SchedulingColors.bgUpcomingTaskTile,
                                    defaultAligned: const [0],
                                    texts: [
                                      model.name!,
                                      model.startTime.format(context),
                                      showEndTime == true
                                          ? model.getEndTime().format(context)
                                          : "",
                                    ],
                                    textStyle:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  onDismissed: (direction) =>
                                      onDismissed(direction, model, "upcoming"),
                                ),
                                Container(
                                  constraints: const BoxConstraints(
                                    minHeight: 40,
                                  ),
                                  color: SchedulingColors.bgUpcomingTaskTile,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              AppSizes.p_8),
                                          child: Text(
                                            model.getRepetitionSummary(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                          ),
                                        ),
                                      ),
                                      // CircleAvatar(
                                      //   backgroundColor: Colors.white,
                                      //   child: IconButton(
                                      //     onPressed: () => onNotifIconPressed(
                                      //         model, "upcoming", index),
                                      //     icon: Icon(
                                      //       model.notifOn == true
                                      //           ? Icons
                                      //               .notifications_active_rounded
                                      //           : Icons
                                      //               .notifications_off_rounded,
                                      //       color: model.notifOn == true
                                      //           ? Colors.green
                                      //           : Colors.red,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).clipRRect(all: 10).padding(vertical: 5)
                      ],
                    ).padding(horizontal: 7);
                  },
                ),
              ],
            );
          }),
        ),
        Column(
          children: [
            Expanded(
              child: Container(),
            ),
            NavigationRowMolecule(
              onPressedHome: () => onPressedHome(),
              onPressedAdd: () => onPressedAdd(),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        )
      ],
    );
  }
}

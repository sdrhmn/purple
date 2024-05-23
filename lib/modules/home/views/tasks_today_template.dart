import 'dart:async';

import 'package:flutter/material.dart';
import 'package:timely/app_theme.dart';
import 'package:timely/common/row_column_widgets.dart';
import 'package:timely/modules/home/models/task_today.dart';
import 'package:timely/modules/tab_3/models/tab_3_model.dart';
import 'package:timely/modules/tab_3/tokens/tab_3_colors.dart';

class TasksTodayTemplate extends StatefulWidget {
  final List data;
  final Function(dynamic model, int tabNumber) onTap;
  final Function(
    DismissDirection direction,
    dynamic model,
    int? tabNumber,
    TaskToday? task,
  ) onDismissed;

  const TasksTodayTemplate({
    super.key,
    required this.data,
    required this.onTap,
    required this.onDismissed,
  });

  @override
  State<TasksTodayTemplate> createState() => _TasksTodayTemplateState();
}

class _TasksTodayTemplateState extends State<TasksTodayTemplate>
    with SingleTickerProviderStateMixin {
  List blinkIndices = [];
  late AnimationController _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..repeat(
        reverse: true,
      );
    _timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
      var now = DateTime.now();
      var currentTime = "${now.hour}:${now.minute}";
      for (var i = 0; i < widget.data.first.length; i++) {
        TimeOfDay time = widget.data.first[i].startTime;
        if ("${time.hour}:${time.minute}" == currentTime) {
          setState(() {
            blinkIndices.add(i);
          });
          Future.delayed(const Duration(seconds: 30), () {
            setState(() {
              blinkIndices = [];
            });
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<TaskToday> tasksToday = widget.data.first;
    List<Tab3Model> nonScheduledTasks = widget.data.last;

    return Container(
      child: widget.data.isEmpty
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: Text("Default Text 2")),
              ],
            )
          : Column(
              children: [
                Expanded(
                  flex: 1,
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 1,
                        color: LaunchScreenColors.bgSeparator,
                      );
                    },
                    itemBuilder: (context, index) {
                      var model = tasksToday[index].model;
                      var tabNumber = tasksToday[index].tabNumber;
                      return InkWell(
                        onTap: () => widget.onTap(model, tabNumber),
                        child: DismissibleEntryRowMolecule(
                          onDismissed: (direction) => widget.onDismissed(
                              direction, model, tabNumber, tasksToday[index]),
                          child: Column(
                            children: [
                              Container(
                                color: tasksToday[index].tabNumber == 3
                                    ? Tab3OutputColors.priorityColors[
                                        tasksToday[index].model.priority]
                                    : LaunchScreenColors.bgTaskTodayTile,
                                child: FadeTransition(
                                  opacity: blinkIndices.contains(index)
                                      ? _controller
                                      : const AlwaysStoppedAnimation(1.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            tasksToday[index].name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width: 70,
                                              child: Center(
                                                child: Text(
                                                    tasksToday[index]
                                                        .startTime
                                                        .format(context),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall),
                                              ),
                                            ),
                                            tasksToday[index].endTime != null
                                                ? Column(
                                                    children: [
                                                      const SizedBox(
                                                        height: 6,
                                                      ),
                                                      SizedBox(
                                                        width: 70,
                                                        child: Center(
                                                          child: Text(
                                                            tasksToday[index]
                                                                .endTime!
                                                                .format(
                                                                    context),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: tasksToday.length,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 1,
                        color: LaunchScreenColors.bgSeparator,
                      );
                    },
                    itemBuilder: (context, index) {
                      String name = nonScheduledTasks[index].text_1;

                      return DismissibleEntryRowMolecule(
                        onDismissed: (direction) => widget.onDismissed(
                            direction, nonScheduledTasks[index], null, null),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 30),
                          child: Container(
                            color: Tab3OutputColors.priorityColors[
                                nonScheduledTasks[index].priority],
                            child: Padding(
                              padding: const EdgeInsets.all(AppSizes.p_8),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: nonScheduledTasks.length,
                  ),
                )
              ],
            ),
    );
  }
}

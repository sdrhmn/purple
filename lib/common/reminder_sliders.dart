import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timely/common/inputs.dart';
import 'package:timely/modules/tab_3/models/ad_hoc_model.dart';

class ReminderSliders extends StatelessWidget {
  final dynamic model;
  final Function(
    dynamic model,
  ) onAddReminder;
  final Function(
    dynamic model,
  ) onDeleteReminder;
  final Function(
    dynamic model,
  ) onSliderChanged;

  const ReminderSliders({
    super.key,
    required this.model,
    required this.onAddReminder,
    required this.onSliderChanged,
    required this.onDeleteReminder,
  });

  @override
  Widget build(BuildContext context) {
    int half = (DateTime.now()
            .copyWith(
                hour: model.startTime.hour, minute: model.startTime.minute)
            .difference(DateTime.now())
            .inMinutes ~/
        2);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Reminders",
              style: Theme.of(context).textTheme.titleSmall,
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        ..._renderReminderSliders(),
        TextButton.icon(
          onPressed: () {
            if (DateTime.now()
                        .copyWith(
                            hour: model.startTime.hour,
                            minute: model.startTime.minute)
                        .difference(DateTime.now())
                        .inMinutes <
                    1 &&
                model is AdHocModel) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "Not enough time to set a reminder. Try increasing the start time of your task.")));
            } else {
              onAddReminder(
                model.copyWith(
                  reminders: <int, Duration>{
                    ...model.reminders ?? {},
                    Random().nextInt(50000):
                        Duration(minutes: model is AdHocModel ? half : 30),
                  },
                ),
              );
            }
          },
          icon: const Icon(Icons.add),
          label: const Text("Add"),
        ),
      ],
    );
  }

  List<Widget> _renderReminderSliders() {
    List<Widget> sliders = [];
    double max = DateTime.now()
        .copyWith(hour: model.startTime.hour, minute: model.startTime.minute)
        .difference(DateTime.now())
        .inMinutes
        .toDouble();

    if (model.reminders != null) {
      for (var entry in model.reminders!.entries) {
        sliders.add(
          Row(
            children: [
              Expanded(
                child: CupertinoPickerAtom(
                  itemExtent: 32,
                  onSelectedItemChanged: (index) {
                    onSliderChanged(
                      model.copyWith(
                        reminders: model.reminders!
                          ..update(
                            entry.key,
                            (Duration current) => Duration(
                                hours: index, minutes: current.inMinutes % 60),
                          ),
                      ),
                    );
                  },
                  elements: Iterable.generate(
                          model is AdHocModel ? (max / 60).round() : 24)
                      .map((e) => e.toString())
                      .toList(),
                  initialItemIndex: entry.value.inHours,
                  size: const Size(0, 70),
                ),
              ),
              const Text("hrs"),
              Expanded(
                child: CupertinoPickerAtom(
                  itemExtent: 32,
                  onSelectedItemChanged: (index) {
                    onSliderChanged(
                      model.copyWith(
                        reminders: model.reminders!
                          ..update(
                            entry.key,
                            (Duration current) => Duration(
                              hours: current.inHours,
                              minutes: index,
                            ),
                          ),
                      ),
                    );
                  },
                  elements: Iterable.generate(
                          model is AdHocModel ? (max % 60).round() + 1 : 59)
                      .map((e) => e.toString())
                      .toList(),
                  initialItemIndex: entry.value.inHours,
                  size: const Size(0, 70),
                ),
              ),
              const Text("min"),
              const SizedBox(
                width: 10,
              ),
              IconButton.filledTonal(
                  onPressed: () {
                    onDeleteReminder(
                      model.copyWith(
                        reminders: model.reminders!
                          ..removeWhere((key, value) => key == entry.key),
                      ),
                    );
                  },
                  icon: const Icon(Icons.remove)),
            ],
          ),
        );
      }
    } else {
      sliders = [Container()];
    }
    return sliders;
  }
}

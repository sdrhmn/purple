import 'dart:math';

import 'package:flutter/material.dart';
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
                1) {
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
              Text("${entry.value.inHours} h, ${entry.value.inMinutes % 60} m"),
              Expanded(
                child: Slider(
                  max: model is AdHocModel ? max : 120,
                  min: 0,
                  divisions: model is AdHocModel ? max.toInt() - 1 : 24,
                  label:
                      "${entry.value.inHours} hours and ${entry.value.inMinutes % 60} minutes",
                  value: entry.value.inMinutes.toDouble(),
                  onChanged: (newValue) {
                    onSliderChanged(
                      model.copyWith(
                        reminders: model.reminders!
                          ..update(
                            entry.key,
                            (value) => Duration(minutes: newValue.toInt()),
                          ),
                      ),
                    );
                  },
                ),
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

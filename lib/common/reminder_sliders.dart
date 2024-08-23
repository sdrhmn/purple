import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timely/common/inputs.dart';
import 'package:timely/modules/tasks/models/task_model.dart';

class ReminderSliders extends StatelessWidget {
  final Task model;
  final Function(
    Task model,
  ) onAddReminder;
  final Function(
    Task model,
  ) onDeleteReminder;
  final Function(
    Task model,
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
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Reminders",
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        ..._renderReminderSliders(),
        TextButton.icon(
          onPressed: () {
            if (model.repeatRule == null &&
                DateTime(model.date!.year, model.date!.month, model.date!.day,
                            model.time!.hour, model.time!.minute)
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
                    ...model.reminders,
                    Random().nextInt(50000): const Duration(minutes: 30),
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

    for (var entry in model.reminders.entries) {
      sliders.add(
        Row(
          children: [
            Expanded(
              child: CupertinoPickerAtom(
                itemExtent: 32,
                onSelectedItemChanged: (index) {
                  onSliderChanged(
                    model.copyWith(
                      reminders: model.reminders
                        ..update(
                          entry.key,
                          (Duration current) => Duration(
                              hours: index, minutes: current.inMinutes % 60),
                        ),
                    ),
                  );
                },
                elements:
                    Iterable.generate(24).map((e) => e.toString()).toList(),
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
                      reminders: model.reminders
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
                // Formula: min(max - hours * 60, 59)
                elements:
                    Iterable.generate(60).map((e) => e.toString()).toList(),
                initialItemIndex: (entry.value.inMinutes % 60).toInt(),
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
                      reminders: model.reminders
                        ..removeWhere((key, value) => key == entry.key),
                    ),
                  );
                },
                icon: const Icon(Icons.remove)),
          ],
        ),
      );
    }
    return sliders;
  }
}

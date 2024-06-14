import 'dart:math';

import 'package:flutter/material.dart';

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
    return Column(
      children: [
        ..._renderReminderSliders(),
        TextButton.icon(
          onPressed: () => onAddReminder(
            model.copyWith(
              reminders: <int, Duration>{
                ...model.reminders ?? {},
                Random().nextInt(50000): const Duration(minutes: 30),
              },
            ),
          ),
          icon: const Icon(Icons.add),
          label: const Text("Add"),
        ),
      ],
    );
  }

  List<Widget> _renderReminderSliders() {
    List<Widget> sliders = [];
    if (model.reminders != null) {
      for (var entry in model.reminders!.entries) {
        sliders.add(
          Row(
            children: [
              Text("${entry.value.inHours} h, ${entry.value.inMinutes % 60} m"),
              Expanded(
                child: Slider(
                  max: 120,
                  min: 1,
                  divisions: 24,
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

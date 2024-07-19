import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_1_new/model_provider.dart';
import 'package:timely/modules/tab_2/controllers/output_controller.dart';
import 'package:timely/values.dart';

class ProgressView extends ConsumerStatefulWidget {
  const ProgressView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProgressViewState();
}

class _ProgressViewState extends ConsumerState<ProgressView> {
  Duration _remainingTime = Duration.zero;
  Duration _elapsedTime = Duration.zero;
  Timer? _timer;

  get loading => null;

  void _startTimerIfWithinRange(sleepTime) {
    final now = DateTime.now();

    DateTime sleepDateTime = sleepTime.hour > 12
        ? DateTime(
            now.year, now.month, now.day, sleepTime.hour, sleepTime.minute)
        : DateTime(
            now.year, now.month, now.day + 1, sleepTime.hour, sleepTime.minute);
    final wakeupTime = sleepTime.hour > 12
        ? sleepDateTime.copyWith(hour: (sleepTime.hour + 8) % 24)
        : sleepDateTime.copyWith(
            day: now.day - 1, hour: (sleepTime.hour + 8) % 24);

    if (now.isAfter(wakeupTime) && now.isBefore(sleepDateTime)) {
      _remainingTime = sleepDateTime.difference(now);
      _elapsedTime = now.difference(wakeupTime);

      _timer = Timer.periodic(
          const Duration(seconds: 1),
          (_) => setState(() {
                _updateTime(sleepDateTime, wakeupTime);
              }));
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      _startTimerIfWithinRange(
          await ref.read(tab2OutputProvider.notifier).fetchSleepTime());
    });
    super.initState();
  }

  void _updateTime(sleepDateTime, wakeupTime) {
    DateTime now = DateTime.now();

    if (now.isAfter(wakeupTime) && now.isBefore(sleepDateTime)) {
      _remainingTime = sleepDateTime.difference(now);
      _elapsedTime = now.difference(wakeupTime);
    } else {
      _remainingTime = Duration.zero;
      _elapsedTime = Duration.zero;
      _timer?.cancel(); // Stop timer if time exceeds 10 PM
    }
  }

// State variables
  Map actions = {
    "m": null,
    "f": null,
    "s": null,
  };
  int level = 0;

  Map<String, Image> icons = {
    'c': communicationIcon,
    'f': foodIcon,
    's': timeIcon,
  };

  List<String> levels = [
    'Great',
    'High',
    'Normal',
    'Low',
    'None',
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Reset the state
        actions = {
          "c": null,
          "f": null,
          "s": null,
        };
        level = 0;

        showDialog(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setDialogState) {
                return AlertDialog(
                    title: const Text("Control Status"),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (String word
                              in 'Communication.Food.Spending'.split(".")) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...[
                                  Text(word),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ChoiceChip(
                                        checkmarkColor: Colors.black,
                                        color: const WidgetStatePropertyAll(
                                            Colors.yellow),
                                        label: const SizedBox(
                                            width: 40,
                                            child: Center(
                                                child: Text(
                                              "Fair",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ))),
                                        selected:
                                            actions[word[0].toLowerCase()] == 0,
                                        onSelected: (selected) {
                                          // Select and deselect
                                          if (actions[word[0].toLowerCase()] ==
                                              0) {
                                            actions[word[0].toLowerCase()] =
                                                null;
                                          } else {
                                            actions[word[0].toLowerCase()] = 0;
                                          }

                                          setDialogState(() {});
                                        },
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      ChoiceChip(
                                        color: const WidgetStatePropertyAll(
                                            Colors.red),
                                        label: const SizedBox(
                                            width: 40,
                                            child: Center(child: Text("Poor"))),
                                        selected:
                                            actions[word[0].toLowerCase()] == 1,
                                        onSelected: (selected) {
                                          if (actions[word[0].toLowerCase()] ==
                                              1) {
                                            actions[word[0].toLowerCase()] =
                                                null;
                                          } else {
                                            actions[word[0].toLowerCase()] = 1;
                                          }

                                          setDialogState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                ]
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                          Row(
                            children: [
                              const Text("Enthusiasm"),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: CupertinoPicker(
                                    scrollController:
                                        FixedExtentScrollController(
                                            initialItem: 4),
                                    itemExtent: 40,
                                    onSelectedItemChanged: (index) {
                                      level = 5 - index;
                                    },
                                    children: List.generate(
                                        5,
                                        (index) => Center(
                                            child: Text(levels[index])))),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton.filledTonal(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.cancel),
                              ),
                              IconButton.filledTonal(
                                onPressed: () {
                                  for (String letter in actions.keys) {
                                    ref
                                        .read(progressModelController.notifier)
                                        .pause(letter, actions[letter]);
                                  }
                                  ref
                                      .read(progressModelController.notifier)
                                      .setLevel(level);

                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.done),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ));
              },
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 10,
            ),
            Consumer(
              builder: (context, ref, child) {
                final provider = ref.watch(progressModelController);

                return provider.when(
                    data: (model) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (String letter in "c.f.s".split("."))
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: model.stopped.contains(letter)
                                    ? Colors.red
                                    : model.paused.containsKey(letter)
                                        ? Colors.yellow[800]
                                        : Colors.green,
                              ),
                              child: CircleAvatar(
                                radius: 22,
                                child: icons[letter],
                              ),
                            )
                        ],
                      );
                    },
                    error: (_, __) => const Text("Error"),
                    loading: () {
                      return const Text("Loading...");
                    });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            _buildTab1View(label: 'Elapsed', time: _elapsedTime),
            const SizedBox(
              height: 20,
            ),
            _buildTab1View(
                label: 'Remaining',
                time: Duration(seconds: _remainingTime.inSeconds + 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildTab1View({required String label, required Duration time}) {
    final hours = time.inHours % 24;
    final minutes = time.inMinutes % 60;
    final seconds = time.inSeconds % 60;

    return Row(
      children: [
        Text(label),
        Expanded(
          child: Container(),
        ),
        Text(
            '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 18, letterSpacing: 6)),
      ],
    );
  }
}

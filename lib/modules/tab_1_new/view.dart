import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timely/modules/tab_1_new/model_provider.dart';
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

  @override
  void initState() {
    super.initState();
    _updateTime();
    _startTimerIfWithinRange();
  }

  void _startTimerIfWithinRange() {
    final now = DateTime.now();
    final tenPM = DateTime(now.year, now.month, now.day, 22, 0);
    final sixAM = DateTime(now.year, now.month, now.day, 6, 0);

    if (now.isAfter(sixAM) && now.isBefore(tenPM)) {
      _timer = Timer.periodic(
          const Duration(seconds: 1),
          (_) => setState(() {
                _updateTime();
              }));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final now = DateTime.now();
    final tenPM = DateTime(now.year, now.month, now.day, 22, 0);
    final sixAM = DateTime(now.year, now.month, now.day, 6, 0);

    if (now.isAfter(sixAM) && now.isBefore(tenPM)) {
      _remainingTime = tenPM.difference(now);
      _elapsedTime = now.difference(sixAM);
    } else {
      _remainingTime = Duration.zero;
      _elapsedTime = Duration.zero;
      _timer?.cancel(); // Stop timer if time exceeds 10 PM
    }
  }

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
                                        color: const MaterialStatePropertyAll(
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
                                          actions[word[0].toLowerCase()] = 0;
                                          print(actions);
                                          setDialogState(() {});
                                        },
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      ChoiceChip(
                                        color: const MaterialStatePropertyAll(
                                            Colors.red),
                                        label: const SizedBox(
                                            width: 40,
                                            child: Center(child: Text("Poor"))),
                                        selected:
                                            actions[word[0].toLowerCase()] == 1,
                                        onSelected: (selected) {
                                          actions[word[0].toLowerCase()] = 1;
                                          print(actions);

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
                                    itemExtent: 40,
                                    onSelectedItemChanged: (index) {
                                      level = index + 1;
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
                            CircleAvatar(
                              backgroundColor: model.stopped.contains(letter)
                                  ? Colors.red
                                  : model.paused.containsKey(letter)
                                      ? Colors.yellow[800]
                                      : Colors.green,
                              child: icons[letter],
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

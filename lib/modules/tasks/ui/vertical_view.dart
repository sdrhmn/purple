import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/tasks/models/task_model.dart';

class BlockView extends StatefulWidget {
  final List<Task> tasks;
  const BlockView({super.key, required this.tasks});

  @override
  State<BlockView> createState() => _BlockViewState();
}

class _BlockViewState extends State<BlockView> {
  @override
  Widget build(BuildContext context) {
    double blockHeight = 200;

    DateTime start = DateTime.now().copyWith(hour: 8, minute: 30);
    List<DateTime> times = Iterable.generate(24, (index) {
      return start.add(Duration(minutes: index * 30));
    }).toList();

    return ListView(
      children: [],
    );
  }
}

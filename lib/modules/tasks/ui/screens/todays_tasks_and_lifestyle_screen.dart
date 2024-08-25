import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:timely/modules/tasks/ui/tabs/tabs.dart';

class TodaysScreen extends ConsumerStatefulWidget {
  const TodaysScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TodaysScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(tabs: [
            SizedBox(
                height: 40,
                child: Center(child: const Text("Tasks").fontSize(15))),
            SizedBox(
                height: 40,
                child: Center(child: const Text("Lifestyle").fontSize(15))),
          ]),
          const SizedBox(
            height: 7,
          ),
          // ignore: prefer_const_constructors
          TabBarView(
            children: const [
              TaskTab(),
              LifestyleTab(),
            ],
          ).expanded(),
        ],
      ),
    );
  }
}

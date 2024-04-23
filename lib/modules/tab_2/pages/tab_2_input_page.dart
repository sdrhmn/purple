import 'package:flutter/material.dart';
import 'package:timely/common/scheduling/scheduling_input_page.dart';

// This is tab 2 Input page.

class Tab2InputPage extends StatelessWidget {
  const Tab2InputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SchedulingInputPage(
      tabNumber: 2,
    );
  }
}

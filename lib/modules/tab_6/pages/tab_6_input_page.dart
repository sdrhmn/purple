import 'package:flutter/material.dart';
import 'package:timely/common/scheduling/scheduling_input_page.dart';

class Tab6InputPage extends StatelessWidget {
  const Tab6InputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SchedulingInputPage(
      tabNumber: 6,
      showDurationSelector: false,
    );
  }
}

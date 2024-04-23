import 'package:flutter/material.dart';
import 'package:timely/common/scheduling/scheduling_input_page.dart';

class Tab7InputPage extends StatelessWidget {
  const Tab7InputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SchedulingInputPage(
      tabNumber: 7,
      showDurationSelector: false,
    );
  }
}

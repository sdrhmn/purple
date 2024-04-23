import 'package:flutter/material.dart';
import 'package:timely/common/scheduling/scheduling_output_page.dart';
import 'package:timely/modules/tab_7/controllers/output_controller.dart';
import 'package:timely/modules/tab_7/pages/tab_7_input_page.dart';

class Tab7OutputPage extends StatelessWidget {
  const Tab7OutputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SchedulingOutputPage(
      providerOfTab2Models: tab7OutputProvider,
      inputPage: const Tab7InputPage(),
    );
  }
}

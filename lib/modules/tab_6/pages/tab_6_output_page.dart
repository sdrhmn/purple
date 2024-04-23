import 'package:flutter/material.dart';
import 'package:timely/common/scheduling/scheduling_output_page.dart';
import 'package:timely/modules/tab_6/controllers/output_controller.dart';
import 'package:timely/modules/tab_6/pages/tab_6_input_page.dart';

class Tab6OutputPage extends StatelessWidget {
  const Tab6OutputPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SchedulingOutputPage(
      providerOfTab2Models: tab6OutputProvider,
      inputPage: const Tab6InputPage(),
    );
  }
}
